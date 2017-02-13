//
//  UIViewController+IUStatusBarAutoRefresh.m
//  IUController
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IUStatusBarAutoRefresh.h"
#import "objc/runtime.h"
#import "IUMethodSwizzling.h"

@implementation UIViewController (IUStatusBarAutoRefresh)

+ (void)load {
    [self swizzleInstanceSelector:@selector(viewDidLayoutSubviews) toSelector:@selector(iuStatusBarAutoRefresh_UIViewController_viewDidLayoutSubviews)];
    [self swizzleInstanceSelector:@selector(viewDidAppear:) toSelector:@selector(iuStatusBarAutoRefresh_UIViewController_viewDidAppear:)];
}

- (void)iuStatusBarAutoRefresh_UIViewController_viewDidLayoutSubviews {
    [self iuStatusBarAutoRefresh_UIViewController_viewDidLayoutSubviews];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)iuStatusBarAutoRefresh_UIViewController_viewDidAppear:(BOOL)animated {
    [self iuStatusBarAutoRefresh_UIViewController_viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
