//
//  UIImage+IUFilter.m
//  IUImageTransform
//
//  Created by admin on 2017/2/9.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIImage+IUFilter.h"

@implementation UIImage (IUFilter)

- (UIImage *)imageWithFilterName:(NSString *)filterName options:(NSDictionary *)options {
    //创建滤镜
    CIFilter *filter = [CIFilter filterWithName:filterName];
    if (filter == nil) return self;
    
    //将UIImage转换成CIImage
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    //配置参数为默认值
    [filter setDefaults];
    
    //配置自定义参数
    for (NSString *key in options) {
        [filter setValue:options[key] forKey:key];
    }
        
    //获取绘制上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //渲染并输出CIImage
    CIImage *outputImage = [filter outputImage];
    
    //创建CGImage句柄
    CGRect rect = [@"CIGaussianBlur" isEqualToString:filterName] ? [inputImage extent] : [outputImage extent];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:rect];
    
    //获取图片
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    //释放CGImage句柄
    CGImageRelease(cgImage);

    return image ?: self;
}

- (void)imageWithFilterName:(NSString *)filterName completion:(void (^)(UIImage *))completion {
    [self imageWithFilterName:filterName options:nil completion:completion];
}

- (void)imageWithFilterName:(NSString *)filterName options:(NSDictionary *)options completion:(void(^)(UIImage *image))completion {
    if (completion == nil) return;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [self imageWithFilterName:filterName options:options];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    });
}

- (UIImage *)invertImage {
    return [self imageWithFilterName:@"CIColorInvert" options:nil];
}

- (UIImage *)blurredImage {
    return [self imageWithFilterName:@"CIGaussianBlur" options:nil];
}

- (UIImage *)blurredImageWithRadius:(CGFloat)radius {
    return [self imageWithFilterName:@"CIGaussianBlur" options:@{@"inputRadius":@(radius)}];
}

@end
