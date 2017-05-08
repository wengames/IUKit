//
//  TestLabel.m
//  IUKitDemo
//
//  Created by admin on 2017/3/29.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "TestLabel.h"
#import <objc/runtime.h>

@interface UITextField (TTT)

@property (nonatomic, weak) UIResponder *nr;

@end

@interface TestLabel ()
{
    UITextField *_t;
}
@end

@implementation TestLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(t:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(t:) name:UITextFieldTextDidEndEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(t:) name:UITextFieldTextDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(t:) name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(t:) name:UITextViewTextDidEndEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(t:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)t:(NSNotification *)notification {
    _t = notification.object;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    if (_t.isFirstResponder) {
        _t.nr = self;
        return YES;
    } else {
        return [super becomeFirstResponder];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)gr {
    if (gr.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        [[UIMenuController sharedMenuController] setTargetRect:self.bounds inView:self];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return action == @selector(cut:);
}

- (void)cut:(id)sender {
    NSLog(@"%@: %@", @"cut", sender);
}

@end

@implementation UITextField (TTT)

- (void)setNr:(UIResponder *)nr {
    objc_setAssociatedObject(self, _cmd, nr, OBJC_ASSOCIATION_ASSIGN);
}

- (UIResponder *)nr {
    return objc_getAssociatedObject(self, @selector(setNr:));
}

- (UIResponder *)nextResponder {
    return self.nr ?: [super nextResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.nr) {
        return [self.nr canPerformAction:action withSender:sender];
    }
    return [super canPerformAction:action withSender:sender];
}

- (void)cut:(id)sender {
    if ([self.nr respondsToSelector:@selector(cut:)]) {
        [self.nr cut:sender];
        return;
    }
    NSLog(@"%@: %@", @"cut2", sender);
}

@end
