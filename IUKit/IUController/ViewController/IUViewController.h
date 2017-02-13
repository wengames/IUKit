//
//  IUViewController.h
//  IUController
//
//  Created by admin on 2017/1/24.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IUViewController : UIViewController

@property (nonatomic, strong, readonly) UITapGestureRecognizer *hideKeyboardTapGestureRecognizer;
@property (nonatomic, assign, readonly) CGFloat           keyboardHeight;               // current keyboard height
@property (nonatomic, strong)           UIScrollView     *keyboardFittingScrollView;    // a scroll view to fit with keyboard, can be nil

/// [self.view endEditing:YES]
- (void)hideKeyboard;
/// override point, will be invoked when keyboard height changed
- (void)keyboardHeightChanged;

@end
