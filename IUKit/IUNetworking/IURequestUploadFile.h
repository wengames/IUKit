//
//  IURequestUploadFile.h
//  IUKitDemo
//
//  Created by admin on 2017/2/14.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IURequestUploadFile : NSObject

/**
 *  工厂方法
 *
 *  @param  data      数据
 *  @param  name      键名, set with "file" if is nil
 *  @param  fileName  文件名 , set with +defaultFileName if is nil
 *  @param  mimeType  文件类型 , set with "application/octet-stream" if is nil
 *  @return           实体
 */
+ (instancetype)fileWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;
+ (instancetype)fileWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName;
+ (instancetype)fileWithData:(NSData *)data name:(NSString *)name;
+ (instancetype)fileWithData:(NSData *)data;

+ (NSString *)defaultFileName;

@property (nonatomic, strong) NSData   *data;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fileName; 
@property (nonatomic, strong) NSString *mimeType;

@end
