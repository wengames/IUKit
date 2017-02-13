//
//  NSString+IUEvaluate.h
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IUEvaluate)

/** evaluate string is in email format or not */
- (BOOL)isEmail;
+ (BOOL)evaluateEmailString:(NSString *)string;

/** evaluate string is in identity card format or not */
- (BOOL)isIdentityCard;
+ (BOOL)evaluateIdentityCardString:(NSString *)string;

/** evaluate string is in number format or not */
- (BOOL)isNumber;
+ (BOOL)evaluateNumberString:(NSString *)string;

/** evaluate string is empty or not */
- (BOOL)isNonEmpty;
- (BOOL)isExist;
+ (BOOL)evaluateEmptyString:(NSString *)string;

@end
