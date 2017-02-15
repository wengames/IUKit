//
//  NSURL+IUProtect.h
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (IUProtect)

@property (nullable, readonly, copy) NSString *absoluteString_decoded;
@property (nullable, readonly, copy) NSString *path_decoded;
@property (nullable, readonly, copy) NSString *query_decoded;

@end
