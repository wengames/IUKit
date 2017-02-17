//
//  UIViewController+IUModalTransition.m
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IUModalTransition.h"
#import <objc/runtime.h>

static char TAG_ANIMATOR_CONFIGURATION;

@interface UIViewController ()

@property (nonatomic, strong, readonly) IUTransitioningDelegate *_iuTransitionDelegate;

@end

@implementation UIViewController (IUModalTransition)

- (IUTransitionType)modalType {
    return self._iuTransitionDelegate.type;
}

- (void)setModalType:(IUTransitionType)modalType {
    self._iuTransitionDelegate.type = modalType;
}

- (void)setAnimatorConfiguration:(void (^)(IUTransitionAnimator *))animatorConfiguration {
    objc_setAssociatedObject(self, &TAG_ANIMATOR_CONFIGURATION, animatorConfiguration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(IUTransitionAnimator *))animatorConfiguration {
    return objc_getAssociatedObject(self, &TAG_ANIMATOR_CONFIGURATION);
}

- (IUTransitioningDelegate *)_iuTransitionDelegate {
    IUTransitioningDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (delegate == nil) {
        delegate = [IUTransitioningDelegate transitioningDelegateWithType:IUTransitionTypeDefault];
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        __weak typeof(self) weakSelf = self;
        delegate.animatorConfiguration = ^(IUTransitionAnimator *animator) {
            animator.delegate = self;
            if (weakSelf.animatorConfiguration) {
                weakSelf.animatorConfiguration(animator);
            }
        };
        self.transitioningDelegate = delegate;
    }
    return delegate;
}

@end
