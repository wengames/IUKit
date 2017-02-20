//
//  UINavigationController+IUFullScreenInteractivePopGestureRecognizer.h
//  IUController
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (IUFullScreenInteractivePopGestureRecognizer)

@property (nonatomic, readonly) UIGestureRecognizer *fullScreenInteractivePopGestureRecognizer; // enable default is YES

@end

@interface UIViewController (IUPopBack)

@property (nonatomic, strong) UIBarButtonItem *backButtonItem;    // default is a bar button item with an arrow image, set nil to hide it
@property (nonatomic, strong) UIBarButtonItem *dismissButtonItem; // default is a bar button item with a button as a custom view, set nil to hide it

// action of backButtonItem
// defaults call [self.navigationController popViewControllerAnimated:YES]
- (void)popBack;

// action of dismissButtonItem
// defaults call [self dismissViewControllerAnimated:YES completion:nil]
- (void)dismiss;

// override point, will be invoked before popBack called
// defaults return YES
- (BOOL)shouldPopBack;

@end
