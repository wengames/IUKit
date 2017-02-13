//
//  UIViewController+IUAlertController.h
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

// 适配 iOS8前 UIActionSheet, UIAlertView 和 iOS8前后 UIAlertController

@interface UIViewController (IUAlertController)

/// action sheet
- (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message handle:(void(^)(NSInteger buttonIndex))handle cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/// alert view
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message handle:(void(^)(NSInteger buttonIndex))handle cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end

/**
 *  效果同js comfirm(), 阻塞线程, 同步得到确认结果
 */
BOOL confirm(NSString *message);
