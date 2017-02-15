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

typedef enum {
    IUNetworkingRequestMethod_GET = 0,  // GET
    IUNetworkingRequestMethod_POST,     // POST
    IUNetworkingRequestMethod_DELETE,   // DELETE
    IUNetworkingRequestMethod_PUT,      // PUT
    IUNetworkingRequestMethod_HEAD,     // HEAD
    IUNetworkingRequestMethod_FORM_DATA // form-data
} IUNetworkingRequestMethod;

typedef enum {
    IUNetworkingRequestSerializerType_URL   = 0, // application/x-www-form-urlencoded
    IUNetworkingRequestSerializerType_JSON       // application/json
} IUNetworkingRequestSerializerType;

typedef void(^IUNetworkingProgress)(NSProgress *progress);

typedef BOOL(^IUNetworkingGlobalFailure)(NSURLSessionDataTask *task, NSError *error);     // return NO to stop call failure block
typedef void(^IUNetworkingFailure)(NSURLSessionDataTask *task, NSError *error);

typedef void(^IUNetworkingCompletion)(void);

@interface IURequestConfig <T : IUBaseModel *> : NSObject

typedef BOOL(^IUNetworkingGlobalSuccess)(NSURLSessionDataTask *task, id responseObject, T responseModel);  // return NO to stop call success block
typedef void(^IUNetworkingSuccess)(NSURLSessionDataTask *task, id responseObject, T responseModel);

// enabled by IUDataFetcher
@property (nonatomic, strong) Class responseClass;
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
@property (nonatomic, strong) NSString *api;
@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSDictionary *headers; // default is @{}
@property (nonatomic, assign) IUNetworkingRequestMethod method; // default is GET
@property (nonatomic, assign) IUNetworkingRequestSerializerType serializerType; // default is application/x-www-form-urlencoded

@property (nonatomic, strong) id parameters;
@property (nonatomic, strong) NSArray <IURequestUploadFile *> *files;

@property (nonatomic, strong) IUNetworkingProgress   uploadProgress;
@property (nonatomic, strong) IUNetworkingProgress   downloadProgress;

@property (nonatomic, strong) IUNetworkingGlobalSuccess globalSuccess; // call before success
@property (nonatomic, strong) IUNetworkingGlobalFailure globalFailure; // call before failure

@property (nonatomic, strong) IUNetworkingSuccess    success;
@property (nonatomic, strong) IUNetworkingFailure    failure;
@property (nonatomic, strong) IUNetworkingCompletion completion;

+ (instancetype)globalConfig; // shared instance
+ (instancetype)config;       // config setup with global config as default

- (void)setMethodPostURL;  // method POST and type URL
- (void)setMethodPostJSON; // method POST and type JSON

- (NSString *)methodString;
- (NSString *)absoluteUrl;

@end
