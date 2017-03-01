//
//  UIViewController+IUKeyboard.m
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IUKeyboard.h"
#import "UIViewController+IUSubviews.h"
#import "UIViewController+IUContainView.h"
#import <objc/runtime.h>
#import "IUMethodSwizzling.h"

static char TAG_KEYBOARD_FITTING_SCROLL_VIEW;
static char TAG_KEYBOARD_HEIGHT;

static char TAG_EDITING_VIEW;
static char TAG_IS_KEYBOARD_VISIBLE;
static char TAG_ORIGIN_FRAME;

@interface UIViewController ()

@property (nonatomic, assign) CGFloat keyboardHeight;

@property (nonatomic, strong) UIView *_editingView;
@property (nonatomic, assign) BOOL    _isKeyboardVisible;
@property (nonatomic, assign) CGRect  _originFrame;

@end

@implementation UIViewController (IUKeyboard)

+ (void)load {
    [self swizzleInstanceSelector:@selector(viewWillAppear:) toSelector:@selector(iuKeyboard_UIViewController_viewWillAppear:)];
    [self swizzleInstanceSelector:@selector(viewWillDisappear:) toSelector:@selector(iuKeyboard_UIViewController_viewWillDisappear:)];
    [self swizzleInstanceSelector:@selector(viewDidDisappear:) toSelector:@selector(iuKeyboard_UIViewController_viewDidDisappear:)];
}

- (void)iuKeyboard_UIViewController_viewWillAppear:(BOOL)animated {
    [self iuKeyboard_UIViewController_viewWillAppear:animated];
    [self _addObserverForKeyboard];
}

- (void)iuKeyboard_UIViewController_viewWillDisappear:(BOOL)animated {
    [self iuKeyboard_UIViewController_viewWillDisappear:animated];
    [self _removeobserverForKeyboard];
}

- (void)iuKeyboard_UIViewController_viewDidDisappear:(BOOL)animated {
    [self iuKeyboard_UIViewController_viewDidDisappear:animated];
    [self hideKeyboard];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (void)keyboardHeightChanged {
    // override point
}

- (UITapGestureRecognizer *)hideKeyboardTapGestureRecognizer {
    UITapGestureRecognizer *tapGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    if (tapGestureRecognizer == nil) {
        tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        objc_setAssociatedObject(self, _cmd, tapGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        tapGestureRecognizer.cancelsTouchesInView = NO;
    }
    return tapGestureRecognizer;
}

- (void)setKeyboardFittingScrollView:(UIScrollView *)keyboardFittingScrollView {
    objc_setAssociatedObject(self, &TAG_KEYBOARD_FITTING_SCROLL_VIEW, keyboardFittingScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIScrollView *)keyboardFittingScrollView {
    return objc_getAssociatedObject(self, &TAG_KEYBOARD_FITTING_SCROLL_VIEW);
}

- (void)set_editingView:(UIView *)_editingView {
    objc_setAssociatedObject(self, &TAG_EDITING_VIEW, _editingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)_editingView {
    return objc_getAssociatedObject(self, &TAG_EDITING_VIEW);
}

- (void)set_isKeyboardVisible:(BOOL)_isKeyboardVisible {
    objc_setAssociatedObject(self, &TAG_IS_KEYBOARD_VISIBLE, @(_isKeyboardVisible), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)_isKeyboardVisible {
    return [objc_getAssociatedObject(self, &TAG_IS_KEYBOARD_VISIBLE) boolValue];
}

- (void)set_originFrame:(CGRect)_originFrame {
    objc_setAssociatedObject(self, &TAG_ORIGIN_FRAME, [NSValue valueWithCGRect:_originFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)_originFrame {
    return [objc_getAssociatedObject(self, &TAG_ORIGIN_FRAME) CGRectValue];
}

- (void)setKeyboardHeight:(CGFloat)keyboardHeight {
    objc_setAssociatedObject(self, &TAG_KEYBOARD_HEIGHT, @(keyboardHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)keyboardHeight {
    return [objc_getAssociatedObject(self, &TAG_KEYBOARD_HEIGHT) floatValue];
}

#pragma mark - Private Method
/// 注册键盘出现、消失通知
- (void)_addObserverForKeyboard {
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
- (void)_removeobserverForKeyboard {
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Keyboard Observer Method
- (void)_editingViewChanged:(NSNotification *)notification {
    self._editingView = [self ownView:notification.object] ? notification.object : nil;
    if (self._editingView) {
        [(self.keyboardFittingScrollView ?: self.view) addGestureRecognizer:self.hideKeyboardTapGestureRecognizer];
    } else {
        [(self.keyboardFittingScrollView ?: self.view) removeGestureRecognizer:self.hideKeyboardTapGestureRecognizer];
    }
}

// 键盘出现, 保存底视图frame, 根据底视图类型, 滚动或移动底视图避让键盘
- (void)_keyboardWillShow:(NSNotification *)notification {
    if (self._isKeyboardVisible) return;
    self._isKeyboardVisible = YES;
    
    self._originFrame = self.view.frame;
    
    self.keyboardHeight = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self adjustFrameToFitKeyboard];
    
    [self keyboardHeightChanged];
}

- (void)_keyboardWillChangeFrame:(NSNotification *)notification {
    if (!self._isKeyboardVisible) return;
    
    self.keyboardHeight = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self adjustFrameToFitKeyboard];
    
    [self keyboardHeightChanged];
}

// 键盘消失, 还原frame大小, 移除键盘出现、消失通知, 释放编辑视图、底视图
- (void)_keyboardWillHide:(NSNotification *)notification {
    if (!self._isKeyboardVisible) return;
    self._isKeyboardVisible = NO;
    
    self.keyboardHeight = 0;
    self.view.frame = self._originFrame;
    self._editingView = nil;
    
    [self keyboardHeightChanged];
}

/// 根据当前键盘高度调整 self.keyboardFittingScrollView 的 frame, 随后滚动至输入框可见位置
- (void)adjustFrameToFitKeyboard {
    if (self.keyboardFittingScrollView == nil) return;
    
    CGRect frame = self._originFrame;
    
    CGRect windowFrame = [self.view.superview convertRect:self._originFrame toView:self.view.window];
    CGFloat delta = self.keyboardHeight - ([[UIScreen mainScreen] bounds].size.height - windowFrame.origin.y - windowFrame.size.height);
    delta = MAX(0, delta);
    frame.size.height -= delta;
    
    self.view.frame = frame;
    
    // 调整frame的同时滚动视图会失败, 需要延时
    [self performSelector:@selector(scrollToShowEditingView) withObject:nil afterDelay:0];
}

/// 滚动 self.keyboardFittingScrollView 至输入框可见位置
- (void)scrollToShowEditingView {
    CGRect rect = [self._editingView convertRect:self._editingView.bounds toView:self.keyboardFittingScrollView];
    rect.size.height += 20;
    [self.keyboardFittingScrollView scrollRectToVisible:rect animated:YES];
}

@end
