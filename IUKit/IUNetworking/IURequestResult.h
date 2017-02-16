//
//  IURequestResult.h
//  IUKitDemo
//
//  Created by admin on 2017/2/16.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IURequestConfig.h"

@class IURequest;

typedef enum {
    IURequestResultTypeRequestSuccess = 0,
    IURequestResultTypeNetworkCancelled,
    IURequestResultTypeNetworkNotReachable,
    IURequestResultTypeRequestFailureWithError
} IURequestResultType;

@interface IURequestResult : NSObject
{
    @protected IURequestConfig *_config;
    @protected NSURLSessionDataTask *_task;
    @protected NSError *_error;
    
    @protected id _responseObject;
    @protected id _model;
}

@property (nonatomic, strong, readonly) IURequestConfig *config;
@property (nonatomic, strong, readonly) NSURLSessionDataTask *task;
@property (nonatomic, strong, readonly) NSError *error;

@property (nonatomic, strong, readonly) id responseObject;
@property (nonatomic, strong, readonly) id model;

@property (nonatomic, strong, readonly) NSDictionary *responseHeaders;
@property (nonatomic, readonly) NSInteger httpStatusCode;
@property (nonatomic, readonly) IURequestResultType type;

@property (nonatomic, readonly, weak) IURequest *request;

+ (instancetype)resultWithConfig:(IURequestConfig *)config task:(NSURLSessionDataTask *)task responseObject:(id)responseObject error:(NSError *)error request:(IURequest *__weak)request;

- (void)fakeDataTypeWrong;

@end
