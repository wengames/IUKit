//
//  IURequestResult.m
//  IUKitDemo
//
//  Created by admin on 2017/2/16.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IURequestResult.h"
#import "AFNetworkReachabilityManager.h"
#import "MJExtension.h"

@implementation IURequestResult

+ (instancetype)resultWithConfig:(IURequestConfig *)config task:(NSURLSessionDataTask *)task responseObject:(id)responseObject error:(NSError *)error {
    IURequestResult *result = [[self alloc] init];
    result.config = config;
    result.task = task;
    result.responseObject = responseObject;
    result.error = error;
    
    if (config.fakeRequest) [result makeFake];
    else                    [result generateModel];
    return result;
}

- (void)makeFake {
    if ([self.config.responseClass respondsToSelector:@selector(randomData)]) {
        self.model = [self.config.responseClass randomData];
    }
    self.responseObject = [self.model mj_keyValues];
}

- (void)generateModel {
    if (self.config.responseClass) {
        self.model = [self.config.responseClass mj_objectWithKeyValues:self.responseObject];
    }
}

- (NSInteger)httpStatusCode {
    if ([self.task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        return [(NSHTTPURLResponse *)self.task.response statusCode];
    }
    return 200;
}

- (NSDictionary *)responseHeaders {
    if ([self.task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        return [(NSHTTPURLResponse *)self.task.response allHeaderFields];
    }
    return nil;
}

- (IURequestResultType)type {
    if (self.responseObject || self.config.fakeRequest) {
        return IURequestResultTypeRequestSuccess;
    } else if (self.task.state == NSURLSessionTaskStateCanceling) {
        return IURequestResultTypeNetworkCancelled;
    } else if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable) {
        return IURequestResultTypeNetworkNotReachable;
    } else {
        return IURequestResultTypeRequestFailureWithError;
    }
}

@end
