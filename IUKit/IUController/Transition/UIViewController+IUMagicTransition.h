//
//  UIViewController+IUMagicTransition.h
//  IUController
//
//  Created by admin on 2017/2/7.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (IUMagicTransition)

- (NSArray *)magicViewsTransitionToViewController:(UIViewController *)viewController;
- (NSArray *)magicViewsTransitionFromViewController:(UIViewController *)viewController;

@end
