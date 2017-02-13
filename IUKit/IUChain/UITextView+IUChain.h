//
//  UITextView+IUChain.h
//  IUChain
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+IUChain.h"
#import "IUChainProtocolMethod_UITextInput.h"
#import "IUChainProtocolMethod_UIContentSizeCategoryAdjusting.h"

#define IUChainMethod_UITextView(returnClass) \
\
IUChainMethod_UIScrollView(returnClass) \
\
IUChainProtocolMethod_UITextInput(returnClass) \
IUChainProtocolMethod_UIContentSizeCategoryAdjusting(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setDelegate)(id<UITextViewDelegate>); \
@property (nonatomic, readonly) returnClass *(^setText)(NSString *); \
@property (nonatomic, readonly) returnClass *(^setFont)(UIFont *); \
@property (nonatomic, readonly) returnClass *(^setTextColor)(UIColor *); \
@property (nonatomic, readonly) returnClass *(^setTextAlignment)(NSTextAlignment); \
@property (nonatomic, readonly) returnClass *(^setSelectedRange)(NSRange); \
@property (nonatomic, readonly) returnClass *(^setEditable)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setSelectable)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setDataDetectorTypes)(UIDataDetectorTypes); \
@property (nonatomic, readonly) returnClass *(^setAttributedText)(NSAttributedString *); \
@property (nonatomic, readonly) returnClass *(^setTypingAttributes)(NSDictionary<NSString *, id> *); \
@property (nonatomic, readonly) returnClass *(^setInputView)(UIView *); \
@property (nonatomic, readonly) returnClass *(^setInputAccessoryView)(UIView *); \
@property (nonatomic, readonly) returnClass *(^setTextContainer)(NSTextContainer *); \
@property (nonatomic, readonly) returnClass *(^setTextContainerInset)(UIEdgeInsets); \
@property (nonatomic, readonly) returnClass *(^setLayoutManager)(NSLayoutManager *); \
@property (nonatomic, readonly) returnClass *(^setTextStorage)(NSTextStorage *); \
@property (nonatomic, readonly) returnClass *(^setLinkTextAttributes)(NSDictionary<NSString *, id> *); \

@interface UITextView (IUChain)

@IUChainMethod_UITextView(UITextView)

@end
