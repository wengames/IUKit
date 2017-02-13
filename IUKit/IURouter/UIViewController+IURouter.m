//
//  UIViewController+IURouter.m
//  IURouter
//
//  Created by admin on 2017/2/7.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IURouter.h"
#import <objc/runtime.h>

static char TAG_ROUTER_PARAMETERS;

@implementation UIViewController (IURouter)

- (IURouterParameter *)parameters {
    return objc_getAssociatedObject(self, &TAG_ROUTER_PARAMETERS);
}

- (void)setParameters:(IURouterParameter *)parameters {
    objc_setAssociatedObject(self, &TAG_ROUTER_PARAMETERS, parameters, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation IURouterParameter

@end
