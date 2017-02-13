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
}

- (void)iuNavigationBarHidden_UIViewController_viewWillAppear:(BOOL)animated {
    [self iuNavigationBarHidden_UIViewController_viewWillAppear:animated];
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
        [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:animated];
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    objc_setAssociatedObject(self, &TAG_NAVIGATION_BAR_HIDDEN, @(navigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)navigationBarHidden {
    return [objc_getAssociatedObject(self, &TAG_NAVIGATION_BAR_HIDDEN) boolValue];
}

@end
