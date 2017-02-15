//
//  UIViewController+IUContainView.m
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IUContainView.h"

@implementation UIViewController (IUContainView)

- (BOOL)containView:(UIView *)view {
    UIResponder *responder = view;
    while (responder) {
        if (responder == self) return YES;
        responder = responder.nextResponder;
    }
    return NO;
}

- (BOOL)ownView:(UIView *)view {
    UIResponder *responder = view;
    while (responder) {
        if (responder == self) return YES;
        if ([responder isKindOfClass:[UIViewController class]]) return NO;
        responder = responder.nextResponder;
    }
    return NO;
}

@end
