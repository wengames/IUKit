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

@property (nonatomic, strong) IURequestConfig *config;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) id responseObject;
@property (nonatomic, strong) id error;

@property (nonatomic, readonly) NSInteger     httpStatusCode;
@property (nonatomic, readonly) NSDictionary *responseHeaders;
@property (nonatomic, readonly) IURequestResultType type;
@property (nonatomic, strong) id model;

+ (instancetype)resultWithConfig:(IURequestConfig *)config task:(NSURLSessionDataTask *)task responseObject:(id)responseObject error:(NSError *)error;

/**
 *  Override point for category
 *  When config.fakeRequest is YES,
 *  the method will be called for making fake model and responseObject
 */
- (void)makeFake;

/**
 *  Override point for category
 *  When config.fakeRequest is NO,
 *  the method will be called for making fake model from responseObject
 */
- (void)generateModel;

@end
