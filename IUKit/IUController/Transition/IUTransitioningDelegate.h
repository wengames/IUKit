//
//  IUTransitioningDelegate.h
//  IUController
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IUTransitionAnimator.h"

@interface IUTransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>

@property (nonatomic, readonly) BOOL isTransitioning;

@property (nonatomic, weak)   id<UINavigationControllerDelegate> delegate; // set to get other method in Protocol UINavigationControllerDelegate invoked if needed

@property (nonatomic, assign) IUTransitionType type;
@property (nonatomic, strong) void(^animatorConfiguration)(IUTransitionAnimator *animator);

@property (nonatomic, strong, readonly) UIPercentDrivenInteractiveTransition *interactiveTransition;
- (void)beginInteractiveTransition; // call before transition began
- (void)endInteractiveTransition; // call after transition end

+ (instancetype)transitioningDelegateWithType:(IUTransitionType)type;

@end
