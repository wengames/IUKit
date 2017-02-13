//
//  UIColor+IUGenerator.m
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIColor+IUGenerator.h"

@implementation UIColor (IUGenerator)

+ (UIColor *)randomColor {
    return [self colorWithString:[NSString stringWithFormat:@"%d", arc4random() % 16777216 /* 256*256*256 */]];
}

+ (UIColor *)colorWithString:(NSString *)string {
    return [self colorWithString:string alpha:1.0];
}

+ (UIColor *)colorWithString:(NSString *)string alpha:(float)alpha {
    NSUInteger length = string.length;
    if (length >= 6) {
        string = [string substringFromIndex:length - 6];
    } else if (length >= 3) {
        string = [string substringFromIndex:length - 3];
        NSString *r = [string substringWithRange:NSMakeRange(0, 1)];
        NSString *g = [string substringWithRange:NSMakeRange(1, 1)];
        NSString *b = [string substringWithRange:NSMakeRange(2, 1)];
        string = [NSString stringWithFormat:@"%@%@%@%@%@%@", r, r, g, g, b, b];
    }
    
    long hex = 0;
    @try {
        hex = strtoul([string UTF8String], 0, 16);
    }
    @catch (NSException *exception) {
        hex = 0;
    }
    return [self colorWithHex:hex alpha:alpha];
}

+ (UIColor *)colorWithHex:(long)hex {
    return [self colorWithHex:hex alpha:1.0];
}

+ (UIColor *)colorWithHex:(long)hex alpha:(float)alpha {
    return [UIColor colorWithRed:((hex & 0xFF0000) >> 16)/255.f green:((hex & 0xFF00) >> 8)/255.f blue:(hex & 0xFF)/255.f alpha:alpha];
}

- (UIColor *)highlightedColor {
    CGFloat r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    r+=1.0; g+=1.0; b+=1.0; a+=1.0;
    r/=2.0; g/=2.0; b/=2.0; a/=2.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

- (UIColor *)invertColor {
    CGFloat r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    r = 1.0 - r;
    g = 1.0 - g;
    b = 1.0 - b;
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

- (CGFloat)red {
    CGFloat red;
    return [self getRed:&red green:nil blue:nil alpha:nil] ? red : 0;
}

- (CGFloat)green {
    CGFloat green;
    return [self getRed:nil green:&green blue:nil alpha:nil] ? green : 0;
}

- (CGFloat)blue {
    CGFloat blue;
    return [self getRed:nil green:nil blue:&blue alpha:nil] ? blue : 0;
}

- (CGFloat)hue {
    CGFloat hue;
    return [self getHue:&hue saturation:nil brightness:nil alpha:nil] ? hue : 0;
}

- (CGFloat)saturation {
    CGFloat saturation;
    return [self getHue:nil saturation:&saturation brightness:nil alpha:nil] ? saturation : 0;
}

- (CGFloat)brightness {
    CGFloat brightness;
    return [self getHue:nil saturation:nil brightness:&brightness alpha:nil] ? brightness : 0;
}

- (CGFloat)alpha {
    CGFloat alpha;
    return [self getRed:nil green:nil blue:nil alpha:&alpha] ? alpha : 1;
}

@end
