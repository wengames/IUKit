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

+ (instancetype)resultWithConfig:(IURequestConfig *)config task:(NSURLSessionDataTask *)task responseObject:(id)responseObject error:(NSError *)error request:(IURequest *__weak)request {
    IURequestResult *result = [[self alloc] init];
    result->_config = config;
    result->_task = task;
    result->_responseObject = responseObject;
    result->_error = error;
    result->_request = request;
    return result;
}

- (id)responseObject {
    if (_responseObject == nil && self.config.fakeRequest && self.config.modelClass) {
        _responseObject = [self.model mj_keyValues];
    }
    return _responseObject;
}

- (id)model {
    if (_model == nil && self.config.modelClass) {
        if (self.config.fakeRequest) {
            if ([self.config.modelClass respondsToSelector:@selector(randomData)]) {
                _model = [self.config.modelClass randomData];
            }
        } else if (_responseObject) {
            if ([_responseObject isKindOfClass:[NSArray class]]) {
                _model = [self.config.modelClass mj_objectWithKeyValues:self.responseObject];
            } else {
                _model = [self.config.modelClass mj_objectWithKeyValues:self.responseObject];
            }
        }
    }
    return _model;
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

- (void)fakeDataTypeWrong {
    _responseObject = nil;
    _model = @[
               [self.config.modelClass randomData],
               [self.config.modelClass randomData],
               [self.config.modelClass randomData],
               [self.config.modelClass randomData],
               [self.config.modelClass randomData],
               [self.config.modelClass randomData],
               [self.config.modelClass randomData],
               [self.config.modelClass randomData],
               [self.config.modelClass randomData],
               [self.config.modelClass randomData]
               ];
}

@end
