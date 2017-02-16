//
//  UIButton+IUColor.m
//  IUUtil
//
//  Created by admin on 2017/2/10.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIButton+IUColor.h"
#import "UIColor+IUGenerator.h"

UIImage *imageWithColor(UIColor *color) {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@implementation UIButton (IUColor)

- (void)setTitleColor:(UIColor *)titleColor {
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setTitleColor:[titleColor highlightedColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[titleColor highlightedColor] forState:UIControlStateDisabled];
}

- (UIColor *)titleColor {
    return [self titleColorForState:UIControlStateNormal];
}

- (void)setBackgroundImageColor:(UIColor *)backgroundImageColor {
    [self setBackgroundImage:imageWithColor(backgroundImageColor) forState:UIControlStateNormal];
    [self setBackgroundImage:imageWithColor([backgroundImageColor highlightedColor]) forState:UIControlStateHighlighted];
    [self setBackgroundImage:imageWithColor([backgroundImageColor highlightedColor]) forState:UIControlStateDisabled];
}

- (UIColor *)backgroundImageColor {
    return nil;
}

@end
