//
//  UIViewController+IURouter.h
//  IURouter
//
//  Created by admin on 2017/2/7.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IURouterParameter : NSObject

@property (nonatomic, strong) NSArray *argv;
@property (nonatomic, strong) NSDictionary *params;

@end

@interface UIViewController (IURouter)

@property (nonatomic, strong) IURouterParameter *parameters;

@end
