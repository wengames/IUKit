//
//  IUViewController.m
//  IUController
//
//  Created by admin on 2017/1/24.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUViewController.h"
#import "objc/runtime.h"

@interface UIViewController (IUViewOwner)

- (BOOL)hasView:(UIView *)view;
- (BOOL)ownView:(UIView *)view;

@end

@interface IUViewController () <UITextFieldDelegate>
{
    UIView *_editingView; // 编辑中的 textField 或 textView
    CGRect  _originFrame;
    BOOL    _isKeyboardVisible;
}

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicatorView;

@end

@implementation IUViewController

@synthesize hideKeyboardTapGestureRecognizer = _hideKeyboardTapGestureRecognizer;

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObserverForKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeobserverForKeyboard];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hideKeyboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - Actions
- (void)dismiss {
    if (self.presentingViewController) [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Private Method
/// 注册键盘出现、消失通知
- (void)addObserverForKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //  Registering for textField notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_editingViewChanged:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_editingViewChanged:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_editingViewChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    //  Registering for textView notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_editingViewChanged:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_editingViewChanged:) name:UITextViewTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_editingViewChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

/// 移除键盘出现、消失通知
- (void)removeobserverForKeyboard {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (UITapGestureRecognizer *)hideKeyboardTapGestureRecognizer {
    if (_hideKeyboardTapGestureRecognizer == nil) {
        _hideKeyboardTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    }
    return _hideKeyboardTapGestureRecognizer;
}

#pragma mark - UITextFieldDelegate
// 点击return键关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Keyboard Observer Method
//- (UIScrollView *)keyboardFittingScrollView {
//    if (_keyboardFittingScrollView == nil) {
//        if (_scrollView) {
//            return _scrollView;
//        }
//        if (_tableView) {
//            return _tableView;
//        }
//        if (_collectionView) {
//            return _collectionView;
//        }
//    }
//    return _keyboardFittingScrollView;
//}

- (void)_editingViewChanged:(NSNotification *)notification {
    _editingView = [self ownView:notification.object] ? notification.object : nil;
}

// 键盘出现, 保存底视图frame, 根据底视图类型, 滚动或移动底视图避让键盘
- (void)_keyboardWillShow:(NSNotification *)notification {
    if (_isKeyboardVisible) return;
    _isKeyboardVisible = YES;
    
    [(self.keyboardFittingScrollView ?: self.view) addGestureRecognizer:self.hideKeyboardTapGestureRecognizer];
    _originFrame = self.view.frame;
    
    _keyboardHeight = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self adjustFrameToFitKeyboard];
    
    [self keyboardHeightChanged];
}

- (void)_keyboardWillChangeFrame:(NSNotification *)notification {
    if (!_isKeyboardVisible) return;
    
    _keyboardHeight = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self adjustFrameToFitKeyboard];
    
    [self keyboardHeightChanged];
}

// 键盘消失, 还原frame大小, 移除键盘出现、消失通知, 释放编辑视图、底视图
- (void)_keyboardWillHide:(NSNotification *)notification {
    if (!_isKeyboardVisible) return;
    _isKeyboardVisible = NO;
    
    [(self.keyboardFittingScrollView ?: self.view) removeGestureRecognizer:self.hideKeyboardTapGestureRecognizer];
    _keyboardHeight = 0;
    self.view.frame = _originFrame;
    _editingView = nil;
    
    [self keyboardHeightChanged];
}

- (void)keyboardHeightChanged {
    // override point
}

/// 根据当前键盘高度调整 self.keyboardFittingScrollView 的 frame, 随后滚动至输入框可见位置
- (void)adjustFrameToFitKeyboard {
    if (self.keyboardFittingScrollView == nil) return;
    
    CGRect frame = _originFrame;
    
    CGRect windowFrame = [self.view.superview convertRect:_originFrame toView:self.view.window];
    CGFloat delta = _keyboardHeight - ([[UIScreen mainScreen] bounds].size.height - windowFrame.origin.y - windowFrame.size.height);
    delta = MAX(0, delta);
    frame.size.height -= delta;
    
    self.view.frame = frame;
    
    // 调整frame的同时滚动视图会失败, 需要延时
    [self performSelector:@selector(scrollToShowEditingView) withObject:nil afterDelay:0];
}

/// 滚动 self.keyboardFittingScrollView 至输入框可见位置
- (void)scrollToShowEditingView {
    CGRect rect = [_editingView convertRect:_editingView.bounds toView:self.keyboardFittingScrollView];
    rect.size.height += 20;
    [self.keyboardFittingScrollView scrollRectToVisible:rect animated:YES];
}

@end

@implementation UIViewController (IUViewOwner)

- (BOOL)hasView:(UIView *)view {
    if (![view isKindOfClass:[UIView class]]) return NO;
    while (view) {
        if (self.view == view) {
            return YES;
        }
        view = view.superview;
    }
    return NO;
}

- (BOOL)ownView:(UIView *)view {
    if ([self hasView:view]) {
        for (UIViewController *viewController in self.childViewControllers) {
            if ([viewController hasView:view]) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

@end
