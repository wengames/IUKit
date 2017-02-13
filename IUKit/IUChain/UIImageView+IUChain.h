//
//  UIImageView+IUChain.h
//  IUChain
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+IUChain.h"

#define IUChainMethod_UIImageView(returnClass) \
\
IUChainMethod_UIView(returnClass) \
\
@property (nonatomic,readonly) returnClass *(^setImage)(UIImage *); \
@property (nonatomic,readonly) returnClass *(^setHighlightedImage)(UIImage *); \
@property (nonatomic,readonly) returnClass *(^setHighlighted)(BOOL); \
@property (nonatomic,readonly) returnClass *(^setAnimationImages)(NSArray<UIImage *> *); \
@property (nonatomic,readonly) returnClass *(^setHighlightedAnimationImages)(NSArray<UIImage *> *); \
@property (nonatomic,readonly) returnClass *(^setAnimationDuration)(NSTimeInterval); \
@property (nonatomic,readonly) returnClass *(^setAnimationRepeatCount)(NSInteger); \
@property (nonatomic,readonly) returnClass *(^setAdjustsImageWhenAncestorFocused)(BOOL); \
@property (nonatomic,readonly) returnClass *(^setFocusedFrameGuide)(UILayoutGuide *); \

@interface UIImageView (IUChain)

@IUChainMethod_UIImageView(UIImageView)

@end
