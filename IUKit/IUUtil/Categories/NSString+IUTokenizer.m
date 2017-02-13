//
//  NSString+IUTokenizer.m
//  IUUtil
//
//  Created by admin on 2017/2/8.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "NSString+IUTokenizer.h"

@implementation NSString (IUTokenizer)

- (NSArray *)words {
    return [self _tokens:kCFStringTokenizerUnitWord];
}

- (NSArray *)sentences {
    return [self _tokens:kCFStringTokenizerUnitSentence];
}

- (NSArray *)paragraphs {
    return [self _tokens:kCFStringTokenizerUnitParagraph];
}

- (NSArray *)_tokens:(CFOptionFlags)options {
    NSMutableArray *tokens = [@[] mutableCopy];
    CFStringTokenizerRef tokenizer = CFStringTokenizerCreate(NULL, (__bridge CFStringRef)self, CFRangeMake(0, self.length), options, NULL);
    CFRange range;
    while (CFStringTokenizerAdvanceToNextToken(tokenizer) != kCFStringTokenizerTokenNone) {
        range = CFStringTokenizerGetCurrentTokenRange(tokenizer);
        [tokens addObject:[self substringWithRange:NSMakeRange(range.location, range.length)]];
    }
    return [tokens copy];
}

@end
