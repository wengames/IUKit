//
//  NSString+IUCrypto.h
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IUCrypto)

/**
 *  base64加密
 *
 *  @return         base64加密后的字符串
 */
- (NSString *)base64Encoding;

/**
 *  base64解密
 *
 *  @return         解密后的字符串
 */
- (NSString *)base64Decoding;

/**
 *  md5加密
 *
 *  @return         MD5加密后的字符串
 */
- (NSString *)md5Encoding;

@end
