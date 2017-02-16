//
//  IURequestConfig.m
//  IUKitDemo
//
//  Created by admin on 2017/2/14.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IURequestConfig.h"
#import "NSURL+IUProtect.h"
#import "IURequestResult.h"

@implementation IURequestConfig

+ (instancetype)globalConfig {
    static dispatch_once_t onceToken;
    static IURequestConfig *__config = nil;
    dispatch_once(&onceToken, ^{
        __config = [[self alloc] init];
    });
    return __config;
}

+ (instancetype)config {
    return [[self globalConfig] deepCopy];
}

- (instancetype)init {
    if (self = [super init]) {
        self.fakeRequestDelay = 1;
        self.timeoutInterval = 30;
        self.validatesDomainName = YES;
        self.headers = @{};
    }
    return self;
}

- (Class)resultClass {
    return [_resultClass isSubclassOfClass:[IURequestResult class]] ? _resultClass : [IURequestResult class];
}

- (IUNetworkingRequestMethodName)methodName {
    return self.method >> 2;
}

- (IUNetworkingRequestSerializerType)serializerType {
    return self.method & 3;
}

- (NSString *)methodNameString {
    switch (self.methodName) {
        case IUNetworkingRequestMethodName_GET:
            return @"GET";
        case IUNetworkingRequestMethodName_POST:
            return @"POST";
        case IUNetworkingRequestMethodName_DELETE:
            return @"DELETE";
        case IUNetworkingRequestMethodName_PUT:
            return @"PUT";
        case IUNetworkingRequestMethodName_HEAD:
            return @"HEAD";
        case IUNetworkingRequestMethodName_FORM_DATA:
            return @"POST";
    }
    return nil;
}

- (NSString *)absoluteUrl {
    NSString *url = self.url ?: [NSString stringWithFormat:@"%@%@", self.root ?: @"", self.api ?: @""];
    if ([self.parameters isKindOfClass:[NSDictionary class]] && [self.parameters count] > 0) {
        NSMutableDictionary *parameters = [self.parameters mutableCopy];
        for (NSString *path in [[NSURL URLWithString:url].path_decoded componentsSeparatedByString:@"/"]) {
            if ([path hasPrefix:@":"]) {
                NSString *key = [path substringFromIndex:1];
                id value = parameters[key];
                if (![value isKindOfClass:[NSString class]]) {
                    value = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
                }
                if (value) {
                    [parameters removeObjectForKey:key];
                    url = [url stringByReplacingOccurrencesOfString:path withString:value];
                }
            }
        }
    }
    return url;
}

- (instancetype)deepCopy {
    IURequestConfig *config = [[self.class alloc] init];
    
    config.resultClass      = self.resultClass;
    config.modelClass       = self.modelClass;

    config.fakeRequest      = self.fakeRequest;
    config.fakeRequestDelay = self.fakeRequestDelay;
    
    config.enableRequestLog = self.enableRequestLog;
    
    config.timeoutInterval  = self.timeoutInterval;
    
    config.certificates             = self.certificates;
    config.allowInvalidCertificates = self.allowInvalidCertificates;
    config.validatesDomainName      = self.validatesDomainName;
    
    config.root             = self.root;
    config.api              = self.api;
    config.url              = self.url;
    
    config.headers          = self.headers;
    config.method           = self.method;
    
    config.parameters       = self.parameters;
    config.files            = self.files;
    
    config.uploadProgress   = self.uploadProgress;
    config.downloadProgress = self.downloadProgress;
    
    config.globalSuccess    = self.globalSuccess;
    config.globalFailure    = self.globalFailure;
    
    config.success          = self.success;
    config.failure          = self.failure;
    config.completion       = self.completion;
    
    return config;
}

@end
