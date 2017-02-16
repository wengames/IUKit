//
//  IURequestConfig.h
//  IUKitDemo
//
//  Created by admin on 2017/2/14.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IURequestUploadFile.h"
#import "IUBaseModel.h"

@class IURequestResult;

typedef enum {
    IUNetworkingRequestSerializerType_URL   = 0, // application/x-www-form-urlencoded
    IUNetworkingRequestSerializerType_JSON  = 1  // application/json
} IUNetworkingRequestSerializerType;

typedef enum {
    IUNetworkingRequestMethodName_GET       = 0, // GET
    IUNetworkingRequestMethodName_POST      = 1, // POST
    IUNetworkingRequestMethodName_DELETE    = 2, // DELETE
    IUNetworkingRequestMethodName_PUT       = 3, // PUT
    IUNetworkingRequestMethodName_HEAD      = 4, // HEAD
    IUNetworkingRequestMethodName_FORM_DATA = 5  // form-data
} IUNetworkingRequestMethodName;

typedef enum {
    /* normal */
    IUNetworkingRequestMethod_GET           = IUNetworkingRequestMethodName_GET     << 2 | IUNetworkingRequestSerializerType_URL,
    IUNetworkingRequestMethod_POST          = IUNetworkingRequestMethodName_POST    << 2 | IUNetworkingRequestSerializerType_JSON,
    IUNetworkingRequestMethod_DELETE        = IUNetworkingRequestMethodName_DELETE  << 2 | IUNetworkingRequestSerializerType_JSON,
    IUNetworkingRequestMethod_PUT           = IUNetworkingRequestMethodName_PUT     << 2 | IUNetworkingRequestSerializerType_JSON,
    IUNetworkingRequestMethod_HEAD          = IUNetworkingRequestMethodName_HEAD    << 2 | IUNetworkingRequestSerializerType_JSON,
    
    /* form-data */
    IUNetworkingRequestMethod_FORM_DATA     = IUNetworkingRequestMethodName_FORM_DATA << 2 | IUNetworkingRequestSerializerType_JSON,
    
    /* other */
    IUNetworkingRequestMethod_POST_URL      = IUNetworkingRequestMethodName_POST    << 2 | IUNetworkingRequestSerializerType_URL,
    IUNetworkingRequestMethod_DELETE_URL    = IUNetworkingRequestMethodName_DELETE  << 2 | IUNetworkingRequestSerializerType_URL,
    IUNetworkingRequestMethod_PUT_URL       = IUNetworkingRequestMethodName_PUT     << 2 | IUNetworkingRequestSerializerType_URL,
    IUNetworkingRequestMethod_HEAD_URL      = IUNetworkingRequestMethodName_HEAD    << 2 | IUNetworkingRequestSerializerType_URL,
} IUNetworkingRequestMethod;

typedef void(^IUNetworkingProgress)(NSProgress *progress);

typedef BOOL(^IUNetworkingGlobalSuccess)(__kindof IURequestResult *result);  // return NO to stop call success block
typedef BOOL(^IUNetworkingGlobalFailure)(__kindof IURequestResult *result);     // return NO to stop call failure block

typedef void(^IUNetworkingSuccess)(__kindof IURequestResult *result);
typedef void(^IUNetworkingFailure)(__kindof IURequestResult *result);
typedef void(^IUNetworkingCompletion)(void);

@interface IURequestConfig : NSObject

// subclass of IURequestResult
// default is IURequestResult
@property (nonatomic, strong) Class resultClass;

// model class used by result to make dto
@property (nonatomic, strong) Class modelClass;

// fake request by return random data after delay
@property (nonatomic, assign) BOOL  fakeRequest;       // default is NO
@property (nonatomic, assign) float fakeRequestDelay;  // time in seconds, default is 1

// debug
@property (nonatomic, assign) BOOL  enableRequestLog;  // default is NO

// timeout second
@property (nonatomic, assign) NSTimeInterval timeoutInterval; // time in seconds, default is 30

// security policy
@property (nonatomic, strong) NSSet *certificates;
@property (nonatomic, assign) BOOL  allowInvalidCertificates; // defaults is NO
@property (nonatomic, assign) BOOL  validatesDomainName;      // defaults is YES

// request with root + api, if url is nil, or use url
@property (nonatomic, strong) NSString *root;
@property (nonatomic, strong) NSString *api; // enable to set like ":id" to get "id" in parameters
@property (nonatomic, strong) NSString *url; // enable to set like ":id" to get "id" in parameters

@property (nonatomic, strong) NSDictionary *headers; // default is @{}
@property (nonatomic, assign) IUNetworkingRequestMethod method; // default is GET

@property (nonatomic, strong) id parameters;
@property (nonatomic, strong) NSArray <IURequestUploadFile *> *files;

@property (nonatomic, strong) IUNetworkingProgress uploadProgress;
@property (nonatomic, strong) IUNetworkingProgress downloadProgress;

@property (nonatomic, strong) IUNetworkingGlobalSuccess globalSuccess; // call before success
@property (nonatomic, strong) IUNetworkingGlobalFailure globalFailure; // call before failure

- (void)setGlobalSuccess:(IUNetworkingGlobalSuccess)globalSuccess;
- (void)setGlobalFailure:(IUNetworkingGlobalFailure)globalFailure;

@property (nonatomic, strong) IUNetworkingSuccess    success;
@property (nonatomic, strong) IUNetworkingFailure    failure;
@property (nonatomic, strong) IUNetworkingCompletion completion;

- (void)setSuccess:(IUNetworkingSuccess)success;
- (void)setFailure:(IUNetworkingFailure)failure;
- (void)setCompletion:(IUNetworkingCompletion)completion;

+ (instancetype)globalConfig; // shared instance, setup global config
+ (instancetype)config;       // setup with global config as default

@property (nonatomic, readonly) IUNetworkingRequestMethodName     methodName;     // convert from method
@property (nonatomic, readonly) IUNetworkingRequestSerializerType serializerType; // convert from method

- (NSString *)methodNameString;
- (NSString *)absoluteUrl;

- (instancetype)deepCopy;

@end
