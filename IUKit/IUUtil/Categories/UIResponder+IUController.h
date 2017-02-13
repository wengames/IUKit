//
//  UIResponder+IUController.h
//  IUUtil
//
//  Created by admin on 2017/2/10.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (IUController)

@property (nonatomic, readonly) UIViewController       *viewController;
@property (nonatomic, readonly) UINavigationController *navigationController;
@property (nonatomic, readonly) UITabBarController     *tabBarController;

- (UIResponder *)nearestResponderOfClass:(Class)clazz;

@end
