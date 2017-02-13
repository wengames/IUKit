//
//  NSString+IUEvaluate.m
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "NSString+IUEvaluate.h"

@implementation NSString (IUEvaluate)

/** email */
- (BOOL)isEmail {
    return [self.class evaluateEmailString:self];
}

+ (BOOL)evaluateEmailString:(NSString *)string {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:string];
}

/** identity card */
- (BOOL)isIdentityCard {
    return [self.class evaluateIdentityCardString:self];
}

+ (BOOL)evaluateIdentityCardString:(NSString *)string {
    NSString *IdentityCardRegex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",IdentityCardRegex];
    return [identityCardPredicate evaluateWithObject:string];
}

/** number */
- (BOOL)isNumber {
    return [self.class evaluateNumberString:self];
}

+ (BOOL)evaluateNumberString:(NSString *)string {
    if ([self evaluateEmptyString:string]) return NO;
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *flitered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    return [string isEqualToString:flitered];
}

/** empty */
- (BOOL)isNonEmpty {
    return ![self.class evaluateEmptyString:self];
}

- (BOOL)isExist {
    return ![self.class evaluateEmptyString:self];
}

+ (BOOL)evaluateEmptyString:(NSString *)string {
    return string == nil || ![string isKindOfClass:[NSString class]] || [string isEqualToString:@""] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
}

@end
