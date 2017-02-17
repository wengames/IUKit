//
//  UIViewController+IUModalTransition.h
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IUTransitioningDelegate.h"

@interface UIViewController (IUModalTransition) <IUTransitionAnimatorDelegate>

@property (nonatomic, assign) IUTransitionType modalType;
@property (nonatomic, strong) void(^animatorConfiguration)(IUTransitionAnimator *);

@end
