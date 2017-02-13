//
//  UINavigationController+IUChain.h
//  IUChain
//
//  Created by admin on 2017/2/10.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+IUChain.h"

#define IUChainMethod_UINavigationController(returnClass) \
\
IUChainMethod_UIViewController(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setViewControllers)(NSArray <UIViewController *> *); \
@property (nonatomic, readonly) returnClass *(^setNavigationBarHidden)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setToolbarHidden)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setDelegate)(id<UINavigationControllerDelegate>); \
@property (nonatomic, readonly) returnClass *(^setHidesBarsOnSwipe)(BOOL); \

@interface UINavigationController (IUChain)

@IUChainMethod_UINavigationController(UINavigationController)

@end
