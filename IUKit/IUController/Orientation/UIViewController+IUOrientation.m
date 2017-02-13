//
//  UIViewController+IUOrientation.m
//  IUController
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IUOrientation.h"
#import "IUMethodSwizzling.h"

@implementation UIViewController (IUOrientation)

+ (void)load {
    [self swizzleInstanceSelector:@selector(viewWillAppear:) toSelector:@selector(iuOrientation_UIViewController_viewWillAppear:)];
}

- (void)iuOrientation_UIViewController_viewWillAppear:(BOOL)animated {
    [self iuOrientation_UIViewController_viewWillAppear:animated];
    if (self.navigationController && ([self supportedInterfaceOrientations] & (1 << [[UIApplication sharedApplication] statusBarOrientation])) == 0) {
        [self presentViewController:[[UIViewController alloc] init] animated:NO completion:nil];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    [self.class attemptRotationToDeviceOrientation];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
