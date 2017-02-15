//
//  IUBottomSheetViewController.m
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUBottomSheetViewController.h"
#import "UIViewController+IUModalTransition.h"

@interface IUBottomSheetViewController () <IUTransitionAnimatorDelegate>
{
    UIColor *_backgroundColor;
}
@property (nonatomic, strong) IUTransitioningDelegate *bottomSheetTransitionDelegate;

@end

@implementation IUBottomSheetViewController

- (void)setModalType:(IUTransitionType)modalType {
    // override
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.transitioningDelegate = self.bottomSheetTransitionDelegate;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (IUTransitioningDelegate *)bottomSheetTransitionDelegate {
    if (_bottomSheetTransitionDelegate == nil) {
        _bottomSheetTransitionDelegate = [IUTransitioningDelegate transitioningDelegateWithType:IUTransitionTypeFade];
        __weak typeof(self) weakSelf = self;
        _bottomSheetTransitionDelegate.animatorConfiguration = ^(IUTransitionAnimator *animator) {
            animator.delegate = weakSelf;
            animator.dimmerColor = weakSelf.view.backgroundColor;
        };
    }
    return _bottomSheetTransitionDelegate;
}

#pragma mark - IUTransitionAnimatorDelegate
- (void)transitionAnimator:(IUTransitionAnimator *)transitionAnimator willBeginTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    _backgroundColor = self.view.backgroundColor;
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)transitionAnimator:(IUTransitionAnimator *)transitionAnimator didCompleteTransition:(id <UIViewControllerContextTransitioning>)transitionContext finished:(BOOL)finished {
    self.view.backgroundColor = _backgroundColor;
}

@end
