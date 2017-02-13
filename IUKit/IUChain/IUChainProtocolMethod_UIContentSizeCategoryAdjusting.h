//
//  IUChainProtocolMethod_UIContentSizeCategoryAdjusting.h
//  IUChain
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#ifndef IUChainProtocolMethod_UIContentSizeCategoryAdjusting_h
#define IUChainProtocolMethod_UIContentSizeCategoryAdjusting_h

#ifdef __OBJC__

#define IUChainProtocolMethod_UIContentSizeCategoryAdjusting(returnClass) \
@property (nonatomic, readonly) returnClass *(^setAdjustsFontForContentSizeCategory)(BOOL); \

#endif

#endif /* IUChainProtocolMethod_UIContentSizeCategoryAdjusting_h */
