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

@synthesize contentView = _contentView;

- (void)setModalType:(IUTransitionType)modalType {
    // override super
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.transitioningDelegate = self.bottomSheetTransitionDelegate;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [UIView performWithoutAnimation:^{
            self.contentView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.contentView.bounds.size.height);
        }];
        self.contentView.frame = CGRectMake(0, self.view.bounds.size.height - self.contentView.bounds.size.height, self.view.bounds.size.width, self.contentView.bounds.size.height);
    } completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.contentView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.contentView.bounds.size.height);
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.contentView.frame = CGRectMake(0, self.view.bounds.size.height - self.contentView.bounds.size.height, self.view.bounds.size.width, self.contentView.bounds.size.height);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.frame = self.view.bounds;
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        _contentView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

- (IUTransitioningDelegate *)bottomSheetTransitionDelegate {
    if (_bottomSheetTransitionDelegate == nil) {
        _bottomSheetTransitionDelegate = [IUTransitioningDelegate transitioningDelegateWithType:IUTransitionTypeCustom];
        __weak typeof(self) weakSelf = self;
        _bottomSheetTransitionDelegate.animatorConfiguration = ^(IUTransitionAnimator *animator) {
            animator.delegate = weakSelf;
            animator.dimmerColor = weakSelf.view.backgroundColor;
            switch (animator.operation) {
                case IUTransitionOperationPresent:
                    animator.animationCurve = UIViewAnimationCurveEaseOut;
                    animator.duration = weakSelf.contentView.bounds.size.height / self.view.bounds.size.height * 0.9;
                    break;
                case IUTransitionOperationDismiss:
                    animator.animationCurve = UIViewAnimationCurveEaseIn;
                    animator.duration = weakSelf.contentView.bounds.size.height / self.view.bounds.size.height * 0.6;
                    break;
                    
                default:
                    break;
            }
        };
    }
    return _bottomSheetTransitionDelegate;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (_contentView && !CGRectContainsPoint(_contentView.bounds, [touch locationInView:_contentView])) {
        [self dismiss];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
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
