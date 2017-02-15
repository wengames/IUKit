//
//  IURequestorRegistrar.m
//  IUKitDemo
//
//  Created by admin on 2017/2/14.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IURequestorRegistrar.h"

@implementation IURequestorRegistrar

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static IURequestorRegistrar *__registrar = nil;
    dispatch_once(&onceToken, ^{
        __registrar = [[self alloc] init];
    });
    return __registrar;
}

- (void)setRequestor:(id<IUNetworkingRequestDelegate>)requestor {
    __weak typeof(requestor) weakRequestor = requestor;
    self.requestors = @[^{
        return weakRequestor;
    }];
}

- (void)addRequestor:(id<IUNetworkingRequestDelegate>)requestor {
    __weak typeof(requestor) weakRequestor = requestor;
    self.requestors = [self.requestors ?: @[] arrayByAddingObject:^{
        return weakRequestor;
    }];
}

- (void)removeRequestor:(id<IUNetworkingRequestDelegate>)requestor {
    NSMutableArray *requestors = [@[] mutableCopy];
    for (IUNetworkWeakRequestor requestorBlock in self.requestors) {
        id weakRequestor = requestorBlock();
        if (weakRequestor && weakRequestor != requestor) {
            [requestors addObject:requestorBlock];
        }
    }
    if ([requestors count] < [self.requestors count]) {
        self.requestors = [requestors copy];
    }
}

- (void)clear {
    self.requestors = nil;
}

@end

@implementation NSObject (IUBecomeRequestor)

- (void)setRequestor {
    [[IURequestorRegistrar sharedInstance] setRequestor:self];
}

- (void)addRequestor {
    [[IURequestorRegistrar sharedInstance] addRequestor:self];
}

- (void)removeRequestor {
    [[IURequestorRegistrar sharedInstance] removeRequestor:self];
}

- (void)clearRequestor {
    [[IURequestorRegistrar sharedInstance] clear];
}

@end
