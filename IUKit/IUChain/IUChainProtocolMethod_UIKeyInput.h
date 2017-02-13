//
//  IUChainProtocolMethod_UIKeyInput.h
//  IUChain
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#ifndef IUChainProtocolMethod_UIKeyInput_h
#define IUChainProtocolMethod_UIKeyInput_h

#ifdef __OBJC__

#import "IUChainProtocolMethod_UITextInputTraits.h"

#define IUChainProtocolMethod_UIKeyInput(returnClass) \
IUChainProtocolMethod_UITextInputTraits(returnClass) \

#endif

#endif /* IUChainProtocolMethod_UIKeyInput_h */
