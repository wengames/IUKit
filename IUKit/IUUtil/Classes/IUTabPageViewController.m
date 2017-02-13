//
//  IUTabPageViewController.m
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUTabPageViewController.h"
#import <objc/runtime.h>

static char TAG_TAB_BADGE_LABEL;

@implementation IUTabPageViewController

@synthesize tabPageView = _tabPageView;

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (self.navigationController) {
        UIGestureRecognizer *gestureRecognizer = nil;
        @try {
            gestureRecognizer = [self.navigationController valueForKey:@"edgeScreenInteractivePopGestureRecognizer"];
        } @catch (NSException *exception) {
            gestureRecognizer = self.navigationController.interactivePopGestureRecognizer;
        }
        [self.tabPageView.tabCollectionView.panGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
        [self.tabPageView.pageCollectionView.panGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabPageView.frame = self.view.bounds;
    [self.view addSubview:self.tabPageView];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers {
    _viewControllers = viewControllers;
    [self.tabPageView reloadTabsAndPages];
}

- (IUTabPageView *)tabPageView {
    if (_tabPageView == nil) {
        _tabPageView = [[IUTabPageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _tabPageView.delegate = self;
        _tabPageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _tabPageView;
}

#pragma mark - IUTabPageViewDelegate
- (NSUInteger)numberOfTabsInTabPageView:(IUTabPageView *)tabPageView {
    return [self.viewControllers count];
}

- (NSString *)tabPageView:(IUTabPageView *)tabPageView titleForTabAtIndex:(NSInteger)index {
    return self.viewControllers[index].tabBarItem.title;
}

- (void)tabPageView:(IUTabPageView *)tabPageView willDisplayTabCustomView:(UIView *)tabCustomView atIndex:(NSInteger)index {
    UILabel *badgeLabel = objc_getAssociatedObject(tabCustomView, &TAG_TAB_BADGE_LABEL);
    if (badgeLabel == nil) {
        badgeLabel = [[UILabel alloc] init];
        objc_setAssociatedObject(tabCustomView, &TAG_TAB_BADGE_LABEL, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        badgeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.layer.cornerRadius = 8;
        badgeLabel.layer.masksToBounds = YES;
        badgeLabel.textColor = [UIColor whiteColor];
        badgeLabel.backgroundColor = [UIColor redColor];
        [tabCustomView addSubview:badgeLabel];
    }
    
    NSInteger badgeNumber = [self.viewControllers[index].tabBarItem.badgeValue integerValue];
    badgeLabel.hidden = badgeNumber <= 0;
    if (badgeNumber > 0) {
        if (badgeNumber > 99) {
            badgeLabel.text = @"99+";
        } else {
            badgeLabel.text = [NSString stringWithFormat:@"%ld", (long)badgeNumber];
        }
        [badgeLabel sizeToFit];
        CGRect frame = badgeLabel.frame;
        frame.size.width += 6;
        if (frame.size.width < 16) frame.size.width = 16;
        frame.size.height = 16;
        frame.origin.x = tabCustomView.bounds.size.width - 8 - frame.size.width / 2.f;
        frame.origin.y = 8;
        badgeLabel.frame = frame;
    }
}

- (void)tabPageView:(IUTabPageView *)tabPageView willDisplayPageCustomView:(UIView *)pageCustomView atIndex:(NSInteger)index {
    [self removeAllSubviewsOnView:pageCustomView];
    
    UIViewController *targetViewController = self.viewControllers[index];
    [targetViewController beginAppearanceTransition:YES animated:NO];
    targetViewController.view.frame = pageCustomView.bounds;
    [pageCustomView addSubview:targetViewController.view];
    [targetViewController endAppearanceTransition];
}

- (void)tabPageView:(IUTabPageView *)tabPageView didEndDisplayingPageCustomView:(UIView *)pageCustomView atIndex:(NSInteger)index {
    [self.viewControllers[index] beginAppearanceTransition:NO animated:NO];
    [self removeAllSubviewsOnView:pageCustomView];
    [self.viewControllers[index] endAppearanceTransition];
}

- (void)removeAllSubviewsOnView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        [subview removeFromSuperview];
    }
}

@end
