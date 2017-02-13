//
//  UIView+IUChain.h
//  IUChain
//
//  Created by admin on 2017/1/19.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIResponder+IUChain.h"

#define IUChainMethod_UIView(returnClass) \
\
IUChainMethod_UIResponder(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setUserInteractionEnabled)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setTag)(NSInteger); \
@property (nonatomic, readonly) returnClass *(^setSemanticContentAttribute)(UISemanticContentAttribute); \
\
@property (nonatomic, readonly) returnClass *(^setFrame)(CGRect); \
@property (nonatomic, readonly) returnClass *(^setBounds)(CGRect); \
@property (nonatomic, readonly) returnClass *(^setCenter)(CGPoint); \
@property (nonatomic, readonly) returnClass *(^setTransform)(CGAffineTransform); \
@property (nonatomic, readonly) returnClass *(^setContentScaleFactor)(CGFloat); \
\
@property (nonatomic, readonly) returnClass *(^setMultipleTouchEnabled)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setExclusiveTouch)(BOOL); \
\
@property (nonatomic, readonly) returnClass *(^setAutoresizesSubviews)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setAutoresizingMask)(UIViewAutoresizing); \
\
@property (nonatomic, readonly) returnClass *(^setLayoutMargins)(UIEdgeInsets); \
@property (nonatomic, readonly) returnClass *(^setPreservesSuperviewLayoutMargins)(BOOL); \
\
@property (nonatomic, readonly) returnClass *(^setClipsToBounds)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setBackgroundColor)(UIColor *); \
@property (nonatomic, readonly) returnClass *(^setAlpha)(UIColor *); \
@property (nonatomic, readonly) returnClass *(^setOpaque)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setClearsContextBeforeDrawing)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setHidden)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setContentMode)(UIViewContentMode); \
@property (nonatomic, readonly) returnClass *(^setContentStretch)(CGRect); \
@property (nonatomic, readonly) returnClass *(^setMaskView)(UIView *); \
@property (nonatomic, readonly) returnClass *(^setTintColor)(UIColor *); \
@property (nonatomic, readonly) returnClass *(^setTintAdjustmentMode)(UIViewTintAdjustmentMode); \
\
@property (nonatomic, readonly) returnClass *(^setGestureRecognizers)(NSArray<__kindof UIGestureRecognizer *> *); \
\
@property (nonatomic, readonly) returnClass *(^setMotionEffects)(NSArray<__kindof UIMotionEffect *> *); \
\
@property (nonatomic, readonly) returnClass *(^setTranslatesAutoresizingMaskIntoConstraints)(BOOL); \
\
@property (nonatomic, readonly) returnClass *(^intoView)(UIView *); \

@interface UIView (IUChain)

@IUChainMethod_UIView(UIView)

@end
