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

@synthesize responseObject = _responseObject, model = _model;;

+ (instancetype)resultWithConfig:(IURequestConfig *)config task:(NSURLSessionDataTask *)task responseObject:(id)responseObject error:(NSError *)error {
    IURequestResult *result = [[self alloc] init];
    result->_config = config;
    result->_task = task;
    result->_responseObject = responseObject;
    result->_error = error;
    
    [result analysis];
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
            _model = [self.config.modelClass mj_objectWithKeyValues:self.responseObject];
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

@end
