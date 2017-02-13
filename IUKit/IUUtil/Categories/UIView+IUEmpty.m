//
//  UIView+IUEmpty.m
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIView+IUEmpty.h"
#import "objc/runtime.h"

static char TAG_EMPTY;
static char TAG_EMPTY_VIEW;
static char TAG_EMPTY_VIEW_GENERATE;

@implementation UIView (IUEmpty)

- (void)setEmptyView:(UIView *)emptyView {
    emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    if (self.isEmpty) {
        UIView *oldEmptyView = objc_getAssociatedObject(self, &TAG_EMPTY_VIEW);
        [oldEmptyView removeFromSuperview];
        emptyView.frame = self.bounds;
        [self addSubview:emptyView];
    }
    objc_setAssociatedObject(self, &TAG_EMPTY_VIEW, emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)emptyView {
    UIView *emptyView = objc_getAssociatedObject(self, &TAG_EMPTY_VIEW);
    if (emptyView == nil && self.emptyViewGenerate) {
        emptyView = self.emptyViewGenerate();
        emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        objc_setAssociatedObject(self, &TAG_EMPTY_VIEW, emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (emptyView == nil && [IUEmptyViewHelper sharedInstance].emptyViewGenerate) {
        emptyView = [IUEmptyViewHelper sharedInstance].emptyViewGenerate(self);
        emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        objc_setAssociatedObject(self, &TAG_EMPTY_VIEW, emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return emptyView;
}

- (void)setEmptyViewGenerate:(UIView *(^)(void))emptyViewGenerate {
    objc_setAssociatedObject(self, &TAG_EMPTY_VIEW_GENERATE, emptyViewGenerate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *(^)(void))emptyViewGenerate {
    return objc_getAssociatedObject(self, &TAG_EMPTY_VIEW_GENERATE);
}

- (BOOL)isEmpty {
    return [objc_getAssociatedObject(self, &TAG_EMPTY) boolValue];
}

- (void)setEmpty:(BOOL)empty {
    [self setEmpty:empty animated:NO];
}

- (void)setEmpty:(BOOL)empty animated:(BOOL)animated {
    if (empty == self.isEmpty) return;
    
    objc_setAssociatedObject(self, &TAG_EMPTY, @(empty), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (empty) {
        self.emptyView.frame = self.bounds;
        if (animated) {
            self.emptyView.alpha = 0;
            [self addSubview:self.emptyView];
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.emptyView.alpha = 1;
            } completion:nil];
        } else {
            [self addSubview:self.emptyView];
        }
    } else {
        
        if (animated) {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.emptyView.alpha = 0;
            } completion:^(BOOL finished) {
                if (self.isEmpty) [self.emptyView removeFromSuperview];
            }];
        } else {
            [self.emptyView removeFromSuperview];
        }
        
    }
}

@end

@implementation IUEmptyViewHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static IUEmptyViewHelper *helper = nil;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}

@end
