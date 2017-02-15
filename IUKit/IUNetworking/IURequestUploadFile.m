//
//  IURequestUploadFile.m
//  IUKitDemo
//
//  Created by admin on 2017/2/14.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IURequestUploadFile.h"

@implementation IURequestUploadFile

+ (instancetype)fileWithData:(NSData *)data {
    return [self fileWithData:data name:nil];
}

+ (instancetype)fileWithData:(NSData *)data name:(NSString *)name {
    return [self fileWithData:data name:name fileName:nil];
}

static int __uploadCount = 0;
+ (instancetype)fileWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName {
    return [self fileWithData:data name:name fileName:fileName mimeType:nil];
}

+ (instancetype)fileWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    IURequestUploadFile *file = [[self alloc] init];
    file.data = data;
    file.name = name ?: @"file";
    file.fileName = fileName ?: [self defaultFileName];
    file.mimeType = mimeType ?: @"application/octet-stream";
    return file;
}

+ (NSString *)defaultFileName {
    return [NSString stringWithFormat:@"%@%.0f%d", [[NSBundle mainBundle] bundleIdentifier] ?: @"", [[NSDate date] timeIntervalSince1970] * 1000, __uploadCount];
}

@end
