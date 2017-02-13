//
//  UITabBarController+IUChain.h
//  IUChain
//
//  Created by admin on 2017/2/10.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+IUChain.h"

#define IUChainMethod_UITabBarController(returnClass) \
\
IUChainMethod_UIViewController(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setViewControllers)(NSArray <UIViewController *> *); \
@property (nonatomic, readonly) returnClass *(^setSelectedViewController)(UIViewController *); \
@property (nonatomic, readonly) returnClass *(^setSelectedIndex)(NSUInteger); \
@property (nonatomic, readonly) returnClass *(^setCustomizableViewControllers)(NSArray <UIViewController *> *); \
@property (nonatomic, readonly) returnClass *(^setDelegate)(id<UITabBarControllerDelegate>); \
@property (nonatomic, readonly) returnClass *(^setTabBarItem)(UITabBarItem *); \

@interface UITabBarController (IUChain)

@IUChainMethod_UITabBarController(UITabBarController)

@end
