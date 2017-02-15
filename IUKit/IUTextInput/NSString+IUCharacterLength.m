//
//  NSString+IUCharacterLength.m
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "NSString+IUCharacterLength.h"

@implementation NSString (IUCharacterLength)

- (NSUInteger)characterLength {
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [[self dataUsingEncoding:encoding] length];
}

@end
