//
//  NSString+IUTokenizer.h
//  IUUtil
//
//  Created by admin on 2017/2/8.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IUTokenizer)

- (NSArray *)words;
- (NSArray *)sentences;
- (NSArray *)paragraphs;

@end
