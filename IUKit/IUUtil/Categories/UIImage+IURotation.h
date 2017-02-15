//
//  UIImage+IURotation.h
//  IUImageTransform
//
//  Created by admin on 2017/2/9.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IURotation)

/**
 *  纠正图片的方向
 *
 *  @return UIImage
 */
- (UIImage *)fixOrientation;

/**
 *  按给定的方向旋转图片
 *
 *  @param orient   UIImageOrientation枚举类
 *  @return         UIImage
 */
- (UIImage*)rotate:(UIImageOrientation)orient;

/**
 *  垂直翻转
 *
 *  @return UIImage
 */
- (UIImage *)flipVertical;

/**
 *  水平翻转
 *
 *  @return UIImage
 */
- (UIImage *)flipHorizontal;

/**
 *  将图片旋转degrees角度
 *
 *  @param degrees   角度
 *  @return          UIImage
 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/**
 *  将图片旋转radians弧度
 *
 *  @param radians   弧度
 *  @return          UIImage
 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

@end
