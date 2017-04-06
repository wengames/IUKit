//
//  UIViewController+IUNavigationBarHidden.m
//  IUController
//
//  Created by admin on 2017/2/8.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IUNavigationBarHidden.h"
#import <objc/runtime.h>
#import "IUMethodSwizzling.h"

static char TAG_NAVIGATION_BAR_HIDDEN;

@implementation UIViewController (IUNavigationBarHidden)

+ (void)load {
    [self swizzleInstanceSelector:@selector(viewWillAppear:) toSelector:@selector(iuNavigationBarHidden_UIViewController_viewWillAppear:)];
    [self swizzleInstanceSelector:@selector(viewDidAppear:) toSelector:@selector(iuNavigationBarHidden_UIViewController_viewDidAppear:)];
}

- (void)iuNavigationBarHidden_UIViewController_viewWillAppear:(BOOL)animated {
    [self iuNavigationBarHidden_UIViewController_viewWillAppear:animated];
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
        [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:animated];
}

- (void)iuNavigationBarHidden_UIViewController_viewDidAppear:(BOOL)animated {
    [self iuNavigationBarHidden_UIViewController_viewDidAppear:animated];
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:NO];
        });
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    objc_setAssociatedObject(self, &TAG_NAVIGATION_BAR_HIDDEN, @(navigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)navigationBarHidden {
    return [objc_getAssociatedObject(self, &TAG_NAVIGATION_BAR_HIDDEN) boolValue];
}

@end
