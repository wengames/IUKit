//
//  UIViewController+IUPreviewing.h
//  IUController
//
//  Created by admin on 2017/2/8.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

// register UIViewControllerPreviewingDelegate as self,
// auto put on a UINavigationController when peeking, if the controller is not kind of UINavigationController
@interface UIViewController (IUPreviewing) <UIViewControllerPreviewingDelegate>

// return previewing action can be performed on current device and os or not
- (BOOL)canRegisterForPreviewing;

// register by view controller generator for source view
// caution: viewController block may cause retain cycle
- (void)registerPreviewingViewController:(UIViewController *(^)())viewController withSourceView:(UIView *)sourceView;

- (void)registerPreviewingWithSourceView:(UIView *)sourceView; // register by this method should also override method below
- (UIViewController *)viewControllerForPreviewingWithSourceView:(UIView *)sourceView; // override point

@end
