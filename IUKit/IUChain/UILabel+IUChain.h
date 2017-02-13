//
//  UILabel+IUChain.h
//  IUChain
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+IUChain.h"

#define IUChainMethod_UILabel(returnClass) \
\
IUChainMethod_UIView(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setText)(NSString *); \
@property (nonatomic, readonly) returnClass *(^setFont)(UIFont *); \
@property (nonatomic, readonly) returnClass *(^setTextColor)(UIColor *); \
@property (nonatomic, readonly) returnClass *(^setShadowColor)(UIColor *); \
@property (nonatomic, readonly) returnClass *(^setShadowOffset)(CGSize); \
@property (nonatomic, readonly) returnClass *(^setTextAlignment)(NSTextAlignment); \
@property (nonatomic, readonly) returnClass *(^setLineBreakMode)(NSLineBreakMode); \
@property (nonatomic, readonly) returnClass *(^setAttributedText)(NSAttributedString *); \
@property (nonatomic, readonly) returnClass *(^setHighlightedTextColor)(UIColor *); \
@property (nonatomic, readonly) returnClass *(^setHighlighted)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setEnabled)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setNumberOfLines)(NSInteger); \
@property (nonatomic, readonly) returnClass *(^setAdjustsFontSizeToFitWidth)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setBaselineAdjustment)(UIBaselineAdjustment); \
@property (nonatomic, readonly) returnClass *(^setMinimumScaleFactor)(CGFloat); \
@property (nonatomic, readonly) returnClass *(^setAllowsDefaultTighteningForTruncation)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setPreferredMaxLayoutWidth)(CGFloat); \
@property (nonatomic, readonly) returnClass *(^setAdjustsFontForContentSizeCategory)(BOOL); \

@interface UILabel (IUChain)

@IUChainMethod_UILabel(UILabel)

@end
