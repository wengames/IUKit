//
//  UIViewController+IUMagicTransition.m
//  IUController
//
//  Created by admin on 2017/2/7.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IUMagicTransition.h"
#import "IUMethodSwizzling.h"
#import <objc/runtime.h>

@implementation UIViewController (IUMagicTransition)

+ (void)load {
    [self swizzleInstanceSelector:@selector(viewWillAppear:) toSelector:@selector(iuMagicTransition_UIViewController_viewWillAppear:)];
}

- (void)iuMagicTransition_UIViewController_viewWillAppear:(BOOL)animated {
    [self iuMagicTransition_UIViewController_viewWillAppear:animated];
    
    if ([self.childViewControllers count]) return;

    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (!context.isAnimated) return;
        
        UIView *containerView = context.containerView;
        UIViewController *fromViewController = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController   = [context viewControllerForKey:UITransitionContextToViewControllerKey];
        
        NSLog(@"%@", fromViewController.view);
        NSLog(@"%@", toViewController.view);

        NSArray <UIView *> *fromMagicViews = [fromViewController magicViewsTransitionToViewController:toViewController];
        NSArray <UIView *> *toMagicViews = [toViewController magicViewsTransitionFromViewController:fromViewController];
        
        objc_setAssociatedObject(context, _cmd, fromMagicViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        for (int i = 0; i < [fromMagicViews count] && i < [toMagicViews count]; i++) {
            UIView *fromMagicView = fromMagicViews[i];
            UIView *toMagicView = toMagicViews[i];
            
            if (![fromMagicView isKindOfClass:[UIView class]] ||
                fromMagicView.window == nil ||
                ![toMagicView isKindOfClass:[UIView class]] ||
                toMagicView.window == nil) {
                continue;
            }
            
            __weak typeof(fromMagicView.superview) weakSuperview = fromMagicView.superview;
            CGRect fromFrame = fromMagicView.frame;
            BOOL toHidden = toMagicView.hidden;
            objc_setAssociatedObject(fromMagicView, _cmd, ^{
                [weakSuperview addSubview:fromMagicView];
                fromMagicView.frame = fromFrame;
                toMagicView.hidden = toHidden;
            }, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            UIView *(^transitionViewOf)(UIView *) = ^(UIView *view) {
                UIView *v = view;
                while (!CGSizeEqualToSize(v.bounds.size, containerView.bounds.size) ) {
                    v = v.superview;
                }
                return v;
            };
            
            [UIView performWithoutAnimation:^{
                fromMagicView.frame = [transitionViewOf(fromMagicView) convertRect:fromMagicView.bounds fromView:fromMagicView];
                [containerView addSubview:fromMagicView];
                toMagicView.hidden = YES;
            }];
            
            fromMagicView.frame = [transitionViewOf(toMagicView) convertRect:toMagicView.bounds fromView:toMagicView];
        }
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        NSArray *magicViews = objc_getAssociatedObject(context, _cmd);
        objc_setAssociatedObject(context, _cmd, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        for (UIView *magicView in magicViews) {
            void(^block)(void) = objc_getAssociatedObject(magicView, _cmd);
            objc_setAssociatedObject(magicView, _cmd, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (block) block();
        }
    }];
}

- (NSArray *)magicViewsTransitionToViewController:(UIViewController *)viewController {
    return nil;
}

- (NSArray *)magicViewsTransitionFromViewController:(UIViewController *)viewController {
    return nil;
}

@end

@interface UINavigationController (IUMagicTransition)

@end

@implementation UINavigationController (IUMagicTransition)

- (NSArray *)magicViewsTransitionToViewController:(UIViewController *)viewController {
    return [self.topViewController magicViewsTransitionToViewController:viewController];
}

- (NSArray *)magicViewsTransitionFromViewController:(UIViewController *)viewController {
    return [self.topViewController magicViewsTransitionFromViewController:viewController];
}

@end

@interface UITabBarController (IUMagicTransition)

@end

@implementation UITabBarController (IUMagicTransition)

- (NSArray *)magicViewsTransitionToViewController:(UIViewController *)viewController {
    return [self.selectedViewController magicViewsTransitionToViewController:viewController];
}

- (NSArray *)magicViewsTransitionFromViewController:(UIViewController *)viewController {
    return [self.selectedViewController magicViewsTransitionFromViewController:viewController];
}

@end
