//
//  UIButton+IUChain.h
//  IUChain
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIControl+IUChain.h"

#define IUChainMethod_UIButton(returnClass) \
\
IUChainMethod_UIControl(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setTitleEdgeInsets)(UIEdgeInsets); \
@property (nonatomic, readonly) returnClass *(^setImageEdgeInsets)(UIEdgeInsets); \
@property (nonatomic, readonly) returnClass *(^setContentEdgeInsets)(UIEdgeInsets); \
@property (nonatomic, readonly) returnClass *(^setReversesTitleShadowWhenHighlighted)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setAdjustsImageWhenHighlighted)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setAdjustsImageWhenDisabled)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setShowsTouchWhenHighlighted)(BOOL); \

@interface UIButton (IUChain)

@IUChainMethod_UIButton(UIButton)

@end
