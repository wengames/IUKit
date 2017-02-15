//
//  NSString+IUAttributedStringTransform.h
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (IUAttributedStringTransform)

/**
 *  生成带有行高属性的属性文本
 *
 *  @param  lineSpacing         行距
 *  @return 带有行高属性的属性文本
 */
- (NSAttributedString *)attributedStringByLineSpacing:(CGFloat)lineSpacing;

/**
 *  根据html生成属性文本
 *
 *  @param  color      属性文本默认字体颜色(默认#999)
 *  @param  fontSize   属性文本默认字体大小(默认14)
 *  @return 属性文本
 */
- (NSAttributedString *)htmlStringWithColor:(NSString *)color fontSize:(CGFloat)fontSize;
- (NSAttributedString *)htmlString;

@end

@interface NSAttributedString (IUChangeLineSpacing)

/**
 *  生成带有行高属性的属性文本
 *
 *  @param  lineSpacing         行距
 *  @return 带有行高属性的属性文本
 */
- (NSAttributedString *)attributedStringByLineSpacing:(CGFloat)lineSpacing;

@end
