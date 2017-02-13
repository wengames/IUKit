//
//  NSObject+IUMethodSwizzling.h
//  IUKitDemo
//
//  Created by admin on 2017/2/13.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (IUMethodSwizzling)

+ (void)swizzleInstanceSelector:(SEL)fromSelector toSelector:(SEL)toSelector;
+ (void)swizzleClassSelector:(SEL)fromSelector toSelector:(SEL)toSelector;

@end
