//
//  NSString+IURegex.m
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "NSString+IURegex.h"

@implementation NSString (IURegex)

- (BOOL)evaluateWithRegex:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (NSString *)substringWithRegex:(NSString *)regex {
    NSError *error = nil;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error) {
        NSTextCheckingResult *result = [regularExpression firstMatchInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
        return [self substringWithRange:result.range];
    }
    return @"";
}

- (NSArray <NSValue *> *)rangesWithRegex:(NSString *)regex {
    NSError *error = nil;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error) {
        NSArray<NSTextCheckingResult *> *results = [regularExpression matchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
        NSMutableArray *ranges = [NSMutableArray arrayWithCapacity:[results count]];
        for (NSTextCheckingResult *result in results) {
            [ranges addObject:[NSValue valueWithRange:result.range]];
        }
        return [ranges copy];
    }
    return @[];
}

- (NSString *)trimmedString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end

@implementation NSMutableString (IURegex)

- (void)filterStringWithRegex:(NSString *)regex {
    [self setString:[self substringWithRegex:regex]];
}

- (void)trim {
    [self setString:[self trimmedString]];
}

@end
