//
//  IUChainProtocolMethod_UITextInputTraits.h
//  IUChain
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#ifndef IUChainProtocolMethod_UITextInputTraits_h
#define IUChainProtocolMethod_UITextInputTraits_h

#ifdef __OBJC__

#define IUChainProtocolMethod_UITextInputTraits(returnClass) \
@property (nonatomic, readonly) returnClass *(^setKeyboardType)(UIKeyboardType); \
@property (nonatomic, readonly) returnClass *(^setKeyboardAppearance)(UIKeyboardAppearance); \
@property (nonatomic, readonly) returnClass *(^setReturnKeyType)(UIReturnKeyType); \
@property (nonatomic, readonly) returnClass *(^setEnablesReturnKeyAutomatically)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setSecureTextEntry)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setAutocapitalizationType)(UITextAutocapitalizationType); \
@property (nonatomic, readonly) returnClass *(^setAutocorrectionType)(UITextAutocorrectionType); \
@property (nonatomic, readonly) returnClass *(^setSpellCheckingType)(UITextSpellCheckingType); \
@property (nonatomic, readonly) returnClass *(^setTextContentType)(UITextContentType); \

#endif

#endif /* IUChainProtocolMethod_UITextInputTraits_h */
