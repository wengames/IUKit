//
//  IUDataFetcher.m
//  IUKitDemo
//
//  Created by admin on 2017/2/14.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUDataFetcher.h"
#import "IURequestorRegistrar.h"

// Declare private methods of IURequest
@interface IURequest ()

- (void)_startRequestors:(NSArray <IUNetworkWeakRequestor> *)requestors;
- (void)_endRequestors:(NSArray <IUNetworkWeakRequestor> *)requestors;

@end

@implementation IUDataFetcher

@dynamic autoCancel;

+ (instancetype)dataFetcher {
    IUDataFetcher *dataFetcher = [[self alloc] init];
    if (dataFetcher) {
        __weak typeof(dataFetcher) weakFetcher = dataFetcher;
        dataFetcher.parameters = dataFetcher.config.parameters;
        dataFetcher.config.success = ^(NSURLSessionDataTask *task, id responseObject, id model) {
            weakFetcher.data = responseObject;
            weakFetcher.model = model;
        };
    }
    return dataFetcher;
}

- (instancetype)init {
    if (self = [super init]) {
        self.autoCancel = YES;
    }
    return self;
}

- (void)setParameters:(id)parameters {
    if (_parameters != parameters) {
        _parameters = parameters;
        self.config.parameters = parameters;
        [self start];
    }
}

+ (IURequestConfig *)defaultRequestConfig {
    return [IURequestConfig config];
}

- (void)start {
    if (self.config.fakeRequest) {
        /* requestors */
        NSArray <IUNetworkWeakRequestor> *requestors = nil;
        if ([[IURequestorRegistrar sharedInstance].requestors count]) {
            requestors = [IURequestorRegistrar sharedInstance].requestors;
            [[IURequestorRegistrar sharedInstance] clear];
        }

        IURequestConfig *config = self.config;

        [self _startRequestors:requestors];
        if (config.enableRequestLog) {
            NSLog(@"\n🕑fake request start\n➡️request url : %@\n➡️method : %@\n➡️parameter : %@", [config absoluteUrl], [config methodString], [config parameters]);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(config.fakeRequestDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            id task = nil;
            id model = nil;
            if ([config.responseClass respondsToSelector:@selector(randomData)]) {
                model = [config.responseClass randomData];
            }
            id data = [self convertDataFromModel:model];
            
            if (config.enableRequestLog) {
                NSLog(@"\n✅fake request success\n➡️request url : %@\n➡️method : %@\n➡️parameter : %@\n➡️request response : %@", [config absoluteUrl], [config methodString], [config parameters], data);
            }

            if ((!config.globalSuccess || config.globalSuccess(task, data, model)) && config.success) config.success(task, data, model);
            [[IURequestorRegistrar sharedInstance] clear];

            [self _endRequestors:requestors];
        });
    } else {
        [super start];
    }
}

@end
