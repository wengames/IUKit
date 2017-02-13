//
//  IUTransitionAnimator.h
//  IUController
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    IUTransitionOperationNone    = UINavigationControllerOperationNone,
    IUTransitionOperationPush    = UINavigationControllerOperationPush,
    IUTransitionOperationPop     = UINavigationControllerOperationPop,
    IUTransitionOperationPresent,
    IUTransitionOperationDismiss
} IUTransitionOperation;

typedef enum {
    IUTransitionTypeDefault = 0,
    IUTransitionTypeFade,
    IUTransitionTypeErase,
    IUTransitionTypeCustom
} IUTransitionType;

@protocol IUTransitionAnimatorDelegate;

@interface IUTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) IUTransitionOperation operation;
@property (nonatomic, assign) IUTransitionType type;

@property (nonatomic, weak) id <IUTransitionAnimatorDelegate> delegate;

@property (nonatomic, assign) float    duration;
@property (nonatomic, strong) UIColor *dimmerColor;
@property (nonatomic, strong) UIView  *dimmerView;
@property (nonatomic, assign) UIViewAnimationCurve animationCurve; // default is UIViewAnimationCurveEaseOut

+ (instancetype)animatorWithTransitionOperation:(IUTransitionOperation)operation;
+ (instancetype)animatorWithTransitionOperation:(IUTransitionOperation)operation type:(IUTransitionType)type;

@end

@protocol IUTransitionAnimatorDelegate <NSObject>

@optional
- (void)transitionAnimator:(IUTransitionAnimator *)transitionAnimator willBeginTransition:(id <UIViewControllerContextTransitioning>)transitionContext;
- (void)transitionAnimator:(IUTransitionAnimator *)transitionAnimator willEndTransition:(id <UIViewControllerContextTransitioning>)transitionContext;
- (void)transitionAnimator:(IUTransitionAnimator *)transitionAnimator didCompleteTransition:(id <UIViewControllerContextTransitioning>)transitionContext finished:(BOOL)finished;
@end
