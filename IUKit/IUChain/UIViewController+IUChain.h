//
//  UIViewController+IUChain.h
//  IUChain
//
//  Created by admin on 2017/2/10.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIResponder+IUChain.h"

#define IUChainMethod_UIViewController(returnClass) \
\
IUChainMethod_UIResponder(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setTitle)(NSString *); \
\
@property (nonatomic, readonly) returnClass *(^setDefinesPresentationContext)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setProvidesPresentationContextTransitionStyle)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setRestoresFocusAfterTransition)(BOOL); \
\
@property (nonatomic, readonly) returnClass *(^setModalTransitionStyle)(UIModalTransitionStyle); \
@property (nonatomic, readonly) returnClass *(^setModalPresentationStyle)(UIModalPresentationStyle); \
@property (nonatomic, readonly) returnClass *(^setModalPresentationCapturesStatusBarAppearance)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setDisablesAutomaticKeyboardDismissal)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setEdgesForExtendedLayout)(UIRectEdge); \
@property (nonatomic, readonly) returnClass *(^setExtendedLayoutIncludesOpaqueBars)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setAutomaticallyAdjustsScrollViewInsets)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setPreferredContentSize)(CGSize); \
\
@property (nonatomic, readonly) returnClass *(^setEditing)(BOOL); \
\
@property (nonatomic, readonly) returnClass *(^setTransitioningDelegate)(id<UIViewControllerTransitioningDelegate>); \
\
@property (nonatomic, readonly) returnClass *(^setNavigationItem)(UINavigationItem *); \
@property (nonatomic, readonly) returnClass *(^setHidesBottomBarWhenPushed)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setToolbarItems)(BOOL); \

@interface UIViewController (IUChain)

@IUChainMethod_UIViewController(UIViewController)

@end
