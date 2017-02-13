//
//  UINavigationController+IUOrientation.m
//  IUController
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UINavigationController+IUOrientation.h"

@implementation UINavigationController (IUOrientation)

- (BOOL)shouldAutorotate {
    return self.topViewController ? [self.topViewController shouldAutorotate] : [super shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController ? [self.topViewController supportedInterfaceOrientations] : [super supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController ? [self.topViewController preferredInterfaceOrientationForPresentation] : [super preferredInterfaceOrientationForPresentation];
}

@end
