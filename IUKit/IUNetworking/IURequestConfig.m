//
//  IURequestConfig.m
//  IUKitDemo
//
//  Created by admin on 2017/2/14.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IURequestConfig.h"
#import "NSURL+IUProtect.h"

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
    IURequestConfig *config = [[self alloc] init];
    IURequestConfig *globalConfig = [self globalConfig];
    
    config.responseClass    = globalConfig.responseClass;
    
    config.fakeRequest      = globalConfig.fakeRequest;
    config.fakeRequestDelay = globalConfig.fakeRequestDelay;

    config.enableRequestLog = globalConfig.enableRequestLog;
    
    config.timeoutInterval  = globalConfig.timeoutInterval;
    
    config.certificates             = globalConfig.certificates;
    config.allowInvalidCertificates = globalConfig.allowInvalidCertificates;
    config.validatesDomainName      = globalConfig.validatesDomainName;
    
    config.root             = globalConfig.root;
    config.api              = globalConfig.api;
    config.url              = globalConfig.url;
    
    config.headers          = globalConfig.headers;
    config.method           = globalConfig.method;
    
    config.parameters       = globalConfig.parameters;
    config.files            = globalConfig.files;
    
    config.uploadProgress   = globalConfig.uploadProgress;
    config.downloadProgress = globalConfig.downloadProgress;
    
    config.globalSuccess    = globalConfig.globalSuccess;
    config.globalFailure    = globalConfig.globalFailure;
    
    config.success          = globalConfig.success;
    config.failure          = globalConfig.failure;
    config.completion       = globalConfig.completion;
    
    return config;
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

- (NSString *)methodString {
    switch (self.method) {
        case IUNetworkingRequestMethod_GET:
            return @"GET";
        case IUNetworkingRequestMethod_POST:
            return @"POST";
        case IUNetworkingRequestMethod_DELETE:
            return @"DELETE";
        case IUNetworkingRequestMethod_PUT:
            return @"PUT";
        case IUNetworkingRequestMethod_HEAD:
            return @"HEAD";
        case IUNetworkingRequestMethod_FORM_DATA:
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

- (void)setMethodPostURL {
    self.method = IUNetworkingRequestMethod_POST;
    self.serializerType = IUNetworkingRequestSerializerType_URL;
}

- (void)setMethodPostJSON {
    self.method = IUNetworkingRequestMethod_POST;
    self.serializerType = IUNetworkingRequestSerializerType_JSON;
}

@end
