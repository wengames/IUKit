//
//  IUDataFetcher.h
//  IUKitDemo
//
//  Created by admin on 2017/2/14.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IURequest.h"

@interface IUDataFetcher <__covariant T : IUBaseModel *> : IURequest

@property (nonatomic, assign) BOOL autoCancel; // default is YES

@property (nonatomic, strong) id parameters;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) T  model;

+ (instancetype)dataFetcher;

/**
 *  override point
 *  default config
 *  one fetcher one request
 */
+ (IURequestConfig *)defaultRequestConfig;

@end
