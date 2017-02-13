//
//  IURouterBehavior.m
//  IURouter
//
//  Created by admin on 2017/2/7.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IURouterBehavior.h"

@implementation IURouterBehavior

- (void)show {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navigationController = nil;
    while (YES) {
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            navigationController = (UINavigationController *)viewController;
        }
        
        if (viewController.presentedViewController) {
            viewController = viewController.presentedViewController;
            continue;
        }
        
        if ([viewController isKindOfClass:[UITabBarController class]]) {
            viewController = [(UITabBarController *)viewController selectedViewController];
            continue;
        }
        
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            viewController = [(UINavigationController *)viewController topViewController];
            continue;
        }

        break;
    }
    
    if (self.operation == IURouterBehaviorOperationPush && navigationController) {
        [self pushInController:navigationController];
    } else {
        [self presentOnController:viewController];
    }
}

- (void)push {
    self.operation = IURouterBehaviorOperationPush;
    [self show];
}

- (void)pushInController:(UINavigationController *)controller {
    if (self.controller == nil) return;
    
    if (self.backCount == 0) {
        [controller pushViewController:self.controller() animated:YES];
    } else {
        NSMutableArray *viewControllers = [controller.viewControllers ?: @[] mutableCopy];
        for (int i = 0; [viewControllers count] > 1 && i < self.backCount; i++) {
            [viewControllers removeLastObject];
        }
        [viewControllers addObject:controller];
        [controller setViewControllers:[viewControllers copy] animated:YES];
    }
}

- (void)present {
    self.operation = IURouterBehaviorOperationPresent;
    [self show];
}

- (void)presentOnController:(UIViewController *)controller {
    if (self.controller == nil) return;

    __block NSUInteger backCount = self.backCount;
    __block void(^action)(void) = ^{
        
        if (controller.presentingViewController && backCount > 0) {
            backCount--;
            [controller dismissViewControllerAnimated:YES completion:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
                action();
#pragma clang diagnostic pop
            }];
        } else {
            [controller presentViewController:self.controller() animated:YES completion:nil];
        }
    };
    
    action();
}

@end
