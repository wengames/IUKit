//
//  UIView+IUEmpty.h
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IUEmpty)

@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UIView *(^emptyViewGenerate)(void);

@property (nonatomic, assign, getter=isEmpty) BOOL empty;
- (void)setEmpty:(BOOL)empty animated:(BOOL)animated;

@end

@interface IUEmptyViewHelper : NSObject

@property (nonatomic, strong) UIView *(^emptyViewGenerate)(UIView *);

+ (instancetype)sharedInstance;

@end
