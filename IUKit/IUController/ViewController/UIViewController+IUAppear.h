//
//  UIViewController+IUAppear.h
//  IUController
//
//  Created by admin on 2017/2/8.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (IUAppear)

- (void)viewWillAppearForTheFirstTime:(BOOL)animated; // override point, invoked only once when -viewWillAppear: first be called
- (void)viewDidAppearForTheFirstTime:(BOOL)animated;  // override point, invoked only once when -viewDidAppear: first be called

@end
