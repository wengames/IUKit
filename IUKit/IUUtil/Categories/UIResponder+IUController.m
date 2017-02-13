//
//  UIResponder+IUController.m
//  IUUtil
//
//  Created by admin on 2017/2/10.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIResponder+IUController.h"

@implementation UIResponder (IUController)

- (UIViewController *)viewController {
    return (UIViewController *)[self nearestResponderOfClass:[UIViewController class]];
}

- (UINavigationController *)navigationController {
    return (UINavigationController *)[self nearestResponderOfClass:[UIViewController class]];
}

- (UITabBarController *)tabBarController {
    return (UITabBarController *)[self nearestResponderOfClass:[UITabBarController class]];
}

- (UIResponder *)nearestResponderOfClass:(Class)clazz {
    UIResponder *responder = self;
    while (responder && ![responder isKindOfClass:clazz]) {
        responder = [responder nextResponder];
    }
    return (UIViewController *)responder;
}

@end
