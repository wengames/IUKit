//
//  UIButton+IUColor.m
//  IUUtil
//
//  Created by admin on 2017/2/10.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIButton+IUColor.h"
#import "UIColor+IUGenerator.h"
#import "IUMethodSwizzling.h"

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

+ (void)load {
    [self swizzleInstanceSelector:@selector(setBackgroundColor:) toSelector:@selector(iuColor_UIButton_setBackgroundColor:)];
}

- (void)setTitleColor:(UIColor *)titleColor {
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setTitleColor:[titleColor highlightedColor] forState:UIControlStateHighlighted];
}

- (UIColor *)titleColor {
    return [self titleColorForState:UIControlStateNormal];
}

- (void)iuColor_UIButton_setBackgroundColor:(UIColor *)backgroundColor {
    [self iuColor_UIButton_setBackgroundColor:backgroundColor];
    [self setBackgroundImage:imageWithColor(backgroundColor) forState:UIControlStateNormal];
    [self setBackgroundImage:imageWithColor([backgroundColor highlightedColor]) forState:UIControlStateHighlighted];
}

@end
