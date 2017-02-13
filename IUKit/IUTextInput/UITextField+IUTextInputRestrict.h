//
//  UITextField+IUTextInputRestrict.h
//  IUTextInput
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IUTextInputRestrict.h"

@interface UITextField (IUTextInputRestrict)

@property (nonatomic, strong) IUTextInputRestrict *textInputRestrict;
@property (nonatomic, assign) NSUInteger           maxTextLength;     // default is NSUIntegerMax

@property (nonatomic, readonly) NSString *phone; // get phone while textInputRestrict is set to IUTextInputRestrictPhone

@end

/* implements by IUChain */
@interface UITextField (IUChainExtendIUTextInputRestrict)

@property (nonatomic, readonly) UITextField *(^setTextInputRestrict)(IUTextInputRestrict *);
@property (nonatomic, readonly) UITextField *(^setMaxTextLength)(NSUInteger);

@end
