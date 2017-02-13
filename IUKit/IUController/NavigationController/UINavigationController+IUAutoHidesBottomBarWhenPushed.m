//
//  UINavigationController+IUAutoHidesBottomBarWhenPushed.m
//  IUController
//
//  Created by admin on 2017/1/24.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UINavigationController+IUAutoHidesBottomBarWhenPushed.h"
#import "objc/runtime.h"
#import "IUMethodSwizzling.h"

static char TAG_NAVIGATION_CONTROLLER_INNER_DELEGATE;
static char TAG_VIEW_CONTROLLER_IGNORE_AUTO_HIDES_BOTTOM_BAR_WHEN_PUSHED;

#pragma mark - _IUNavigationInnerDelegate
@interface _IUNavigationInnerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation _IUNavigationInnerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return [self.navigationController.viewControllers count] > 1;
}

@end

#pragma mark - UIViewController
@implementation UIViewController (IUAutoHidesBottomBarWhenPushed)

- (void)setIgnoreAutoHidesBottomBarWhenPushed:(BOOL)ignoreAutoHidesBottomBarWhenPushed {
    objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_IGNORE_AUTO_HIDES_BOTTOM_BAR_WHEN_PUSHED, @(ignoreAutoHidesBottomBarWhenPushed), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ignoreAutoHidesBottomBarWhenPushed {
    return [objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_IGNORE_AUTO_HIDES_BOTTOM_BAR_WHEN_PUSHED) boolValue];
}

- (void)_setHidesBottomBarWhenPushedIfNotIgnored:(BOOL)hidesBottomBarWhenPushed {
    if (!self.ignoreAutoHidesBottomBarWhenPushed) self.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed;
}

@end

#pragma mark - UINavigationController

@implementation UINavigationController (IUAutoHidesBottomBarWhenPushed)

+ (void)load {
    [self swizzleInstanceSelector:@selector(pushViewController:animated:) toSelector:@selector(iuAutoHidesBottomBarWhenPushed_UINavigationContorller_pushViewController:animated:)];
    [self swizzleInstanceSelector:@selector(popViewControllerAnimated:) toSelector:@selector(iuAutoHidesBottomBarWhenPushed_UINavigationContorller_popViewControllerAnimated:)];
    [self swizzleInstanceSelector:@selector(popToRootViewControllerAnimated:) toSelector:@selector(iuAutoHidesBottomBarWhenPushed_UINavigationContorller_popToRootViewControllerAnimated:)];
    [self swizzleInstanceSelector:@selector(popToViewController:animated:) toSelector:@selector(iuAutoHidesBottomBarWhenPushed_UINavigationContorller_popToViewController:animated:)];
    [self swizzleInstanceSelector:@selector(setViewControllers:animated:) toSelector:@selector(iuAutoHidesBottomBarWhenPushed_UINavigationContorller_setViewControllers:animated:)];
}

#pragma mark Override Push & Pop Method
- (void)iuAutoHidesBottomBarWhenPushed_UINavigationContorller_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController _setHidesBottomBarWhenPushedIfNotIgnored:[self.viewControllers count] != 0];
    [self iuAutoHidesBottomBarWhenPushed_UINavigationContorller_pushViewController:viewController animated:animated];
    [self _resetDelegate];
}

- (UIViewController *)iuAutoHidesBottomBarWhenPushed_UINavigationContorller_popViewControllerAnimated:(BOOL)animated {
    NSUInteger count = [self.viewControllers count];
    if (count > 1 && !self.viewControllers[count - 2].ignoreAutoHidesBottomBarWhenPushed) {
        [self.viewControllers[count - 2] _setHidesBottomBarWhenPushedIfNotIgnored:count > 2];
    }
    return [self iuAutoHidesBottomBarWhenPushed_UINavigationContorller_popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)iuAutoHidesBottomBarWhenPushed_UINavigationContorller_popToRootViewControllerAnimated:(BOOL)animated {
    [[self.viewControllers firstObject] _setHidesBottomBarWhenPushedIfNotIgnored:NO];
    return [self iuAutoHidesBottomBarWhenPushed_UINavigationContorller_popToRootViewControllerAnimated:animated];
}

- (NSArray *)iuAutoHidesBottomBarWhenPushed_UINavigationContorller_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController _setHidesBottomBarWhenPushedIfNotIgnored:[self.viewControllers indexOfObject:viewController] != 0];
    return [self iuAutoHidesBottomBarWhenPushed_UINavigationContorller_popToViewController:viewController animated:animated];
}

- (void)iuAutoHidesBottomBarWhenPushed_UINavigationContorller_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    [[viewControllers lastObject] _setHidesBottomBarWhenPushedIfNotIgnored:[viewControllers count] > 1];
    [self iuAutoHidesBottomBarWhenPushed_UINavigationContorller_setViewControllers:viewControllers animated:animated];
    [self _resetDelegate];
}

#pragma mark Private Method
- (void)_resetDelegate {
    if (self.interactivePopGestureRecognizer.delegate != self._innerDelegate) self.interactivePopGestureRecognizer.delegate = self._innerDelegate;
}

- (_IUNavigationInnerDelegate *)_innerDelegate {
    _IUNavigationInnerDelegate *delegate = objc_getAssociatedObject(self, &TAG_NAVIGATION_CONTROLLER_INNER_DELEGATE);
    if (delegate == nil) {
        delegate = [[_IUNavigationInnerDelegate alloc] init];
        delegate.navigationController = self;
        objc_setAssociatedObject(self, &TAG_NAVIGATION_CONTROLLER_INNER_DELEGATE, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

@end
