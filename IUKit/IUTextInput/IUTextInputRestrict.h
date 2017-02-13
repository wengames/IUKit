//
//  IUTextInputRestrict.h
//  IUTextInput
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IUTextInputRestrict : NSObject

@property (nonatomic, assign, readonly) NSUInteger maxTextLength; // the maxTextLength of input view, default is NSUIntegerMax

+ (instancetype)textInputRestrict;

// override point, restrict text without text max length
- (NSInteger)handleText:(inout NSString **)text cursorIndex:(NSInteger)cursorIndex;
// call method previous and restrict text max length
- (NSInteger)restrictText:(inout NSString **)text cursorIndex:(NSInteger)cursorIndex;

@end

/// pure number, [0-9]
@interface IUTextInputRestrictNumberOnly : IUTextInputRestrict

@end

/// number with separators, [0-9], max length only count the numeric character
@interface IUTextInputRestrictNumberWithFormat : IUTextInputRestrictNumberOnly

/**
 format is a string like "000-0000-0000" as example
 all numeric character in format will be replace with numeric character in the text
 text fixs format circularly until max length (max length only count the numeric character)
 character "0" in the example can replace with other numeric character
 character "-" in the example can replace with other string which not contain any numeric character
 */
@property (nonatomic, strong) NSString *format;

+ (instancetype)textInputRestrictWithFormat:(NSString *)format;

@end

/// tel number with separators, [0-9]{11}
@interface IUTextInputRestrictPhone : IUTextInputRestrictNumberWithFormat

@property (nonatomic, strong) NSString *separator; // a string which not contain any numeric character

/**
 do not invoke; not a valid initializer for this class;
 call +textInputRestrictWithSeparator: instead
 */
+ (instancetype)textInputRestrictWithFormat:(NSString *)format /*NS_UNAVAILABLE*/;
+ (instancetype)textInputRestrictWithSeparator:(NSString *)separator;

@end

// number with decimal, [0-9.]
@interface IUTextInputRestrictDecimalOnly : IUTextInputRestrict

@property (nonatomic, assign) NSUInteger decimalDigits; // restricts decimal digits length, default is NSUIntegerMax

+ (instancetype)textInputRestrictWithDecimalDigits:(NSUInteger)decimalDigits;

@end

// number with decimal, can be negative, [0-9.-]
@interface IUTextInputRestrictDecimalNegative : IUTextInputRestrictDecimalOnly

@end

// charaters without chinese, [^\u4e00-\u9fa5]
@interface IUTextInputRestrictCharaterOnly : IUTextInputRestrict

@end

// identity card, [0-9xX]
@interface IUTextInputRestrictIdentityCard : IUTextInputRestrict

@property (nonatomic, weak) id inputView;

@end
