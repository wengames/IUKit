//
//  UIViewController+IUPreviewing.m
//  IUController
//
//  Created by admin on 2017/2/8.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IUPreviewing.h"
#import <objc/runtime.h>
#import "IUMethodSwizzling.h"

static char TAG_VIEW_CONTROLLER_GENERATOR;

@implementation UIViewController (IUPreviewing)

- (BOOL)canRegisterForPreviewing {
    return [self respondsToSelector:@selector(traitCollection)] && [self.traitCollection respondsToSelector:@selector(forceTouchCapability)] && self.traitCollection.forceTouchCapability != UIForceTouchCapabilityUnavailable && [self respondsToSelector:@selector(registerForPreviewingWithDelegate:sourceView:)];
}

- (void)registerPreviewingWithSourceView:(UIView *)sourceView {
    [self registerPreviewingViewController:nil withSourceView:sourceView];
}

- (void)registerPreviewingViewController:(UIViewController *(^)())viewController withSourceView:(UIView *)sourceView {
    if ([self canRegisterForPreviewing]) {
        if ([self registerForPreviewingWithDelegate:self sourceView:sourceView]) {
            objc_setAssociatedObject(sourceView, &TAG_VIEW_CONTROLLER_GENERATOR, viewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

- (UIViewController *)viewControllerForPreviewingWithSourceView:(UIView *)sourceView {
    return nil;
}

#pragma mark - UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    UIView *sourceView = previewingContext.sourceView;
    UIViewController *viewController = nil;
    UIViewController *(^generator)() = objc_getAssociatedObject(sourceView, &TAG_VIEW_CONTROLLER_GENERATOR);
    if (generator) {
        viewController = generator();
    } else {
        viewController = [self viewControllerForPreviewingWithSourceView:sourceView];
    }
    
    if (viewController) {
        if ([viewController isKindOfClass:[UINavigationController class]]) return viewController;
        @try { [viewController setValue:nil forKey:@"dismissButtonItem"]; } @catch (NSException *exception) {}
        return [[UINavigationController alloc] initWithRootViewController:viewController];
    }
    return nil;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    if (self.navigationController) {
        NSArray *viewControllers = nil;
        if ([viewControllerToCommit isKindOfClass:[UINavigationController class]]) {
            viewControllers = [(UINavigationController *)viewControllerToCommit viewControllers];
        } else {
            viewControllers = @[viewControllerToCommit];
        }
        self.navigationController.viewControllers = [(self.navigationController.viewControllers ?: @[]) arrayByAddingObjectsFromArray:viewControllers];
    } else {
        [self presentViewController:viewControllerToCommit animated:NO completion:nil];
    }
}

@end
