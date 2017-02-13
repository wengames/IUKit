//
//  UISlider+IUChain.h
//  IUChain
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIControl+IUChain.h"

#define IUChainMethod_UISlider(returnClass) \
\
IUChainMethod_UIControl(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setValue)(float); \
@property (nonatomic, readonly) returnClass *(^setMinimumValue)(float); \
@property (nonatomic, readonly) returnClass *(^setMaximumValue)(float); \
@property (nonatomic, readonly) returnClass *(^setMinimumValueImage)(UIImage *); \
@property (nonatomic, readonly) returnClass *(^setMaximumValueImage)(UIImage *); \
@property (nonatomic, readonly) returnClass *(^setContinuous)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setMinimumTrackTintColor)(UIColor *); \
@property (nonatomic, readonly) returnClass *(^setMaximumTrackTintColor)(UIColor *); \
@property (nonatomic, readonly) returnClass *(^setThumbTintColor)(UIColor *); \

@interface UISlider (IUChain)

@IUChainMethod_UISlider(UISlider)

@end
