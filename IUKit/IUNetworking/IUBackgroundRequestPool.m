//
//  IUBackgroundRequestPool.m
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUBackgroundRequestPool.h"

@implementation IUBackgroundRequestPool

@synthesize requests = _requests;

- (NSMutableArray *)requests {
    if (_requests == nil) {
        _requests = [@[] mutableCopy];
    }
    return _requests;
}

+ (instancetype)pool {
    static dispatch_once_t onceToken;
    static IUBackgroundRequestPool *__pool = nil;
    dispatch_once(&onceToken, ^{
        __pool = [[self alloc] init];
    });
    return __pool;
}

@end
