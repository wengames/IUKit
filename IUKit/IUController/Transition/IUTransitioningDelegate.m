//
//  IUTransitioningDelegate.m
//  IUController
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUTransitioningDelegate.h"

@interface IUTransitionAnimator ()

@property (nonatomic, strong) void(^__completeCallback)(void);

@end

@interface IUTransitioningDelegate ()

@property (nonatomic, assign) BOOL isTransitioning;
@property (nonatomic, assign) BOOL interactiveTransitionEnabled; // defaults NO, set enabled when interactive transition began, and disable it later.

@end

@implementation IUTransitioningDelegate

@synthesize interactiveTransition = _interactiveTransition;

+ (instancetype)transitioningDelegateWithType:(IUTransitionType)type {
    IUTransitioningDelegate *transitioningDelegate = [[self alloc] init];
    transitioningDelegate.type = type;
    return transitioningDelegate;
}

- (UIPercentDrivenInteractiveTransition *)interactiveTransition {
    if (_interactiveTransition == nil) {
        _interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        _interactiveTransition.completionCurve = UIViewAnimationCurveLinear;
    }
    return _interactiveTransition;
}

- (void)beginInteractiveTransition {
    self.interactiveTransitionEnabled = YES;
}

- (void)endInteractiveTransition {
    self.interactiveTransitionEnabled = NO;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if (self.type == IUTransitionTypeFade) {
        presented.modalPresentationStyle = UIModalPresentationCustom;
    }
    IUTransitionAnimator *animator = [IUTransitionAnimator animatorWithTransitionOperation:IUTransitionOperationPresent type:self.type];
    if (self.animatorConfiguration) self.animatorConfiguration(animator);
    return animator;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    id<UIViewControllerInteractiveTransitioning> transition = self.interactiveTransitionEnabled ? self.interactiveTransition : nil;
    self.interactiveTransitionEnabled = NO;
    return transition;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    IUTransitionAnimator *animator = [IUTransitionAnimator animatorWithTransitionOperation:IUTransitionOperationDismiss type:self.type];
    if (self.animatorConfiguration) self.animatorConfiguration(animator);
    return animator;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    id<UIViewControllerInteractiveTransitioning> transition = self.interactiveTransitionEnabled ? self.interactiveTransition : nil;
    self.interactiveTransitionEnabled = NO;
    return transition;
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    self.isTransitioning = YES;
    IUTransitionAnimator *animator = [IUTransitionAnimator animatorWithTransitionOperation:(IUTransitionOperation)operation type:self.type];
    if (self.animatorConfiguration) self.animatorConfiguration(animator);
    __weak typeof(self) weakSelf = self;
    animator.__completeCallback = ^ {
        weakSelf.isTransitioning = NO;
    };
    return animator;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    id<UIViewControllerInteractiveTransitioning> transition = self.interactiveTransitionEnabled ? self.interactiveTransition : nil;
    self.interactiveTransitionEnabled = NO;
    return transition;
}

#pragma mark - redirect
- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [self.delegate respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.delegate respondsToSelector:aSelector]) {
        return self.delegate;
    }
    return self;
}

@end
