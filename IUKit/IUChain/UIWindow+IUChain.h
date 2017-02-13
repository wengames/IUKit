//
//  UIWindow+IUChain.h
//  IUChain
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+IUChain.h"

#define IUChainMethod_UIWindow(returnClass) \
\
IUChainMethod_UIView(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setScreen)(UIScreen *); \
@property (nonatomic, readonly) returnClass *(^setWindowLevel)(UIWindowLevel); \
@property (nonatomic, readonly) returnClass *(^setRootViewController)(UIViewController *); \

@interface UIWindow (IUChain)

@IUChainMethod_UIWindow(UIWindow)

@end
