//
//  TestDataFetcher.m
//  IUKitDemo
//
//  Created by admin on 2017/2/14.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "TestDataFetcher.h"

@implementation TestDataFetcher

+ (IURequestConfig *)defaultRequestConfig {
    IURequestConfig <TestModel *> *config = [super defaultRequestConfig];
    config.responseClass = [TestModel class];
    config.url = @"http://10.1.32.44/pci-user/api/common/version";
    config.method = IUNetworkingRequestMethod_GET;
    config.serializerType = IUNetworkingRequestSerializerType_URL;
    return config;
}

@end
