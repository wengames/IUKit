//
//  UIViewController+IUAppear.m
//  IUController
//
//  Created by admin on 2017/2/8.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IUAppear.h"
#import <objc/runtime.h>
#import "IUMethodSwizzling.h"

static char TAG_VIEW_WILL_APPEAR;
static char TAG_VIEW_DID_APPEAR;

@implementation UIViewController (IUAppear)

+ (void)load {
    [self swizzleInstanceSelector:@selector(viewWillAppear:) toSelector:@selector(iuAppear_UIViewController_viewWillAppear:)];
    [self swizzleInstanceSelector:@selector(viewDidAppear:) toSelector:@selector(iuAppear_UIViewController_viewDidAppear:)];
}

- (void)iuAppear_UIViewController_viewWillAppear:(BOOL)animated {
    [self iuAppear_UIViewController_viewWillAppear:animated];
    if (![objc_getAssociatedObject(self, &TAG_VIEW_WILL_APPEAR) boolValue]) {
        objc_setAssociatedObject(self, &TAG_VIEW_WILL_APPEAR, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self viewWillAppearForTheFirstTime:animated];
    }
}

- (void)iuAppear_UIViewController_viewDidAppear:(BOOL)animated {
    [self iuAppear_UIViewController_viewDidAppear:animated];
    if (![objc_getAssociatedObject(self, &TAG_VIEW_DID_APPEAR) boolValue]) {
        objc_setAssociatedObject(self, &TAG_VIEW_DID_APPEAR, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self viewDidAppearForTheFirstTime:animated];
    }
}

- (void)viewWillAppearForTheFirstTime:(BOOL)animated {}
- (void)viewDidAppearForTheFirstTime:(BOOL)animated {}

@end
