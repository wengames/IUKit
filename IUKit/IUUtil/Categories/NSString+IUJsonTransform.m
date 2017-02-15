//
//  NSString+IUJsonTransform.m
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "NSString+IUJsonTransform.h"

@implementation NSString (IUJsonTransform)

+ (instancetype)stringWithJson:(id)json {
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
}

- (id)jsonData {
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
}

@end
