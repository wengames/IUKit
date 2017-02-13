//
//  IUTextInputRestrict.m
//  IUTextInput
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUTextInputRestrict.h"
#import <UIKit/UIKit.h>

@interface IUTextInputRestrict ()

@property (nonatomic, assign) NSUInteger maxTextLength; // restricts text length, default is NSUIntegerMax

@end

@implementation IUTextInputRestrict

+ (instancetype)textInputRestrict {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.maxTextLength = NSUIntegerMax;
    }
    return self;
}

- (void)_textDidChange:(UITextField *)textField {
    if (textField.markedTextRange) return;
    // get text
    NSString *text = textField.text;
    
    // get cursor start index
    NSInteger index = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    
    // handle text & index
    NSInteger indexAfter = [self restrictText:&text cursorIndex:index];
    
    // return if text not changed
    if ([text isEqualToString:textField.text] && indexAfter == index) return;

    // set text immediately if the text field is not the first responder
    if (!textField.isFirstResponder) {
        textField.text = text;
        return;
    }
    
    /* adjust undo stack */
    NSUndoManager *undoManager = textField.undoManager;
    // undo once
    if ([undoManager canUndo] && ![undoManager isUndoing] && ![undoManager isRedoing]) {
        [undoManager undo];
    }
    
    // if text is same with target text, undo once again
    if ([text isEqualToString:textField.text] && [undoManager canUndo] && ![undoManager isUndoing] && ![undoManager isRedoing]) {
        [undoManager undo];
    }
    
    // reset text, clear redo stack
    [textField replaceRange:[textField textRangeFromPosition:textField.beginningOfDocument toPosition:textField.endOfDocument] withText:text];
    
    // config cursor position
    UITextPosition *position = [textField positionFromPosition:textField.beginningOfDocument offset:indexAfter];
    textField.selectedTextRange = [textField textRangeFromPosition:position toPosition:position];
}

- (NSInteger)handleText:(inout NSString **)text cursorIndex:(NSInteger)cursorIndex {
    return cursorIndex;
}

- (NSInteger)restrictText:(inout NSString **)text cursorIndex:(NSInteger)cursorIndex {
    // handle text & index
    NSInteger indexAfter = [self handleText:text cursorIndex:cursorIndex];
    
    // restrict max text length
    if ((*text).length > self.maxTextLength) *text = [*text substringToIndex:self.maxTextLength];
    
    // fix index below text length
    indexAfter = MIN(indexAfter, (*text).length);
    
    return indexAfter;
}

@end

@implementation IUTextInputRestrictNumberOnly

- (NSInteger)handleText:(inout NSString **)text cursorIndex:(NSInteger)cursorIndex {
    NSInteger returnIndex = cursorIndex;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]*$"];
    NSMutableString *string = [@"" mutableCopy];
    for (int i = 0; i < [*text length]; i++) {
        NSString *charater = [*text substringWithRange:NSMakeRange(i, 1)];
        if ([predicate evaluateWithObject:charater]) {
            [string appendString:charater];
        } else if (i < cursorIndex) {
            returnIndex--;
        }
    }
    *text = [string copy];
    return returnIndex;
}

@end

@implementation IUTextInputRestrictNumberWithFormat

+ (instancetype)textInputRestrictWithFormat:(NSString *)format {
    IUTextInputRestrictNumberWithFormat *textInputRestrict = [self textInputRestrict];
    textInputRestrict.format = format;
    return textInputRestrict;
}

- (instancetype)init {
    if (self = [super init]) {
        self.format = @"0";
    }
    return self;
}

- (void)setFormat:(NSString *)format {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[^0-9]"];
    if ([predicate evaluateWithObject:format]) {
        _format = [@"0" stringByAppendingString:format];
    } else {
        _format = format;
    }
}

- (NSInteger)restrictText:(inout NSString **)text cursorIndex:(NSInteger)cursorIndex {
    NSInteger returnIndex = cursorIndex;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]*$"];
    NSMutableString *string = [@"" mutableCopy];
    for (int i = 0, j = 0, k = 0; i < [*text length] && k < self.maxTextLength; i++) {
        NSString *charater = [*text substringWithRange:NSMakeRange(i, 1)];
        if ([predicate evaluateWithObject:charater]) {
            NSString *f = [self.format substringWithRange:NSMakeRange(j++ % [self.format length], 1)];
            while (![predicate evaluateWithObject:f]) {
                [string appendString:f];
                f = [self.format substringWithRange:NSMakeRange(j++ % [self.format length], 1)];
                if (i < cursorIndex) {
                    returnIndex++;
                }
            }
            [string appendString:charater];
            k++;
        } else if (i < cursorIndex) {
            returnIndex--;
        }
    }
    
    returnIndex = MIN(returnIndex, [string length]);
    
    *text = [string copy];

    return returnIndex;
}

@end

@implementation IUTextInputRestrictPhone

+ (instancetype)textInputRestrictWithFormat:(NSString *)format {
    return [super textInputRestrictWithFormat:format];
}

+ (instancetype)textInputRestrictWithSeparator:(NSString *)separator {
    IUTextInputRestrictPhone *textInputRestrict = [self textInputRestrict];
    textInputRestrict.separator = separator;
    return textInputRestrict;
}

- (NSString *)separator {
    return _separator ?: @"";
}

- (NSUInteger)maxTextLength {
    return 11;
}

- (NSString *)format {
    return [NSString stringWithFormat:@"000%@0000%@0000", self.separator, self.separator];
}

@end

@implementation IUTextInputRestrictDecimalOnly

+ (instancetype)textInputRestrictWithDecimalDigits:(NSUInteger)decimalDigits {
    IUTextInputRestrictDecimalOnly *textInputRestrict = [self textInputRestrict];
    textInputRestrict.decimalDigits = decimalDigits;
    return textInputRestrict;
}

- (instancetype)init {
    if (self = [super init]) {
        self.decimalDigits = NSUIntegerMax;
    }
    return self;
}

- (NSInteger)handleText:(inout NSString **)text cursorIndex:(NSInteger)cursorIndex {
    NSInteger returnIndex = cursorIndex;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]*$"];
    NSPredicate *dotPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[.]*$"];
    NSMutableString *string = [@"" mutableCopy];
    BOOL hasDotBefore = NO;
    for (int i = 0; i < [*text length]; i++) {
        NSString *charater = [*text substringWithRange:NSMakeRange(i, 1)];
        if ([predicate evaluateWithObject:charater]) {
            [string appendString:charater];
        } else if (!hasDotBefore && [dotPredicate evaluateWithObject:charater]) {
            hasDotBefore = YES;
            [string appendString:charater];
        } else if (i < cursorIndex) {
            returnIndex--;
        }
    }
    *text = [string copy];
    
    NSRange dotRange = [*text rangeOfString:@"."];
    if (dotRange.location != NSNotFound) {
        NSInteger digitLength = [*text length] - dotRange.location - dotRange.length;
        if (digitLength > self.decimalDigits) {
            *text = [*text substringToIndex:dotRange.location + dotRange.length + self.decimalDigits];
        }
    }
    return returnIndex;
}

@end

@implementation IUTextInputRestrictDecimalNegative

- (NSInteger)handleText:(inout NSString **)text cursorIndex:(NSInteger)cursorIndex {
    NSInteger returnIndex = cursorIndex;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]*$"];
    NSPredicate *dotPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[.]*$"];
    NSPredicate *minusPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[-]*$"];
    NSMutableString *string = [@"" mutableCopy];
    BOOL hasDotBefore = NO;
    for (int i = 0; i < [*text length]; i++) {
        NSString *charater = [*text substringWithRange:NSMakeRange(i, 1)];
        if ((i == 0 && [minusPredicate evaluateWithObject:charater]) ||
            [predicate evaluateWithObject:charater]) {
            [string appendString:charater];
        } else if (!hasDotBefore && [dotPredicate evaluateWithObject:charater]) {
            hasDotBefore = YES;
            [string appendString:charater];
        } else if (i < cursorIndex) {
            returnIndex--;
        }
    }
    *text = [string copy];
    
    NSRange dotRange = [*text rangeOfString:@"."];
    if (dotRange.location != NSNotFound) {
        NSInteger digitLength = [*text length] - dotRange.location - dotRange.length;
        if (digitLength > self.decimalDigits) {
            *text = [*text substringToIndex:dotRange.location + dotRange.length + self.decimalDigits];
        }
    }
    return returnIndex;
}

@end

@implementation IUTextInputRestrictCharaterOnly

- (NSInteger)handleText:(inout NSString **)text cursorIndex:(NSInteger)cursorIndex {
    NSInteger returnIndex = cursorIndex;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[^\u4e00-\u9fa5]*$"];
    NSMutableString *string = [@"" mutableCopy];
    for (int i = 0; i < [*text length]; i++) {
        NSString *charater = [*text substringWithRange:NSMakeRange(i, 1)];
        if ([predicate evaluateWithObject:charater]) {
            [string appendString:charater];
        } else if (i < cursorIndex) {
            returnIndex--;
        }
    }
    *text = [string copy];
    return returnIndex;
}

@end

@interface IUTextInputRestrictIdentityCard ()

@property (nonatomic, strong) UIButton *xButton;

@end

@implementation IUTextInputRestrictIdentityCard

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)_keyboardWillShow:(NSNotification *)notification {
    __weak typeof(self) ws = self;
    NSDictionary *info = notification.userInfo;
    CGRect frame = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] lastObject];
    [tempWindow addSubview:self.xButton];
    if ([self.inputView isFirstResponder]) {
        
        [UIView performWithoutAnimation:^{
            ws.xButton.frame = CGRectMake(0, frame.origin.y + frame.size.height - keyboardHeight/4.f, tempWindow.bounds.size.width/3.f, keyboardHeight/4.f);
        }];
        
        [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[info[UIKeyboardAnimationCurveUserInfoKey] intValue] << 16 animations:^{
            ws.xButton.frame = CGRectMake(0, tempWindow.bounds.size.height - keyboardHeight/4.f, tempWindow.bounds.size.width/3.f, keyboardHeight/4.f);
        } completion:^(BOOL finished) {
            if (![self.inputView isFirstResponder]) {
                [ws.xButton removeFromSuperview];
            }
        }];
    } else {
        [ws.xButton removeFromSuperview];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([info[UIKeyboardAnimationDurationUserInfoKey] doubleValue] * 1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([ws.inputView isFirstResponder]) {
                ws.xButton.frame = CGRectMake(0, tempWindow.bounds.size.height - keyboardHeight/4.f, tempWindow.bounds.size.width/3.f, keyboardHeight/4.f);
                [tempWindow addSubview:ws.xButton];
            }
        });
    }
}

- (void)_keyboardWillHide:(NSNotification *)notification {
    __weak typeof(self) ws = self;
    NSDictionary *info = notification.userInfo;
    CGFloat keyboardHeight = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    if (ws.xButton.superview) {
        [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[info[UIKeyboardAnimationCurveUserInfoKey] intValue] << 16 animations:^{
            ws.xButton.frame = CGRectMake(0, ws.xButton.superview.bounds.size.height + keyboardHeight - keyboardHeight/4.f, ws.xButton.superview.bounds.size.width/3.f, keyboardHeight/4.f);
        } completion:^(BOOL finished) {
            if (finished && ![ws.inputView isFirstResponder]) {
                [ws.xButton removeFromSuperview];
            }
        }];
    }
}

- (UIButton *)xButton {
    if (_xButton == nil) {
        _xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _xButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _xButton.titleLabel.font = [UIFont boldSystemFontOfSize:20 * 375 / [UIScreen mainScreen].bounds.size.width];
        [_xButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_xButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_xButton setTitle:@"X" forState:UIControlStateNormal];
        [_xButton addTarget:self action:@selector(xButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xButton;
}

- (void)xButtonClicked {
    if ([self.inputView conformsToProtocol:@protocol(UITextInput)]) {
        id<UITextInput> inputView = self.inputView;
        [inputView replaceRange:inputView.selectedTextRange withText:@"x"];
    }
}

- (void)dealloc {
    [_xButton removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSUInteger)maxTextLength {
    return 18;
}

- (NSInteger)handleText:(inout NSString *__autoreleasing *)text cursorIndex:(NSInteger)cursorIndex {
    NSInteger returnIndex = cursorIndex;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9xX]*$"];
    NSMutableString *string = [@"" mutableCopy];
    for (int i = 0; i < [*text length]; i++) {
        NSString *charater = [*text substringWithRange:NSMakeRange(i, 1)];
        if ([predicate evaluateWithObject:charater]) {
            if ([charater isEqualToString:@"X"]) charater = @"x";
            [string appendString:charater];
        } else if (i < cursorIndex) {
            returnIndex--;
        }
    }
    *text = [string copy];
    return returnIndex;
}

@end
