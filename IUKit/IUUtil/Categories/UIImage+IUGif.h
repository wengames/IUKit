//
//  UIImage+IUGif.h
//  IUImageTransform
//
//  Created by admin on 2017/2/9.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IUGif)

/**
 *  通过gif生成UIImage
 *
 *  @param gifData   GIFData
 *  @return          UIImage
 */
+ (UIImage *)animatedImageWithGIFData:(NSData *)gifData;

/**
 *  通过gif生成UIImage
 *
 *  @param gifURL   GIF路径
 *  @return         UIImage
 */
+ (UIImage *)animatedImageWithGIFURL:(NSURL *)gifURL;

@end
