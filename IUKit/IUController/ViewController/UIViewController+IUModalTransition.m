//
//  UIViewController+IUModalTransition.m
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IUModalTransition.h"
#import <objc/runtime.h>

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

- (IUTransitioningDelegate *)_iuTransitionDelegate {
    IUTransitioningDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (delegate == nil) {
        delegate = [IUTransitioningDelegate transitioningDelegateWithType:IUTransitionTypeDefault];
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        delegate.animatorConfiguration = ^(IUTransitionAnimator *animator) {
            animator.delegate = self;
        };
        self.transitioningDelegate = delegate;
    }
    return delegate;
}

@end
