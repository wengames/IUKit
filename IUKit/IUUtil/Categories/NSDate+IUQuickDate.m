//
//  NSDate+IUQuickDate.m
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "NSDate+IUQuickDate.h"
#import <UIKit/UIKit.h>

static NSDateFormatter *__dateFormatter = nil;

@implementation NSDate (IUQuickDate)

+ (void)load {
    __dateFormatter = [[NSDateFormatter alloc] init];
    __dateFormatter.locale = [NSLocale systemLocale];
}

- (NSInteger)weekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *components;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        components = [calendar components:NSWeekdayCalendarUnit fromDate:self];
#pragma clang diagnostic pop
    }
    return (components.weekday + 5) % 7 + 1;
}

- (NSInteger)year {
    return [[self stringWithFormat:@"yyyy"] integerValue];
}

- (NSInteger)month {
    return [[self stringWithFormat:@"M"] integerValue];
}

- (NSInteger)day {
    return [[self stringWithFormat:@"d"] integerValue];
}

- (NSInteger)hour {
    return [[self stringWithFormat:@"H"] integerValue];
}

- (NSInteger)minute {
    return [[self stringWithFormat:@"m"] integerValue];
}

- (NSInteger)second {
    return [[self stringWithFormat:@"s"] integerValue];
}

- (BOOL)isWorkTime {
    return self.weekday <= 5 && self.hour >= 9 && self.hour < 18;
}

- (NSString *)autoString {
    NSString *dateFormat = @"";
    NSDate *now = [NSDate date];
    switch ([self dayBeforeDate:now]) {
        case 0:
            dateFormat = @"HH:mm";
            break;
        case 1:
            dateFormat = @"昨天 HH:mm";
            break;
        case 2:
            dateFormat = @"前天 HH:mm";
            break;
            
        default:
            dateFormat = @"MM-dd HH:mm";
            break;
    }
    return [self stringWithFormat:dateFormat];
}

- (NSInteger)yearBeforeDate:(NSDate *)date {
    return date.year - self.year;
}

- (NSInteger)monthBeforeDate:(NSDate *)date {
    return (date.year - self.year) * 12 + (date.month - self.month);
}

- (NSInteger)dayBeforeDate:(NSDate *)date {
    NSString *dateFormat = @"yyyy-MM-dd";
    NSDate *date1 = [NSDate dateWithString:[self stringWithFormat:dateFormat] format:dateFormat];
    NSDate *date2 = [NSDate dateWithString:[date stringWithFormat:dateFormat] format:dateFormat];
    return [date2 timeIntervalSinceDate:date1] / 86400.f;
}

- (NSInteger)hourBeforeDate:(NSDate *)date {
    NSString *dateFormat = @"yyyy-MM-dd HH";
    NSDate *date1 = [NSDate dateWithString:[self stringWithFormat:dateFormat] format:dateFormat];
    NSDate *date2 = [NSDate dateWithString:[date stringWithFormat:dateFormat] format:dateFormat];
    return [date2 timeIntervalSinceDate:date1] / 3600.f;
}

- (NSInteger)minuteBeforeDate:(NSDate *)date {
    NSString *dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date1 = [NSDate dateWithString:[self stringWithFormat:dateFormat] format:dateFormat];
    NSDate *date2 = [NSDate dateWithString:[date stringWithFormat:dateFormat] format:dateFormat];
    return [date2 timeIntervalSinceDate:date1] / 60.f;
}

- (NSInteger)secondBeforeDate:(NSDate *)date {
    return [date timeIntervalSinceDate:self];
}

- (NSString *)stringWithFormat:(NSString *)format {
    __dateFormatter.dateFormat = format;
    return [__dateFormatter stringFromDate:self];
}

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format {
    __dateFormatter.dateFormat = format;
    return [__dateFormatter dateFromString:dateString];
}

@end

@implementation NSNumber (IUQuickDate)

- (NSDate *)date {
    return [NSDate dateWithTimeIntervalSince1970:[self doubleValue]/1000.f];
}

- (NSString *)dateStringWithFormat:(NSString *)format {
    return [[self date] stringWithFormat:format];
}

@end
