//
//  UIControl+IUChain.h
//  IUChain
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+IUChain.h"

#define IUChainMethod_UIControl(returnClass) \
\
IUChainMethod_UIView(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setEnabled)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setSelected)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setHighlighted)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setContentVerticalAlignment)(UIControlContentVerticalAlignment); \
@property (nonatomic, readonly) returnClass *(^setContentHorizontalAlignment)(UIControlContentHorizontalAlignment); \

@interface UIControl (IUChain)

@IUChainMethod_UIControl(UIControl)

@end
