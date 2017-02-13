//
//  UISegmentedControl+IUChain.h
//  IUChain
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIControl+IUChain.h"

#define IUChainMethod_UISegmentedControl(returnClass) \
\
IUChainMethod_UIControl(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setMomentary)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setApportionsSegmentWidthsByContent)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setSelectedSegmentIndex)(NSInteger); \

@interface UISegmentedControl (IUChain)

@IUChainMethod_UISegmentedControl(UISegmentedControl)

@end
