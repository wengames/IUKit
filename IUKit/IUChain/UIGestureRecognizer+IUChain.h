//
//  UIGestureRecognizer+IUChain.h
//  IUChain
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+IUChain.h"

#define IUChainMethod_UIGestureRecognizer(returnClass) \
\
IUChainMethod_NSObject(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setDelegate)(id<UIGestureRecognizerDelegate>); \
@property (nonatomic, readonly) returnClass *(^setEnabled)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setCancelsTouchesInView)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setDelaysTouchesBegan)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setDelaysTouchesEnded)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setAllowedTouchTypes)(NSArray<NSNumber *> *); \
@property (nonatomic, readonly) returnClass *(^setAllowedPressTypes)(NSArray<NSNumber *> *); \
@property (nonatomic, readonly) returnClass *(^setRequiresExclusiveTouchType)(BOOL); \

@interface UIGestureRecognizer (IUChain)

@IUChainMethod_UIGestureRecognizer(UIGestureRecognizer)

@end
