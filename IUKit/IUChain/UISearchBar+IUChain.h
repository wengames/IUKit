//
//  UISearchBar+IUChain.h
//  IUChain
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+IUChain.h"
#import "IUChainProtocolMethod_UITextInputTraits.h"

#define IUChainMethod_UISearchBar(returnClass) \
\
IUChainMethod_UIView(returnClass) \
\
IUChainProtocolMethod_UITextInputTraits(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setDelegate)(id<UISearchBarDelegate>); \
@property (nonatomic, readonly) returnClass *(^setText)(NSString *); \
@property (nonatomic, readonly) returnClass *(^setPrompt)(NSString *); \
@property (nonatomic, readonly) returnClass *(^setPlaceholder)(NSString *); \
@property (nonatomic, readonly) returnClass *(^setShowsBookmarkButton)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setShowsCancelButton)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setShowsSearchResultsButton)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setSearchResultsButtonSelected)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setBarTintColor)(UIColor *); \
@property (nonatomic, readonly) returnClass *(^setSearchBarStyle)(UISearchBarStyle); \
@property (nonatomic, readonly) returnClass *(^setTranslucent)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setScopeButtonTitles)(NSArray<NSString *> *); \
@property (nonatomic, readonly) returnClass *(^setSelectedScopeButtonIndex)(NSInteger); \
@property (nonatomic, readonly) returnClass *(^setShowsScopeBar)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setInputAccessoryView)(UIView *); \
@property (nonatomic, readonly) returnClass *(^setBackgroundImage)(UIImage *); \
@property (nonatomic, readonly) returnClass *(^setScopeBarBackgroundImage)(UIImage *); \
@property (nonatomic, readonly) returnClass *(^setSearchFieldBackgroundPositionAdjustment)(UIOffset); \
@property (nonatomic, readonly) returnClass *(^setSearchTextPositionAdjustment)(UIOffset); \

@interface UISearchBar (IUChain)

@IUChainMethod_UISearchBar(UISearchBar)

@end
