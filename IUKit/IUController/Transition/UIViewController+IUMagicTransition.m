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

@interface UINavigationController (IUMagicTransition)

@end

@implementation UINavigationController (IUMagicTransition)

- (NSArray *)magicViewsTransitionToViewController:(UIViewController *)viewController {
    return [self.topViewController magicViewsTransitionToViewController:viewController];
}

- (NSArray *)magicViewsTransitionFromViewController:(UIViewController *)viewController {
    return [self.topViewController magicViewsTransitionFromViewController:viewController];
}

- (BOOL)enableMagicViewsLiftDropWhenTransitionToViewController:(UIViewController *)viewController {
    return [self.topViewController enableMagicViewsLiftDropWhenTransitionToViewController:viewController];
}

- (BOOL)enableMagicViewsLiftDropWhenTransitionFromViewController:(UIViewController *)viewController {
    return [self.topViewController enableMagicViewsLiftDropWhenTransitionToViewController:viewController];
}

@end

@interface UITabBarController (IUMagicTransition)

@end

@implementation UITabBarController (IUMagicTransition)

- (NSArray *)magicViewsTransitionToViewController:(UIViewController *)viewController {
    return [self.selectedViewController magicViewsTransitionToViewController:viewController];
}

- (NSArray *)magicViewsTransitionFromViewController:(UIViewController *)viewController {
    return [self.selectedViewController magicViewsTransitionFromViewController:viewController];
}

- (BOOL)enableMagicViewsLiftDropWhenTransitionToViewController:(UIViewController *)viewController {
    return [self.selectedViewController enableMagicViewsLiftDropWhenTransitionToViewController:viewController];
}

- (BOOL)enableMagicViewsLiftDropWhenTransitionFromViewController:(UIViewController *)viewController {
    return [self.selectedViewController enableMagicViewsLiftDropWhenTransitionToViewController:viewController];
}

@end
