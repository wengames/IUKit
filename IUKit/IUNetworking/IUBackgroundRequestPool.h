//
//  IUBackgroundRequestPool.h
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IUBackgroundRequestPool : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *requests;

+ (instancetype)pool;

@end
