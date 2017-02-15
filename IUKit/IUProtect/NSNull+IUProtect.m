//
//  NSNull+IUProtect.m
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "NSNull+IUProtect.h"

@implementation NSNull (IUProtect)

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self respondsToSelector:aSelector]) {
        return self;
    } else if ([NSString instancesRespondToSelector:aSelector]) {
        return @"";
    } else if ([NSNumber instancesRespondToSelector:aSelector]) {
        return @0;
    } else if ([NSArray instancesRespondToSelector:aSelector]) {
        return @[];
    } else if ([NSDictionary instancesRespondToSelector:aSelector]) {
        return @{};
    }
    return nil;
}

@end
