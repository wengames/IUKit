//
//  NSObject+IUChain.h
//  IUKitDemo
//
//  Created by admin on 2017/2/13.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IUChainMethod_NSObject(returnClass) \
property (nonatomic, readonly) returnClass *(^assign)(__strong id *); \
- (returnClass *)configure:(void(^)(returnClass *x))configure; \

// dynamic implement chain method
@interface NSObject (IUChain)

@IUChainMethod_NSObject(NSObject)

@end
