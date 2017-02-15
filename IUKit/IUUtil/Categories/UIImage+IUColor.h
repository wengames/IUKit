//
//  UIImage+IUColor.h
//  IUImageTransform
//
//  Created by admin on 2017/2/9.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IUColor)

/**
 *  生成纯色UIImage
 *
 *  @param   color  颜色
 *  @param   size   image尺寸
 *  @return  纯色UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  生成渐变色UIImage
 *
 *  @param size             尺寸
 *  @param direction        渐变方向(默认{0,1}, 垂直向下)
 *  @param colors           颜色数组(UIColor 或 CGColorRef)
 *  @return                 渐变色UIImage
 */
+ (UIImage *)imageWithColors:(NSArray *)colors size:(CGSize)size direction:(CGPoint)direction;
+ (UIImage *)imageWithColors:(NSArray *)colors size:(CGSize)size;

/**
 *  取图片某一像素的颜色
 *
 *  @param point    图片上的点
 *  @return         该点像素的颜色
 */
- (UIColor *)colorAtPixel:(CGPoint)point;

@end
