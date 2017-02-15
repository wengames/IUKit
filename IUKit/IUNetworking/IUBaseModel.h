//
//  IUBaseModel.h
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IUBaseModel : NSObject

/* 获取对象的所有属性 */
+ (NSArray *)getAllProperties;

/* 获取字典 key:属性-value:属性 */
+ (NSDictionary *)getDicPropertiesToSameValue;

/* 替换属性 */
+ (NSDictionary *)UpdateRuleDic:(NSDictionary *)updateDic;

+ (void)clearRule;

+ (instancetype)randomData;

@end
