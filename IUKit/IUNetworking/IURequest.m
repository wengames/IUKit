//
//  IURequest.m
//  IUKitDemo
//
//  Created by admin on 2017/2/14.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IURequest.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "IURequestorRegistrar.h"
#import "IUBackgroundRequestPool.h"

@interface NSObject (IUNetworkRequestingCount)

@property (nonatomic, assign) NSInteger requestingCount;

@end

@interface IURequest ()

@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSArray <IUNetworkWeakRequestor> *requestors;
@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;

@end

@implementation IURequest

- (void)setTask:(NSURLSessionDataTask *)task {
    if (_task) [_task cancel];
    _task = task;
}

- (void)cancel {
    [self.task cancel];
}

- (void)dealloc {
    [self cancel];
}

- (instancetype)init {
    if (self = [super init]) {
        self->_config = [self.class defaultRequestConfig];
    }
    return self;
}

- (id)convertModelFromData:(id)data {
    return [self.config.responseClass mj_objectWithKeyValues:data];
}

- (id)convertDataFromModel:(id)model {
    return [model mj_keyValues];
}

- (AFNetworkReachabilityManager *)reachabilityManager {
    if (_reachabilityManager == nil) {
        _reachabilityManager = [AFNetworkReachabilityManager manager];
    }
    return _reachabilityManager;
}

+ (IURequestConfig *)defaultRequestConfig {
    return [IURequestConfig config];
}

+ (instancetype)generateRequest:(IUNetworkingConfiguration)configuration {
    IURequest *request = [[IURequest alloc] init];
    configuration(request.config);
    if (request.config.method == IUNetworkingRequestMethod_GET) request.config.serializerType = IUNetworkingRequestSerializerType_URL;
    return request;
}

+ (instancetype)request:(IUNetworkingConfiguration)configuration {
    IURequest *request = [self generateRequest:configuration];
    [request start];
    return request;
}

// fast api
+ (instancetype)post_url:(NSString *)api parameters:(id)parameters success:(IUNetworkingSuccess)success {
    return [self request:^(IURequestConfig *config) {
        config.api = api;
        [config setMethodPostURL];
        config.parameters = parameters;
        config.success = success;
    }];
}

+ (instancetype)post_json:(NSString *)api parameters:(id)parameters success:(IUNetworkingSuccess)success {
    return [self request:^(IURequestConfig *config) {
        config.api = api;
        [config setMethodPostJSON];
        config.parameters = parameters;
        config.success = success;
    }];
}

+ (instancetype)get:(NSString *)api success:(IUNetworkingSuccess)success {
    return [self request:^(IURequestConfig *config) {
        config.api = api;
        config.method = IUNetworkingRequestMethod_GET;
        config.success = success;
    }];
}

+ (instancetype)upload:(NSString *)api parameters:(id)parameters files:(NSArray <IURequestUploadFile *> *)files success:(IUNetworkingSuccess)success {
    return [self request:^(IURequestConfig *config) {
        config.api = api;
        config.method = IUNetworkingRequestMethod_FORM_DATA;
        config.parameters = parameters;
        config.files = files;
        config.success = success;
    }];
}

+ (instancetype)upload:(NSString *)api files:(NSArray <IURequestUploadFile *> *)files success:(IUNetworkingSuccess)success {
    return [self upload:api parameters:nil files:files success:success];
}

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
- (void)start {
    if ([[IURequestorRegistrar sharedInstance].requestors count]) {
        self.requestors = [IURequestorRegistrar sharedInstance].requestors;
        [[IURequestorRegistrar sharedInstance] clear];
    }
    
    /* requestors */
    NSArray <IUNetworkWeakRequestor> *requestors = self.requestors;
    IURequestConfig *config = self.config;
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        
        [requestors enumerateObjectsUsingBlock:^(IUNetworkWeakRequestor  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSObject *requestor = (NSObject *)obj();
            if ([requestor respondsToSelector:@selector(requestDidDelayByNetworkNotReachable:)]) {
                [requestor requestDidDelayByNetworkNotReachable:self];
            }
        }];

        __weak typeof(self) weakSelf = self;
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status != AFNetworkReachabilityStatusNotReachable) {
                [weakSelf.reachabilityManager setReachabilityStatusChangeBlock:nil];
                [weakSelf start];
            }
        }];
        return;
    }
    
    /* request serializer */
    AFHTTPRequestSerializer *requestSerializer = config.serializerType == IUNetworkingRequestSerializerType_URL ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
    // set timeout interval
    requestSerializer.timeoutInterval = config.timeoutInterval;
    // set headers
    [config.headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    /* session manager */
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // set timeout interval
    sessionConfiguration.timeoutIntervalForResource = config.timeoutInterval;
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
    // set security policy
    if (config.certificates) {
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey withPinnedCertificates:config.certificates];
        securityPolicy.allowInvalidCertificates = config.allowInvalidCertificates;
        securityPolicy.validatesDomainName = config.validatesDomainName;
        [sessionManager setSecurityPolicy:securityPolicy];
    }
    // set request serializer
    sessionManager.requestSerializer = requestSerializer;
    // set response serializer
    [sessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", @"charset=UTF-8", @"image/*", nil]];
    
    /* setup blocks */
    // completion
    void(^comletion)(void) = ^{
        [self _endRequestors:requestors];
        self.task = nil;
        [[IUBackgroundRequestPool pool].requests removeObject:self]; // release
    };
    // success
    void(^success)(NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *task, id responseObject) {
        if (config.enableRequestLog) {
            NSLog(@"\n✅request success\n➡️request url : %@\n➡️method : %@\n➡️parameter : %@\n➡️request response : %@", [config absoluteUrl], [config methodString], [config parameters], responseObject);
        }
        [IURequestorRegistrar sharedInstance].requestors = self.requestors;
        id model = [self convertModelFromData:responseObject];
        if ((!config.globalSuccess || config.globalSuccess(task, responseObject, model)) && config.success) config.success(task, responseObject, model);
        [[IURequestorRegistrar sharedInstance] clear];
        comletion();
    };
    // failure
    void(^failure)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (task.state == NSURLSessionTaskStateCanceling) {
            if (config.enableRequestLog) {
                NSLog(@"\n❎request cancelled\n➡️request url : %@\n➡️method : %@\n➡️parameter : %@\n", [config absoluteUrl], [config methodString], [config parameters]);
            }
        } else {
            if (config.enableRequestLog) {
                NSLog(@"\n⚠️request failure\n➡️request url : %@\n➡️method : %@\n➡️parameter : %@\n➡️request error : %@", [config absoluteUrl], [config methodString], [config parameters], error);
            }
            if ((!config.globalFailure || config.globalFailure(task, error)) && config.failure) config.failure(task, error);
            [requestors enumerateObjectsUsingBlock:^(IUNetworkWeakRequestor  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                id<IUNetworkingRequestDelegate> weakRequestor = obj();
                if ([weakRequestor respondsToSelector:@selector(request:didFailWithError:)]) {
                    [weakRequestor request:self didFailWithError:error];
                }
            }];
        }
        comletion();
    };
    
    /* begin request */
    [self _startRequestors:requestors];
    if (!self.autoCancel) [[IUBackgroundRequestPool pool].requests addObject:self]; // retain
    if (config.enableRequestLog) {
        NSLog(@"\n🕑request start\n➡️request url : %@\n➡️method : %@\n➡️parameter : %@", [config absoluteUrl], [config methodString], [config parameters]);
    }
    
    switch (config.method) {
        case IUNetworkingRequestMethod_GET:
        {
            self.task = [sessionManager GET:[config absoluteUrl]
                                 parameters:[config parameters]
                                   progress:[config downloadProgress]
                                    success:success
                                    failure:failure];
        }   break;
        case IUNetworkingRequestMethod_POST:
        {
            self.task = [sessionManager POST:[config absoluteUrl]
                                  parameters:[config parameters]
                                    progress:[config uploadProgress]
                                     success:success
                                     failure:failure];
        }   break;
        case IUNetworkingRequestMethod_PUT:
        {
            self.task = [sessionManager PUT:[config absoluteUrl]
                                 parameters:[config parameters]
                                    success:success
                                    failure:failure];
        }   break;
        case IUNetworkingRequestMethod_DELETE:
        {
            self.task = [sessionManager DELETE:[config absoluteUrl]
                                    parameters:[config parameters]
                                       success:success
                                       failure:failure];
        }   break;
        case IUNetworkingRequestMethod_HEAD:
        {
            self.task = [sessionManager HEAD:[config absoluteUrl]
                                  parameters:[config parameters]
                                     success:^(NSURLSessionDataTask * _Nonnull task) {
                                         success(task, nil);
                                     } failure:failure];
        }   break;
        case IUNetworkingRequestMethod_FORM_DATA:
        {
            void(^block)(id<AFMultipartFormData>) = ^(id<AFMultipartFormData>  _Nonnull formData) {
                [config.files enumerateObjectsUsingBlock:^(IURequestUploadFile * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [formData appendPartWithFileData:obj.data
                                                name:obj.name
                                            fileName:obj.fileName
                                            mimeType:obj.mimeType];
                }];
            };
            self.task = [sessionManager POST:[config absoluteUrl]
                                  parameters:[config parameters]
                   constructingBodyWithBlock:block
                                    progress:[config uploadProgress]
                                     success:success
                                     failure:failure];
        }   break;
        default:
            comletion();
            break;
    }
}

- (void)_startRequestors:(NSArray <IUNetworkWeakRequestor> *)requestors {
    [requestors enumerateObjectsUsingBlock:^(IUNetworkWeakRequestor  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSObject *requestor = (NSObject *)obj();
        if ([requestor respondsToSelector:@selector(request:didStart:)]) {
            [requestor request:self didStart:++requestor.requestingCount];
        }
    }];
}

- (void)_endRequestors:(NSArray <IUNetworkWeakRequestor> *)requestors {
    [requestors enumerateObjectsUsingBlock:^(IUNetworkWeakRequestor  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSObject *requestor = (NSObject *)obj();
        if ([requestor respondsToSelector:@selector(request:didComplete:)]) {
            [requestor request:self didComplete:--requestor.requestingCount];
        }
    }];
}

@end

static char TAG_REQUEST_COUNT;

@implementation NSObject (IUNetworkRequestingCount)

- (void)setRequestingCount:(NSInteger)requestingCount {
    objc_setAssociatedObject(self, &TAG_REQUEST_COUNT, @(requestingCount), OBJC_ASSOCIATION_RETAIN);
}

- (NSInteger)requestingCount {
    return [objc_getAssociatedObject(self, &TAG_REQUEST_COUNT) integerValue];
}

@end
