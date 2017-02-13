//
//  UIPageControl+IUChain.h
//  IUChain
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIControl+IUChain.h"

#define IUChainMethod_UIPageControl(returnClass) \
\
IUChainMethod_UIControl(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setNumberOfPages)(NSInteger); \
@property (nonatomic, readonly) returnClass *(^setCurrentPage)(NSInteger); \
@property (nonatomic, readonly) returnClass *(^setHidesForSinglePage)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setDefersCurrentPageDisplay)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setPageIndicatorTintColor)(UIColor *); \
@property (nonatomic, readonly) returnClass *(^setCurrentPageIndicatorTintColor)(UIColor *); \

@interface UIPageControl (IUChain)

@IUChainMethod_UIPageControl(UIPageControl)

@end
