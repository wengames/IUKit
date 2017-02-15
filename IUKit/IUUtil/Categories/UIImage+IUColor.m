//
//  UIImage+IUColor.m
//  IUImageTransform
//
//  Created by admin on 2017/2/9.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIImage+IUColor.h"

@implementation UIImage (IUColor)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectZero;
    rect.size = size;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColors:(NSArray *)colors size:(CGSize)size direction:(CGPoint)direction {
    // 可用CAGradientLayer实现
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSMutableArray *CGColors = [NSMutableArray arrayWithCapacity:[colors count]];
    for (int i = 0; i < [colors count]; i++) {
        id color = colors[i];
        if ([color isKindOfClass:[UIColor class]]) {
            [CGColors addObject:(__bridge id)((UIColor *)color).CGColor];
        } else {
            [CGColors addObject:color];
        }
    }
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)CGColors, nil);
    
    if (direction.x == 0 && direction.y == 0) {
        direction = CGPointMake(0, 1);
    }
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    if (direction.x == 0) {
        startPoint.x = 0;
        endPoint.x = 0;
    } else if (direction.x > 0) {
        startPoint.x = 0;
        endPoint.x = size.width;
    } else if (direction.x < 0) {
        startPoint.x = size.width;
        endPoint.x = 0;
    }
    
    if (direction.y == 0) {
        startPoint.y = 0;
        endPoint.y = 0;
    } else if (direction.y > 0) {
        startPoint.y = 0;
        endPoint.y = size.height;
    } else if (direction.y < 0) {
        startPoint.y = size.height;
        endPoint.y = 0;
    }
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    //从Context中获取图像，并显示在界面上
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColors:(NSArray *)colors size:(CGSize)size {
    return [self imageWithColors:colors size:size direction:CGPointMake(0, 1)];
}

- (UIColor *)colorAtPixel:(CGPoint)point
{
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point))
    {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.CGImage;
    NSUInteger width = self.size.width;
    NSUInteger height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
