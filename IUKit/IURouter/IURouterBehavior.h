//
//  IURouterBehavior.h
//  IURouter
//
//  Created by admin on 2017/2/7.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    IURouterBehaviorOperationPush = 0,
    IURouterBehaviorOperationPresent
} IURouterBehaviorOperation;

#define IURouterBehaviorBackToRoot NSUIntegerMax

@interface IURouterBehavior : NSObject

@property (nonatomic, assign) NSUInteger backCount;
@property (nonatomic, strong) UIViewController *(^controller)(void);
@property (nonatomic, assign) IURouterBehaviorOperation operation; // defaults IURouterBehaviorOperationPush

- (void)show; // show by operation type on key window
- (void)push;
- (void)pushInController:(UINavigationController *)controller; // show by push in navigation controller
- (void)present;
- (void)presentOnController:(UIViewController *)controller;    // show by present on controller

@end
