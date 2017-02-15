//
//  TestModel.h
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUBaseModel.h"
#import "IUKit.h"

@interface TestModel : IUBaseModel

@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) id data;

@end
