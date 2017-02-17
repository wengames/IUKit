//
//  UIViewController+IUMagicTransition.m
//  IUController
//
//  Created by admin on 2017/2/7.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IUMagicTransition.h"

@implementation UIViewController (IUMagicTransition)

- (NSArray *)magicViewsTransitionToViewController:(UIViewController *)viewController {
    return nil;
}

- (NSArray *)magicViewsTransitionFromViewController:(UIViewController *)viewController {
    return nil;
}

- (BOOL)enableMagicViewsLiftDropWhenTransitionToViewController:(UIViewController *)viewController {
    return YES;
}

- (BOOL)enableMagicViewsLiftDropWhenTransitionFromViewController:(UIViewController *)viewController {
    return YES;
}

@end
