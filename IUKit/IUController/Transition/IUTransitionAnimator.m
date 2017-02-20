//
//  IUTransitionAnimator.m
//  IUController
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUTransitionAnimator.h"
#import "UIViewController+IUMagicTransition.h"
#import <objc/runtime.h>

typedef void(^_IUTransitionPrepare)(void);
typedef void(^_IUTransitionAnimations)(void);
typedef void(^_IUTransitionCompletion)(BOOL finished);

@interface IUTransitionAnimator ()

@property (nonatomic, strong) void(^__completeCallback)(void);

@end

@implementation IUTransitionAnimator

+ (instancetype)animatorWithTransitionOperation:(IUTransitionOperation)operation {
    return [self animatorWithTransitionOperation:operation type:IUTransitionTypeDefault];
}

+ (instancetype)animatorWithTransitionOperation:(IUTransitionOperation)operation type:(IUTransitionType)type {
    IUTransitionAnimator *animator = [[self alloc] init];
    animator->_operation = operation;
    animator->_type = type;
    return animator;
}

- (instancetype)init {
    if (self = [super init]) {
        self.duration = 0.35f;
        self.animationCurve = UIViewAnimationCurveLinear;
    }
    return self;
}

#pragma mark UIViewControllerTransitioningDelegate
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    _IUTransitionPrepare prepare = ^{};
    _IUTransitionAnimations animations = ^{};
    _IUTransitionCompletion completion = ^(BOOL finished){};
    
    // add view on container
    {
        switch (self.operation) {
            case IUTransitionOperationPush:
            case IUTransitionOperationPresent:
                if (toViewController.view.superview == nil) {
                    prepare = ^{
                        prepare();
                        [containerView addSubview:toViewController.view];
                    };
                }
                break;
            case IUTransitionOperationPop:
            case IUTransitionOperationDismiss:
                if (toViewController.view.superview == nil) {
                    prepare = ^{
                        prepare();
                        [containerView insertSubview:toViewController.view atIndex:0];
                    };
                }
                break;
            default:
                break;
        }
    }
    
    // dimmer
    do {
        if (!self.dimmerColor && !self.dimmerView) break;
        
        UIView *dimmerBackgroundView = [[UIView alloc] initWithFrame:containerView.bounds];
        dimmerBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if (self.dimmerColor) dimmerBackgroundView.backgroundColor = self.dimmerColor;
        if (self.dimmerView) {
            UIView *dimmerView = self.dimmerView;
            dimmerView.frame = dimmerBackgroundView.bounds;
            dimmerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [dimmerBackgroundView addSubview:dimmerView];
        }
        
        prepare = ^{
            prepare();
            [containerView insertSubview:dimmerBackgroundView belowSubview:fromViewController.view];
        };
        
        switch (self.operation) {
            case IUTransitionOperationPush:
            case IUTransitionOperationPresent:
            {
                animations = ^{
                    animations();
                    dimmerBackgroundView.alpha = 1.0;
                };
            }
                break;
            case IUTransitionOperationPop:
            case IUTransitionOperationDismiss:
            {
                animations = ^{
                    animations();
                    dimmerBackgroundView.alpha = 0.0;
                };
            }
                break;
            default:
                break;
        }
        
        completion = ^(BOOL finished) {
            completion(finished);
            [dimmerBackgroundView removeFromSuperview];
        };
    } while (0);
    
    // shadow
    {
        switch (self.type) {
            case IUTransitionTypeDefault:
                switch (self.operation) {
                    case IUTransitionOperationPush:
                    {
                        CGSize shadowOffset = toViewController.view.layer.shadowOffset;
                        CGColorRef shadowColor = toViewController.view.layer.shadowColor;
                        CGFloat shadowRadius = toViewController.view.layer.shadowRadius;
                        CGFloat shadowOpacity = toViewController.view.layer.shadowOpacity;

                        prepare = ^{
                            prepare();
                            toViewController.view.layer.shadowOffset = CGSizeMake(-5, 0);
                            toViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
                            toViewController.view.layer.shadowRadius = 2;
                            toViewController.view.layer.shadowOpacity = 0.1;
                        };
                        
                        completion = ^(BOOL finshed) {
                            completion(finshed);
                            toViewController.view.layer.shadowOffset = shadowOffset;
                            toViewController.view.layer.shadowColor = shadowColor;
                            toViewController.view.layer.shadowRadius = shadowRadius;
                            toViewController.view.layer.shadowOpacity = shadowOpacity;
                        };
                    }
                        break;
                    case IUTransitionOperationPop:
                    {
                        CGSize shadowOffset = fromViewController.view.layer.shadowOffset;
                        CGColorRef shadowColor = fromViewController.view.layer.shadowColor;
                        CGFloat shadowRadius = fromViewController.view.layer.shadowRadius;
                        CGFloat shadowOpacity = fromViewController.view.layer.shadowOpacity;
                        
                        prepare = ^{
                            prepare();
                            fromViewController.view.layer.shadowOffset = CGSizeMake(-5, 0);
                            fromViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
                            fromViewController.view.layer.shadowRadius = 2;
                            fromViewController.view.layer.shadowOpacity = 0.1;
                        };
                        
                        completion = ^(BOOL finshed) {
                            completion(finshed);
                            fromViewController.view.layer.shadowOffset = shadowOffset;
                            fromViewController.view.layer.shadowColor = shadowColor;
                            fromViewController.view.layer.shadowRadius = shadowRadius;
                            fromViewController.view.layer.shadowOpacity = shadowOpacity;
                        };
                    }
                        break;
                    case IUTransitionOperationPresent:
                    case IUTransitionOperationDismiss:
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
    }
    
    // view frame animation
    do {
        if (self.type == IUTransitionTypeCustom) break;
        
        #define IUTransitionDefaultDamping 0.3
        
        CGRect fromInitialFrame = [transitionContext initialFrameForViewController:fromViewController];
        CGRect toFinalFrame = [transitionContext finalFrameForViewController:toViewController];
        
        _IUTransitionPrepare    custom_prepare    = ^{};
        _IUTransitionAnimations custom_animations = ^{};
        _IUTransitionCompletion custom_completion = ^(BOOL finished){};

        switch (self.type) {
            case IUTransitionTypeDefault:
                switch (self.operation) {
                    case IUTransitionOperationPush:
                    {
                        custom_prepare = ^{
                            toViewController.view.frame = CGRectOffset(toFinalFrame, containerView.bounds.size.width, 0);
                        };
                        custom_animations = ^{
                            fromViewController.view.frame = CGRectOffset(fromInitialFrame, -containerView.bounds.size.width * IUTransitionDefaultDamping, 0);
                        };
                    }
                        break;
                    case IUTransitionOperationPop:
                    {
                        custom_prepare = ^{
                            toViewController.view.frame = CGRectOffset(toFinalFrame, -containerView.bounds.size.width * IUTransitionDefaultDamping, 0);
                        };
                        custom_animations = ^{
                            fromViewController.view.frame = CGRectOffset(fromInitialFrame, containerView.bounds.size.width, 0);
                        };
                    }
                        break;
                    case IUTransitionOperationPresent:
                    {
                        custom_prepare = ^{
                            toViewController.view.frame = CGRectOffset(toFinalFrame, 0, containerView.bounds.size.height);
                        };
                    }
                        break;
                    case IUTransitionOperationDismiss:
                    {
                        custom_animations = ^{
                            fromViewController.view.frame = CGRectOffset(fromInitialFrame, 0, containerView.bounds.size.height);
                        };
                    }
                        break;
                    default:
                        break;
                }
                break;
            case IUTransitionTypeFade:
                switch (self.operation) {
                    case IUTransitionOperationPush:
                    case IUTransitionOperationPresent:
                    {
                        custom_prepare = ^{
                            toViewController.view.frame = toFinalFrame;
                            [toViewController.view layoutIfNeeded];
                            toViewController.view.alpha = 0.0;
                        };
                        custom_animations = ^{
                            toViewController.view.alpha = 1.0;
                        };
                    }
                        break;
                    case IUTransitionOperationPop:
                    case IUTransitionOperationDismiss:
                    {
                        custom_animations = ^{
                            fromViewController.view.alpha = 0.0;
                        };
                        custom_completion = ^(BOOL finished){
                            fromViewController.view.alpha = 1.0;
                        };
                    }
                        break;
                    default:
                        break;
                }
                break;
            case IUTransitionTypeErase:
            {
                UIView *clipView = [[UIView alloc] init];
                clipView.clipsToBounds = YES;
#define _kEraserWidth 10
                UIView *eraser = [[UIView alloc] init];
                eraser.backgroundColor = [UINavigationBar appearance].barTintColor ?: [UIColor colorWithWhite:198/255.f alpha:1];

                switch (self.operation) {
                    case IUTransitionOperationPush:
                    {
                        custom_prepare = ^{                            
                            [containerView insertSubview:clipView aboveSubview:toViewController.view];
                            [containerView insertSubview:eraser aboveSubview:clipView];

                            eraser.frame = CGRectMake(containerView.bounds.size.width, 0, _kEraserWidth, containerView.bounds.size.height);

                            clipView.frame = CGRectOffset(toFinalFrame, containerView.bounds.size.width, 0);
                            toViewController.view.frame = [clipView convertRect:CGRectOffset(toFinalFrame, containerView.bounds.size.width * IUTransitionDefaultDamping, 0) fromView:containerView];
                            [clipView addSubview:toViewController.view];
                            
                        };
                        custom_animations = ^{
                            eraser.frame = CGRectMake(-_kEraserWidth, 0, _kEraserWidth, containerView.bounds.size.height);
                            clipView.frame = toFinalFrame;
                            toViewController.view.frame = [clipView convertRect:toFinalFrame fromView:containerView];
                            fromViewController.view.frame = CGRectOffset(fromInitialFrame, -containerView.bounds.size.width * IUTransitionDefaultDamping, 0);
                        };
                        custom_completion = ^(BOOL finished) {
                            if (![transitionContext transitionWasCancelled]) {
                                toViewController.view.frame = toFinalFrame;
                                [containerView addSubview:toViewController.view];
                                [containerView insertSubview:toViewController.view aboveSubview:clipView];
                            }
                            [clipView removeFromSuperview];
                            [eraser removeFromSuperview];
                        };
                    }
                        break;
                    case IUTransitionOperationPop:
                    {
                        custom_prepare = ^{
                            [containerView insertSubview:clipView aboveSubview:fromViewController.view];
                            [containerView insertSubview:eraser aboveSubview:clipView];
                            
                            eraser.frame = CGRectMake(-_kEraserWidth, 0, _kEraserWidth, containerView.bounds.size.height);
                            
                            clipView.frame = fromInitialFrame;
                            fromViewController.view.frame = [clipView convertRect:fromInitialFrame fromView:containerView];
                            [clipView addSubview:fromViewController.view];
                        };
                        custom_animations = ^{
                            eraser.frame = CGRectMake(containerView.bounds.size.width, 0, _kEraserWidth, containerView.bounds.size.height);
                            clipView.frame = CGRectOffset(fromInitialFrame, containerView.bounds.size.width, 0);
                            fromViewController.view.frame = [clipView convertRect:CGRectOffset(fromInitialFrame, containerView.bounds.size.width * IUTransitionDefaultDamping, 0) fromView:containerView];
                        };
                        custom_completion = ^(BOOL finished) {
                            if ([transitionContext transitionWasCancelled]) {
                                fromViewController.view.frame = fromInitialFrame;
                                [containerView insertSubview:fromViewController.view aboveSubview:clipView];
                            }
                            [clipView removeFromSuperview];
                            [eraser removeFromSuperview];
                        };
                    }
                        break;
                    case IUTransitionOperationPresent:
                    {
                        custom_prepare = ^{
                            [containerView insertSubview:clipView aboveSubview:toViewController.view];
                            [containerView insertSubview:eraser aboveSubview:clipView];

                            eraser.frame = CGRectMake(0, containerView.bounds.size.height, containerView.bounds.size.width, _kEraserWidth);
                            
                            clipView.frame = CGRectOffset(toFinalFrame, 0, containerView.bounds.size.height);
                            toViewController.view.frame = [clipView convertRect:CGRectOffset(toFinalFrame, 0, containerView.bounds.size.height * IUTransitionDefaultDamping) fromView:containerView];
                            [clipView addSubview:toViewController.view];
                        };
                        custom_animations = ^{
                            eraser.frame = CGRectMake(0, -_kEraserWidth, containerView.bounds.size.width, _kEraserWidth);
                            clipView.frame = toFinalFrame;
                            toViewController.view.frame = [clipView convertRect:toFinalFrame fromView:containerView];
                        };
                        custom_completion = ^(BOOL finished) {
                            if (![transitionContext transitionWasCancelled]) {
                                toViewController.view.frame = toFinalFrame;
                                [containerView insertSubview:toViewController.view aboveSubview:clipView];
                            }
                            [clipView removeFromSuperview];
                            [eraser removeFromSuperview];
                        };
                    }
                        break;
                    case IUTransitionOperationDismiss:
                    {
                        custom_prepare = ^{
                            [containerView insertSubview:clipView aboveSubview:fromViewController.view];
                            [containerView insertSubview:eraser aboveSubview:clipView];
                            eraser.frame = CGRectMake(0, -_kEraserWidth, containerView.bounds.size.width, _kEraserWidth);
                            
                            clipView.frame = fromInitialFrame;
                            fromViewController.view.frame = [clipView convertRect:fromInitialFrame fromView:containerView];
                            [clipView addSubview:fromViewController.view];
                        };
                        custom_animations = ^{
                            eraser.frame = CGRectMake(0, containerView.bounds.size.height,  containerView.bounds.size.width, _kEraserWidth);
                            clipView.frame = CGRectOffset(fromInitialFrame, 0, containerView.bounds.size.height);
                            fromViewController.view.frame = [clipView convertRect:CGRectOffset(fromInitialFrame, 0, containerView.bounds.size.height * IUTransitionDefaultDamping) fromView:containerView];
                        };
                        custom_completion = ^(BOOL finished) {
                            if ([transitionContext transitionWasCancelled]) {
                                fromViewController.view.frame = fromInitialFrame;
                                [containerView insertSubview:fromViewController.view aboveSubview:clipView];
                            }
                            [clipView removeFromSuperview];
                            [eraser removeFromSuperview];
                        };
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            default:
                break;
        }
        
        prepare = ^{
            prepare();
            fromViewController.view.frame = [transitionContext initialFrameForViewController:fromViewController];
            if (!CGRectEqualToRect(CGRectZero, [transitionContext initialFrameForViewController:toViewController])) {
                toViewController.view.frame = [transitionContext initialFrameForViewController:toViewController];
            }
            custom_prepare();
        };
        
        animations = ^{
            animations();
            toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
            if (!CGRectEqualToRect(CGRectZero, [transitionContext finalFrameForViewController:fromViewController])) {
                fromViewController.view.frame = [transitionContext finalFrameForViewController:fromViewController];
            }
            custom_animations();
        };
        
        completion = ^(BOOL finished) {
            completion(finished);
            custom_completion(finished);
        };
    } while (0);
    
    // call delegate
    {
        __weak typeof(self.delegate) delegate = self.delegate;
        
        if ([delegate respondsToSelector:@selector(transitionAnimator:willBeginTransition:)]) {
            prepare = ^{
                prepare();
                [delegate transitionAnimator:self willBeginTransition:transitionContext];
            };
        }
        
        if ([delegate respondsToSelector:@selector(transitionAnimator:willEndTransition:)]) {
            animations = ^{
                animations();
                [delegate transitionAnimator:self willEndTransition:transitionContext];
            };
        }
        
        if ([delegate respondsToSelector:@selector(transitionAnimator:didCompleteTransition:finished:)]) {
            completion = ^(BOOL finished) {
                completion(finished);
                [delegate transitionAnimator:self didCompleteTransition:transitionContext finished:finished];
            };
        }
    }
    
    [UIView performWithoutAnimation:^{
        fromViewController.view.userInteractionEnabled = NO;
        toViewController.view.userInteractionEnabled = NO;
        prepare();
    }];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | (self.animationCurve << 16)
                     animations: ^{
                         animations();
                     } completion:^(BOOL finished) {
                         
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         
                         completion(finished);
                         
                         fromViewController.view.userInteractionEnabled = YES;
                         toViewController.view.userInteractionEnabled = YES;
                         
                         // call block set in IUTransitioningDelegate
                         if (self.__completeCallback) self.__completeCallback();
                     }];
}

@end
