//
//  UIViewController+IUContainView.h
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (IUContainView)

- (BOOL)containView:(UIView *)view;
- (BOOL)ownView:(UIView *)view;

@end
