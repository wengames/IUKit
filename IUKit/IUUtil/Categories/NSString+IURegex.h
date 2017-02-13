//
//  NSString+IURegex.h
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IURegex)

/**
 *  检验字符串是否符合正则表达式
 *
 *  @param regex     正则表达式
 *  @return     检验成功返回 YES, 反之返回 NO
 */
- (BOOL)evaluateWithRegex:(NSString *)regex;

/**
 *  提取第一个满足正则表达式的字符串
 *
 *  @param regex     正则表达式
 *  @return     返回满足正则表达式的第一个字符串
 */
- (NSString *)substringWithRegex:(NSString *)regex;

/**
 *  获取所有匹配正则表达式的字符串范围
 *
 *  @param regex     正则表达式
 *  @return          匹配结果, NSRange(包装为NSValue)数组
 */
- (NSArray <NSValue *> *)rangesWithRegex:(NSString *)regex;

/**
 *  去除前后的空格
 *
 *  @return     trimmed string
 */
- (NSString *)trimmedString;

@end

@interface NSMutableString (IURegex)

/**
 *  使用正则表达式过滤字符串
 *
 *  @param regex     正则表达式
 */
- (void)filterStringWithRegex:(NSString *)regex;

/**
 *  去除前后的空格
 */
- (void)trim;

@end
