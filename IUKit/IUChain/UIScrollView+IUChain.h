//
//  UIScrollView+IUChain.h
//  IUChain
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+IUChain.h"

#define IUChainMethod_UIScrollView(returnClass) \
\
IUChainMethod_UIView(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setContentOffset)(CGPoint); \
@property (nonatomic, readonly) returnClass *(^setContentSize)(CGSize); \
@property (nonatomic, readonly) returnClass *(^setContentInset)(UIEdgeInsets); \
@property (nonatomic, readonly) returnClass *(^setDirectionalLockEnabled)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setBounces)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setAlwaysBounceVertical)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setAlwaysBounceHorizontal)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setPagingEnabled)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setScrollEnabled)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setShowsHorizontalScrollIndicator)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setShowsVerticalScrollIndicator)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setIndicatorStyle)(UIScrollViewIndicatorStyle); \
@property (nonatomic, readonly) returnClass *(^setDecelerationRate)(CGFloat); \
@property (nonatomic, readonly) returnClass *(^setDelaysContentTouches)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setCanCancelContentTouches)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setMinimumZoomScale)(CGFloat); \
@property (nonatomic, readonly) returnClass *(^setMaximumZoomScale)(CGFloat); \
@property (nonatomic, readonly) returnClass *(^setZoomScale)(CGFloat); \
@property (nonatomic, readonly) returnClass *(^setBouncesZoom)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setScrollsToTop)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setKeyboardDismissMode)(UIScrollViewKeyboardDismissMode); \
@property (nonatomic, readonly) returnClass *(^setRefreshControl)(UIRefreshControl *); \

#define IUChainMethod_UIScrollViewDelegate(returnClass) \
property (nonatomic, readonly) returnClass *(^setDelegate)(id<UIScrollViewDelegate>); \

@interface UIScrollView (IUChain)

@IUChainMethod_UIScrollView(UIScrollView)
@IUChainMethod_UIScrollViewDelegate(UIScrollView) // conflict with subclasses

@end
