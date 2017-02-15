//
//  NSString+IUAttributedStringTransform.m
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "NSString+IUAttributedStringTransform.h"

@implementation NSString (IUAttributedStringTransform)

- (NSAttributedString *)attributedStringByLineSpacing:(CGFloat)lineSpacing {
    return [[[NSAttributedString alloc] initWithString:self] attributedStringByLineSpacing:lineSpacing];
}

- (NSAttributedString *)htmlString {
    return [self htmlStringWithColor:@"#999" fontSize:14];
}

- (NSAttributedString *)htmlStringWithColor:(NSString *)color fontSize:(CGFloat)fontSize {
    NSString *htmlString = [NSString stringWithFormat:@"<p style='color:%@;font-size:%fpx'>%@</p>", color, fontSize, self];
    return [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
}

@end

@implementation NSAttributedString (IUChangeLineSpacing)

- (NSAttributedString *)attributedStringByLineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableAttributedString *attributedString = [self mutableCopy];
    [attributedString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attributedString.length)];
    return [attributedString copy];
}

@end
