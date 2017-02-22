//
//  IUAlertPromptViewController.m
//  IUKitDemo
//
//  Created by admin on 2017/2/21.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUAlertPromptViewController.h"
#import "UIViewController+IUModalTransition.h"

@interface IUAlertPromptViewController () <IUTransitionAnimatorDelegate>

@property (nonatomic, strong) IUTransitioningDelegate *bottomSheetTransitionDelegate;

@end

@implementation IUAlertPromptViewController

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
            self.contentView.frame = CGRectMake((self.view.bounds.size.width - self.contentView.bounds.size.width) / 2.f, (self.view.bounds.size.height - self.contentView.bounds.size.height) / 2.f, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
            self.contentView.transform = CGAffineTransformMakeScale(1.15, 1.15);
        }];
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.frame = self.view.bounds;
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        _contentView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

- (IUTransitioningDelegate *)bottomSheetTransitionDelegate {
    if (_bottomSheetTransitionDelegate == nil) {
        _bottomSheetTransitionDelegate = [IUTransitioningDelegate transitioningDelegateWithType:IUTransitionTypeFade];
        __weak typeof(self) weakSelf = self;
        _bottomSheetTransitionDelegate.animatorConfiguration = ^(IUTransitionAnimator *animator) {
            animator.delegate = weakSelf;
            animator.duration = 0.2;
        };
    }
    return _bottomSheetTransitionDelegate;
}

@end
