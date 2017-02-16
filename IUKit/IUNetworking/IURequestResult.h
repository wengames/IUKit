//
//  IURequestResult.h
//  IUKitDemo
//
//  Created by admin on 2017/2/16.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IURequestConfig.h"

typedef enum {
    IURequestResultTypeRequestSuccess = 0,
    IURequestResultTypeNetworkCancelled,
    IURequestResultTypeNetworkNotReachable,
    IURequestResultTypeRequestFailureWithError
} IURequestResultType;

@interface IURequestResult : NSObject

@property (nonatomic, strong, readonly) IURequestConfig *config;
@property (nonatomic, strong, readonly) NSURLSessionDataTask *task;
@property (nonatomic, strong, readonly) NSError *error;

@property (nonatomic, strong, readonly) id responseObject;
@property (nonatomic, strong, readonly) id model;

@property (nonatomic, strong, readonly) NSDictionary *responseHeaders;
@property (nonatomic, readonly) NSInteger httpStatusCode;
@property (nonatomic, readonly) IURequestResultType type;

+ (instancetype)resultWithConfig:(IURequestConfig *)config task:(NSURLSessionDataTask *)task responseObject:(id)responseObject error:(NSError *)error;

@end
