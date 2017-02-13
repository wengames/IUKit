//
//  UINavigationController+IUAutoHidesBottomBarWhenPushed.h
//  IUController
//
//  Created by admin on 2017/1/24.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (IUAutoHidesBottomBarWhenPushed)

@end

@interface UIViewController (IUAutoHidesBottomBarWhenPushed)

@property (nonatomic, assign) BOOL ignoreAutoHidesBottomBarWhenPushed; // default is NO

@end
