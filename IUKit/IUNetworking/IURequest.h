//
//  IURequest.h
//  IUKitDemo
//
//  Created by admin on 2017/2/14.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IURequestConfig.h"
#import "IURequestResult.h"

typedef void(^IUNetworkingConfiguration)(IURequestConfig *config);

@interface IURequest : NSObject

@property (nonatomic, strong, readonly) IURequestConfig *config;
@property (nonatomic, strong, readonly) IURequestResult *result;

/**
 *  start request, and cancel task before
 */
- (void)start;

/**
 *  cancel request
 */
- (void)cancel;

/**
 *  Generate request and start
 *
 *  @param configuration    请求配置
 */
+ (instancetype)request:(IUNetworkingConfiguration)configuration;

#pragma mark Fast Api
/**
 *  Start request with method GET
 *
 *  @param api          接口地址
 *  @param success      接口成功的回调
 */
+ (instancetype)get:(NSString *)api success:(IUNetworkingSuccess)success;

/**
 *  Start request with method POST
 *
 *  @param api          接口地址
 *  @param parameters   接口传参
 *  @param success      接口成功的回调
 */
+ (instancetype)post:(NSString *)api parameters:(id)parameters success:(IUNetworkingSuccess)success;

/**
 *  Start Upload files
 *
 *  @param api          接口地址
 *  @param parameters   接口传参
 *  @param files        文件传参
 *  @param success      接口成功的回调
 */
+ (instancetype)upload:(NSString *)api parameters:(id)parameters files:(NSArray <IURequestUploadFile *> *)files success:(IUNetworkingSuccess)success;
+ (instancetype)upload:(NSString *)api files:(NSArray <IURequestUploadFile *> *)files success:(IUNetworkingSuccess)success;

@end
