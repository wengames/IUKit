//
//  UIImage+IUFilter.h
//  IUImageTransform
//
//  Created by admin on 2017/2/9.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IUFilter)

- (void)imageWithFilterName:(NSString *)filterName completion:(void(^)(UIImage *image))completion;
- (void)imageWithFilterName:(NSString *)filterName options:(NSDictionary *)options completion:(void(^)(UIImage *image))completion;
- (UIImage *)invertImage;
- (UIImage *)blurredImage;
- (UIImage *)blurredImageWithRadius:(CGFloat)radius;

@end
