//
//  IUTabPageViewController.h
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IUTabPageView.h"

@interface IUTabPageViewController : UIViewController <IUTabPageViewDelegate>

@property (nonatomic, strong, readonly) IUTabPageView *tabPageView;
@property (nonatomic, strong) NSArray <UIViewController *> *viewControllers;

@end
