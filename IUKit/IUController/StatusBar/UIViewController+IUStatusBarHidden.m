//
//  UIViewController+IUStatusBarHidden.m
//  IUController
//
//  Created by admin on 2017/1/24.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IUStatusBarHidden.h"
#import "objc/runtime.h"

static char TAG_VIEW_CONTROLLER_STATUS_BAR_HIDDEN;

@implementation UIViewController (IUStatusBarHidden)

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_STATUS_BAR_HIDDEN, @(statusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)statusBarHidden {
    return [objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_STATUS_BAR_HIDDEN) boolValue];
}

- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}

@end
