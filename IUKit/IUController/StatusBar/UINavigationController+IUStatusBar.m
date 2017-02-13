//
//  UINavigationController+IUStatusBar.m
//  IUController
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UINavigationController+IUStatusBar.h"

@implementation UINavigationController (IUStatusBar)

- (UIStatusBarStyle)preferredStatusBarStyle {
    return (self.isNavigationBarHidden && self.topViewController) ? [self.topViewController preferredStatusBarStyle] : [super preferredStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.topViewController ? [self.topViewController preferredStatusBarUpdateAnimation] : [super preferredStatusBarUpdateAnimation];
}

- (BOOL)prefersStatusBarHidden {
    return self.topViewController ? [self.topViewController prefersStatusBarHidden] : [super prefersStatusBarHidden];
}

@end
