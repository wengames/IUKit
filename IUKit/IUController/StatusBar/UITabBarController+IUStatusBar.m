//
//  UITabBarController+IUStatusBar.m
//  IUController
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UITabBarController+IUStatusBar.h"

@implementation UITabBarController (IUStatusBar)

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.selectedViewController ? [self.selectedViewController preferredStatusBarStyle] : [super preferredStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.selectedViewController ? [self.selectedViewController preferredStatusBarUpdateAnimation] : [super preferredStatusBarUpdateAnimation];
}

- (BOOL)prefersStatusBarHidden {
    return self.selectedViewController ? [self.selectedViewController prefersStatusBarHidden] : [super prefersStatusBarHidden];
}

@end
