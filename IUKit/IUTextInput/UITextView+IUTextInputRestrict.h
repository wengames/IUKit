//
//  UITextView+IUTextInputRestrict.h
//  IUTextInput
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IUTextInputRestrict.h"

@interface UITextView (IUTextInputRestrict)

@property (nonatomic, strong) IUTextInputRestrict *textInputRestrict;
@property (nonatomic, assign) NSUInteger           maxTextLength;         // default is NSUIntegerMax
@property (nonatomic, strong) NSString            *placeholder;           // extends placeholder like UITextField
@property (nonatomic, strong) NSAttributedString  *attributedPlaceholder; // extends attributedPlaceholder like UITextField

@property (nonatomic, readonly) NSString *phone; // get phone while textInputRestrict is set to IUTextInputRestrictPhone

@end

/* implements by IUChain */
@interface UITextView (IUChainExtendIUTextInputRestrict)

@property (nonatomic, readonly) UITextView *(^setTextInputRestrict)(IUTextInputRestrict *);
@property (nonatomic, readonly) UITextView *(^setMaxTextLength)(NSUInteger);
@property (nonatomic, readonly) UITextView *(^setPlaceholder)(NSString *);
@property (nonatomic, readonly) UITextView *(^setAttributedPlaceholder)(NSAttributedString *);

@end
