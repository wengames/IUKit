//
//  UITextField+IUTextInputRestrict.m
//  IUTextInput
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UITextField+IUTextInputRestrict.h"
#import <objc/runtime.h>
#import "IUMethodSwizzling.h"

static char TAG_TEXT_FIELD_TEXT_INPUT_RESTRICT;
static char TAG_TEXT_FIELD_MAX_TEXT_LENGTH;
static char TAG_TEXT_FIELD_MAX_CHARACTER_LENGTH;

@interface IUTextInputRestrict ()

@property (nonatomic, assign) NSUInteger maxTextLength;
@property (nonatomic, assign) NSUInteger maxCharacterLength;
- (void)_textDidChange:(id<UITextInput>)textInput;

@end

@implementation UITextField (IUTextInputRestrict)

+ (void)load {
    [self swizzleInstanceSelector:@selector(setText:) toSelector:@selector(iuTextInputRestrict_UITextField_setText:)];
}

- (void)iuTextInputRestrict_UITextField_setText:(NSString *)text {
    [self iuTextInputRestrict_UITextField_setText:text];
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self];
}

#pragma mark - Getter & Setter
- (void)setTextInputRestrict:(IUTextInputRestrict *)textInputRestrict {
    IUTextInputRestrict *textInputRestrictBefore = objc_getAssociatedObject(self, &TAG_TEXT_FIELD_TEXT_INPUT_RESTRICT);
    if (textInputRestrictBefore) {
        [self removeTarget:textInputRestrictBefore action:@selector(_textDidChange:) forControlEvents:UIControlEventAllEditingEvents];
    }
    objc_setAssociatedObject(self, &TAG_TEXT_FIELD_TEXT_INPUT_RESTRICT, textInputRestrict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([textInputRestrict isKindOfClass:[IUTextInputRestrictNumberOnly class]]) {
        self.keyboardType = UIKeyboardTypeNumberPad;
    } else if ([textInputRestrict isKindOfClass:[IUTextInputRestrictDecimalNegative class]]) {
        self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    } else if ([textInputRestrict isKindOfClass:[IUTextInputRestrictDecimalOnly class]]) {
        self.keyboardType = UIKeyboardTypeDecimalPad;
    } else if ([textInputRestrict isKindOfClass:[IUTextInputRestrictIdentityCard class]]) {
        self.keyboardType = UIKeyboardTypeNumberPad;
        [(IUTextInputRestrictIdentityCard *)textInputRestrict setInputView:self];
    }
    
    textInputRestrict.maxTextLength = self.maxTextLength;
    textInputRestrict.maxCharacterLength = self.maxCharacterLength;
    
    [self addTarget:textInputRestrict action:@selector(_textDidChange:) forControlEvents:UIControlEventAllEditingEvents];
}

- (IUTextInputRestrict *)textInputRestrict {
    IUTextInputRestrict *textInputRestrict = objc_getAssociatedObject(self, &TAG_TEXT_FIELD_TEXT_INPUT_RESTRICT);
    if (textInputRestrict == nil) {
        textInputRestrict = [[IUTextInputRestrict alloc] init];
        textInputRestrict.maxTextLength = self.maxTextLength;
        textInputRestrict.maxCharacterLength = self.maxCharacterLength;
        objc_setAssociatedObject(self, &TAG_TEXT_FIELD_TEXT_INPUT_RESTRICT, textInputRestrict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addTarget:textInputRestrict action:@selector(_textDidChange:) forControlEvents:UIControlEventAllEditingEvents];
    }
    return textInputRestrict;
}

- (void)setMaxTextLength:(NSUInteger)maxTextLength {
    objc_setAssociatedObject(self, &TAG_TEXT_FIELD_MAX_TEXT_LENGTH, @(maxTextLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.textInputRestrict.maxTextLength = maxTextLength;
    [self.textInputRestrict _textDidChange:self];
}

- (NSUInteger)maxTextLength {
    NSNumber *number = objc_getAssociatedObject(self, &TAG_TEXT_FIELD_MAX_TEXT_LENGTH);
    return number ? [number unsignedIntegerValue] : NSUIntegerMax;
}

- (void)setMaxCharacterLength:(NSUInteger)maxCharacterLength {
    objc_setAssociatedObject(self, &TAG_TEXT_FIELD_MAX_CHARACTER_LENGTH, @(maxCharacterLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.textInputRestrict.maxCharacterLength = maxCharacterLength;
    [self.textInputRestrict _textDidChange:self];
}

- (NSUInteger)maxCharacterLength {
    NSNumber *number = objc_getAssociatedObject(self, &TAG_TEXT_FIELD_MAX_CHARACTER_LENGTH);
    return number ? [number unsignedIntegerValue] : NSUIntegerMax;
}

- (NSString *)phone {
    NSString *text = self.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]*$"];
    NSMutableString *string = [@"" mutableCopy];
    for (int i = 0; i < [text length]; i++) {
        NSString *charater = [text substringWithRange:NSMakeRange(i, 1)];
        if ([predicate evaluateWithObject:charater]) {
            [string appendString:charater];
        }
    }
    return [string copy];
}

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-implementation"
@implementation UITextField (IUChainExtendIUTextInputRestrict)

@end
#pragma clang diagnostic pop
