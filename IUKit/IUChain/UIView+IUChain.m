//
//  UIView+IUChain.m
//  IUChain
//
//  Created by admin on 2017/1/19.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIView+IUChain.h"

#pragma clang diagnostic ignored "-Wobjc-property-implementation"
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation UIView (IUChain)

- (UIView *(^)(UIView *))intoView {
    return ^(UIView *superview) {
        [superview addSubview:self];
        return self;
    };
}

@end
