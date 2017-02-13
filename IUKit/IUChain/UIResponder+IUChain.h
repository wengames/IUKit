//
//  UIResponder+IUChain.h
//  IUChain
//
//  Created by admin on 2017/2/10.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+IUChain.h"

#define IUChainMethod_UIResponder(returnClass) \
\
IUChainMethod_NSObject(returnClass) \

@interface UIResponder (IUChain)

@IUChainMethod_UIResponder(UIResponder)

@end
