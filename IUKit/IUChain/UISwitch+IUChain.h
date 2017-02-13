//
//  UISwitch+IUChain.h
//  IUChain
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIControl+IUChain.h"

#define IUChainMethod_UISwitch(returnClass) \
\
IUChainMethod_UIControl(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setOnTintColor)(UIColor *); \
@property (nonatomic, readonly) returnClass *(^setThumbTintColor)(UIColor *); \
@property (nonatomic, readonly) returnClass *(^setOnImage)(UIImage *); \
@property (nonatomic, readonly) returnClass *(^setOffImage)(UIImage *); \
@property (nonatomic, readonly) returnClass *(^setOn)(BOOL); \

@interface UISwitch (IUChain)

@IUChainMethod_UISwitch(UISwitch)

@end
