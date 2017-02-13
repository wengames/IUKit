//
//  UIColor+IUGenerator.h
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (IUGenerator)

+ (UIColor *)randomColor;
+ (UIColor *)colorWithString:(NSString *)string;
+ (UIColor *)colorWithString:(NSString *)string alpha:(float)alpha;
+ (UIColor *)colorWithHex:(long)hex;
+ (UIColor *)colorWithHex:(long)hex alpha:(float)alpha;

- (UIColor *)highlightedColor;
- (UIColor *)invertColor;

- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;

- (CGFloat)hue;
- (CGFloat)saturation;
- (CGFloat)brightness;

- (CGFloat)alpha;

@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithHex:rgbValue]
