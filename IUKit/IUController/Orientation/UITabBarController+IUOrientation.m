//
//  UITabBarController+IUOrientation.m
//  IUController
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UITabBarController+IUOrientation.h"

@implementation UITabBarController (IUOrientation)

- (BOOL)shouldAutorotate {
    return self.selectedViewController ? [self.selectedViewController shouldAutorotate] : [super shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.selectedViewController ? [self.selectedViewController supportedInterfaceOrientations] : [super supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.selectedViewController ? [self.selectedViewController preferredInterfaceOrientationForPresentation] : [super preferredInterfaceOrientationForPresentation];
}

@end
