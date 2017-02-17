//
//  UINavigationController+IUFullScreenInteractivePopGestureRecognizer.m
//  IUController
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UINavigationController+IUFullScreenInteractivePopGestureRecognizer.h"
#import "IUTransitioningDelegate.h"
#import <objc/runtime.h>
#import "IUMethodSwizzling.h"

static char TAG_TRANSITION_GESTURE_RECOGNIZER_HELPER;

@interface _IUNavigationControllerGestureRecognizerHelper : NSObject <UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@property (nonatomic, strong, readonly) UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer  *panGestureRecognizer;
@property (nonatomic, strong, readonly) IUTransitioningDelegate *transitioningDelegate;

@end

@interface UIViewController (_IUShowDismissButtonItem)

- (void)_showDismissButtonItem:(BOOL)show;

@end

@interface UINavigationController ()

@property (nonatomic, strong, readonly) _IUNavigationControllerGestureRecognizerHelper *transitionGestureRecognizerHelper;

@end

@implementation UINavigationController (IUFullScreenInteractivePopGestureRecognizer)

+ (void)load {
    [self swizzleInstanceSelector:@selector(setDelegate:) toSelector:@selector(iuFullScreenInteractivePopGestureRecognizer_UINavigationController_setDelegate:)];
    [self swizzleInstanceSelector:@selector(viewWillAppear:) toSelector:@selector(iuFullScreenInteractivePopGestureRecognizer_UINavigationController_viewWillAppear:)];
    [self swizzleInstanceSelector:@selector(viewDidLoad) toSelector:@selector(iuFullScreenInteractivePopGestureRecognizer_UINavigationController_viewDidLoad)];
}

- (void)iuFullScreenInteractivePopGestureRecognizer_UINavigationController_viewWillAppear:(BOOL)animated {
    [self iuFullScreenInteractivePopGestureRecognizer_UINavigationController_viewWillAppear:animated];
    [[self.viewControllers firstObject] _showDismissButtonItem:self.presentingViewController != nil];
}

- (void)iuFullScreenInteractivePopGestureRecognizer_UINavigationController_viewDidLoad {
    [self iuFullScreenInteractivePopGestureRecognizer_UINavigationController_viewDidLoad];
    self.transitionGestureRecognizerHelper.panGestureRecognizer.enabled = YES;
}

- (void)iuFullScreenInteractivePopGestureRecognizer_UINavigationController_setDelegate:(id<UINavigationControllerDelegate>)delegate {
    self.transitionGestureRecognizerHelper.transitioningDelegate.delegate = delegate;
}

- (_IUNavigationControllerGestureRecognizerHelper *)transitionGestureRecognizerHelper {
    _IUNavigationControllerGestureRecognizerHelper *helper = objc_getAssociatedObject(self, &TAG_TRANSITION_GESTURE_RECOGNIZER_HELPER);
    if (helper == nil) {
        helper = [[_IUNavigationControllerGestureRecognizerHelper alloc] init];
        objc_setAssociatedObject(self, &TAG_TRANSITION_GESTURE_RECOGNIZER_HELPER, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        helper.navigationController = self;
        
        self.interactivePopGestureRecognizer.enabled = NO;
        [self.view removeGestureRecognizer:self.interactivePopGestureRecognizer];
        
        [self iuFullScreenInteractivePopGestureRecognizer_UINavigationController_setDelegate:helper.transitioningDelegate];
        [self.view addGestureRecognizer:helper.panGestureRecognizer];
        [self.view addGestureRecognizer:helper.edgePanGestureRecognizer];
        [helper.panGestureRecognizer requireGestureRecognizerToFail:helper.edgePanGestureRecognizer];
    }
    return helper;
}

- (UIGestureRecognizer *)fullScreenInteractivePopGestureRecognizer {
    return self.transitionGestureRecognizerHelper.panGestureRecognizer;
}

- (UIGestureRecognizer *)edgeScreenInteractivePopGestureRecognizer {
    return self.transitionGestureRecognizerHelper.edgePanGestureRecognizer;
}

- (void)setPopDuration:(float)duration {
    self.transitionGestureRecognizerHelper.transitioningDelegate.animatorConfiguration = ^(IUTransitionAnimator *animator){
        animator.duration = duration;
    };
}

- (void)setPopType:(IUNavigationPopType)type {
    switch (type) {
        case IUNavigationPopTypeDefault:
            self.transitionGestureRecognizerHelper.transitioningDelegate.type = IUTransitionTypeDefault;
            break;
        case IUNavigationPopTypeErase:
            self.transitionGestureRecognizerHelper.transitioningDelegate.type = IUTransitionTypeErase;
            break;

        default:
            break;
    }
}

@end

@implementation _IUNavigationControllerGestureRecognizerHelper

@synthesize edgePanGestureRecognizer = _edgePanGestureRecognizer, panGestureRecognizer = _panGestureRecognizer, transitioningDelegate = _transitioningDelegate;

- (UIScreenEdgePanGestureRecognizer *)edgePanGestureRecognizer {
    if (_edgePanGestureRecognizer == nil) {
        _edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        _edgePanGestureRecognizer.edges = UIRectEdgeLeft;
        _edgePanGestureRecognizer.delegate = self;
    }
    return _edgePanGestureRecognizer;
}

- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (_panGestureRecognizer == nil) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        _panGestureRecognizer.delegate = self;
    }
    return _panGestureRecognizer;
}


- (IUTransitioningDelegate *)transitioningDelegate {
    if (_transitioningDelegate == nil) {
        _transitioningDelegate = [IUTransitioningDelegate transitioningDelegateWithType:IUTransitionTypeDefault];
        _transitioningDelegate.animatorConfiguration = ^(IUTransitionAnimator *animator){
            animator.duration = .25f;
        };
    }
    return _transitioningDelegate;
}

- (void)pan:(UIPanGestureRecognizer *)panGestureRecognizer {
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self.transitioningDelegate beginInteractiveTransition];
            [self.navigationController.topViewController popBack];
            break;
        case UIGestureRecognizerStateChanged:
            [self.transitioningDelegate.interactiveTransition updateInteractiveTransition:[panGestureRecognizer translationInView:panGestureRecognizer.view].x / self.navigationController.view.bounds.size.width];
            break;
        case UIGestureRecognizerStateEnded:
            if ([panGestureRecognizer translationInView:panGestureRecognizer.view].x > self.navigationController.view.bounds.size.width / 12.f &&
                [panGestureRecognizer velocityInView:panGestureRecognizer.view].x    > self.navigationController.view.bounds.size.width / 8.f) {
                // finish
                [self.transitioningDelegate.interactiveTransition finishInteractiveTransition];
                [self.transitioningDelegate endInteractiveTransition];
                break;
            }
            // no break here
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            // cancel
            [self.transitioningDelegate.interactiveTransition cancelInteractiveTransition];
            [self.transitioningDelegate endInteractiveTransition];
            break;
            
        default:
            break;
    }
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.transitioningDelegate.isTransitioning) return NO;
    if (gestureRecognizer == self.panGestureRecognizer) {
        CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view];
        return velocity.x > fabs(velocity.y);
    }
    return YES;
}

@end

static char TAG_VIEW_CONTROLLER_BACK_BUTTON_ITEM;
static char TAG_VIEW_CONTROLLER_BACK_BUTTON_ITEM_CREATED;

static char TAG_VIEW_CONTROLLER_DISSMISS_BUTTON_ITEM;
static char TAG_VIEW_CONTROLLER_DISSMISS_BUTTON_ITEM_CREATED;

@implementation UIViewController (IUPopBack)

+ (void)load {
    [self swizzleInstanceSelector:@selector(willMoveToParentViewController:) toSelector:@selector(iuPopBack_UIViewController_willMoveToParentViewController:)];
}

- (void)iuPopBack_UIViewController_willMoveToParentViewController:(UIViewController *)parent {
    [self iuPopBack_UIViewController_willMoveToParentViewController:parent];
    if ([parent isKindOfClass:[UINavigationController class]]) {
        
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        NSMutableArray *items = [self.navigationItem.leftBarButtonItems ?: @[] mutableCopy];
        if ([[(UINavigationController *)parent viewControllers] firstObject] != self) {
            
            if ([items containsObject:self.dismissButtonItem]) {
                [items removeObject:self.dismissButtonItem];
            }
            
            if (self.backButtonItem && ![items containsObject:self.backButtonItem]) {
                [items insertObject:self.backButtonItem atIndex:0];
            }
            
        } else {
            
            if ([items containsObject:self.backButtonItem]) {
                [items removeObject:self.backButtonItem];
            }
            
        }
        self.navigationItem.leftBarButtonItems = [items copy];
    }
}

- (void)setBackButtonItem:(UIBarButtonItem *)backButtonItem {
    objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_BACK_BUTTON_ITEM_CREATED, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIBarButtonItem *oldItem = self.backButtonItem;
    NSMutableArray *items = [self.navigationItem.leftBarButtonItems mutableCopy];
    if (oldItem && items) {
        NSUInteger index = [items indexOfObject:oldItem];
        if (index != NSNotFound) {
            [items removeObjectAtIndex:index];
        } else {
            index = 0;
        }
        
        if (backButtonItem) {
            [items insertObject:backButtonItem atIndex:index];
        }
        
        self.navigationItem.leftBarButtonItems = [items copy];
    }
    objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_BACK_BUTTON_ITEM, backButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIBarButtonItem *)backButtonItem {
    UIBarButtonItem *backButtonItem = objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_BACK_BUTTON_ITEM);
    if (backButtonItem == nil && ![objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_BACK_BUTTON_ITEM_CREATED) boolValue]) {
        objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_BACK_BUTTON_ITEM_CREATED, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        CGSize size = CGSizeMake(12, 20);
        
        UIImage *(^getArrow)(UIColor *) = ^(UIColor *color){
            CGFloat lineWidth = 1.5;
            UIGraphicsBeginImageContextWithOptions(size, NO, 3);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, size.width - lineWidth, lineWidth);
            CGContextAddLineToPoint(context, lineWidth, size.height / 2.f);
            CGContextAddLineToPoint(context, size.width - lineWidth, size.height - lineWidth);
            CGContextSetLineWidth(context, lineWidth);
            CGContextSetStrokeColorWithColor(context, color.CGColor);
            CGContextStrokePath(context);
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return image;
        };
        
        UIColor *color = self.navigationController.navigationBar.tintColor ?: [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
        backButtonItem = [[UIBarButtonItem alloc] initWithImage:getArrow(color) style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
        objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_BACK_BUTTON_ITEM, backButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return backButtonItem;
}

- (void)setDismissButtonItem:(UIBarButtonItem *)dismissButtonItem {
    objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_DISSMISS_BUTTON_ITEM_CREATED, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIBarButtonItem *oldItem = self.dismissButtonItem;
    NSMutableArray *items = [self.navigationItem.leftBarButtonItems mutableCopy];
    if (oldItem && items) {
        NSUInteger index = [items indexOfObject:oldItem];
        if (index != NSNotFound) {
            [items removeObjectAtIndex:index];
        } else {
            index = 0;
        }
        
        if (dismissButtonItem) {
            [items insertObject:dismissButtonItem atIndex:index];
        }
        
        self.navigationItem.leftBarButtonItems = [items copy];
    }
    objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_DISSMISS_BUTTON_ITEM, dismissButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIBarButtonItem *)dismissButtonItem {
    UIBarButtonItem *dismissButtonItem = objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_DISSMISS_BUTTON_ITEM);
    if (dismissButtonItem == nil && ![objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_DISSMISS_BUTTON_ITEM_CREATED) boolValue]) {
        objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_DISSMISS_BUTTON_ITEM_CREATED, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        UIColor *color = [UINavigationBar appearance].tintColor ?: [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
        CGFloat r,g,b,a;
        [color getRed:&r green:&g blue:&b alpha:&a];
        r+=1.0; g+=1.0; b+=1.0; a+=1.0;
        r/=2.0; g/=2.0; b/=2.0; a/=2.0;
        UIColor *highlightedColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:color forState:UIControlStateNormal];
        [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        dismissButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_DISSMISS_BUTTON_ITEM, dismissButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dismissButtonItem;
}

- (void)popBack {
    NSUInteger count = [self.navigationController.viewControllers count];
    if (count > 1) {
        [self.navigationController popViewControllerAnimated:([self.navigationController.viewControllers[count - 2] supportedInterfaceOrientations] & (1 << [[UIApplication sharedApplication] statusBarOrientation]))];
    }
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

@implementation UIViewController (_IUShowDismissButtonItem)

- (void)_showDismissButtonItem:(BOOL)show {
    NSMutableArray *items = [self.navigationItem.leftBarButtonItems ?: @[] mutableCopy];
    if (show) {
        if (self.dismissButtonItem && ![items containsObject:self.dismissButtonItem]) {
            [items insertObject:self.dismissButtonItem atIndex:0];
        }
    } else {
        if ([items containsObject:self.dismissButtonItem]) {
            [items removeObject:self.dismissButtonItem];
        }
    }
    self.navigationItem.leftBarButtonItems = [items copy];
}

@end
