//
//  UIImage+IUTransform.h
//  IUImageTransform
//
//  Created by admin on 2017/2/9.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IUTransform)

/**
 *  压缩图片至 size(单位KB) 以下大小, 如无法压至该尺寸以下, 则取最大压缩尺寸
 *
 *  @param size    要求大小上限, 单位KB
 *  @return        压缩后的NSData
 */
- (NSData *)transformToDataBelowSize:(CGFloat)size;

/** 截取当前image对象rect区域内的图像 */
- (UIImage *)subImageWithRect:(CGRect)rect;

/** 压缩图片至指定尺寸 */
- (UIImage *)rescaleImageToSize:(CGSize)size;

/** 压缩图片至指定像素 */
- (UIImage *)rescaleImageToPX:(CGFloat )toPX;

/** 在指定的size里面生成一个平铺的图片 */
- (UIImage *)getTiledImageWithSize:(CGSize)size;

/** 渲染图片颜色为 color */
- (UIImage *)renderedImageWithColor:(UIColor *)color;

/** 获得灰度图 */
- (UIImage *)grayImage;

/** UIView转化为UIImage */
+ (UIImage *)imageFromView:(UIView *)view;

/** 将两个图片生成一张图片 */
+ (UIImage *)mergeImage:(UIImage *)firstImage withImage:(UIImage *)secondImage;
- (UIImage *)mergedImageWithImage:(UIImage *)image;

@end
