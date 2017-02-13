//
//  UITextField+IUChain.h
//  IUChain
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIControl+IUChain.h"
#import "IUChainProtocolMethod_UITextInput.h"
#import "IUChainProtocolMethod_UIContentSizeCategoryAdjusting.h"

#define IUChainMethod_UITextField(returnClass) \
\
IUChainMethod_UIControl(returnClass) \
\
IUChainProtocolMethod_UITextInput(returnClass) \
IUChainProtocolMethod_UIContentSizeCategoryAdjusting(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setText)(NSString *); \
@property (nonatomic, readonly) returnClass *(^setFont)(UIFont *); \
@property (nonatomic, readonly) returnClass *(^setTextColor)(UIColor *); \
@property (nonatomic, readonly) returnClass *(^setAttributedText)(NSAttributedString *); \
@property (nonatomic, readonly) returnClass *(^setTextAlignment)(NSTextAlignment); \
@property (nonatomic, readonly) returnClass *(^setDelegate)(id<UITextFieldDelegate>); \
@property (nonatomic, readonly) returnClass *(^setPlaceholder)(NSString *); \
@property (nonatomic, readonly) returnClass *(^setAttributedPlaceholder)(NSAttributedString *); \
@property (nonatomic, readonly) returnClass *(^setClearsOnBeginEditing)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setBorderStyle)(UITextBorderStyle); \
@property (nonatomic, readonly) returnClass *(^setAdjustsFontSizeToFitWidth)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setMinimumFontSize)(CGFloat); \
@property (nonatomic, readonly) returnClass *(^setBackground)(UIImage *); \
@property (nonatomic, readonly) returnClass *(^setDisabledBackground)(UIImage *); \
@property (nonatomic, readonly) returnClass *(^setAllowsEditingTextAttributes)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setTypingAttributes)(NSDictionary<NSString *, id> *); \
@property (nonatomic, readonly) returnClass *(^setClearButtonMode)(UITextFieldViewMode); \
@property (nonatomic, readonly) returnClass *(^setLeftView)(UIView *); \
@property (nonatomic, readonly) returnClass *(^setLeftViewMode)(UITextFieldViewMode); \
@property (nonatomic, readonly) returnClass *(^setRightView)(UIView *); \
@property (nonatomic, readonly) returnClass *(^setRightViewMode)(UITextFieldViewMode); \
@property (nonatomic, readonly) returnClass *(^setInputView)(UIView *); \
@property (nonatomic, readonly) returnClass *(^setInputAccessoryView)(UIView *); \
@property (nonatomic, readonly) returnClass *(^setClearsOnInsertion)(BOOL); \

@interface UITextField (IUChain)

@IUChainMethod_UITextField(UITextField)

@end
