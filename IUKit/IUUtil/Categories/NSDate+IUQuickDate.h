//
//  NSDate+IUQuickDate.h
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (IUQuickDate)

@property (nonatomic, readonly) NSInteger weekday; // 1-7
@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger day;
@property (nonatomic, readonly) NSInteger hour;
@property (nonatomic, readonly) NSInteger minute;
@property (nonatomic, readonly) NSInteger second;
@property (nonatomic, readonly) BOOL      isWorkTime; // return YES if weekday is 1-5 & hour is 9-17; otherwise NO.

@property (nonatomic, readonly) NSString *autoString;

- (NSString *)stringWithFormat:(NSString *)format;

- (NSInteger)yearBeforeDate:(NSDate *)date;
- (NSInteger)monthBeforeDate:(NSDate *)date;
- (NSInteger)dayBeforeDate:(NSDate *)date;
- (NSInteger)hourBeforeDate:(NSDate *)date;
- (NSInteger)minuteBeforeDate:(NSDate *)date;
- (NSInteger)secondBeforeDate:(NSDate *)date;

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)formatter;

@end

@interface NSNumber (IUQuickDate)

- (NSDate *)date; // regard value as millisecond
- (NSString *)dateStringWithFormat:(NSString *)format;

@end
