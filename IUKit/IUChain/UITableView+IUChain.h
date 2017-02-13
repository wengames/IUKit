//
//  UITableView+IUChain.h
//  IUChain
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+IUChain.h"

#define IUChainMethod_UITableView(returnClass) \
\
IUChainMethod_UIScrollView(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setDataSource)(id<UITableViewDataSource>); \
@property (nonatomic, readonly) returnClass *(^setDelegate)(id<UITableViewDelegate>); \
@property (nonatomic, readonly) returnClass *(^setPrefetchDataSource)(id<UITableViewDataSourcePrefetching>); \
@property (nonatomic, readonly) returnClass *(^setRowHeight)(CGFloat); \
@property (nonatomic, readonly) returnClass *(^setSectionHeaderHeight)(CGFloat); \
@property (nonatomic, readonly) returnClass *(^setSectionFooterHeight)(CGFloat); \
@property (nonatomic, readonly) returnClass *(^setEstimatedRowHeight)(CGFloat); \
@property (nonatomic, readonly) returnClass *(^setEstimatedSectionHeaderHeight)(CGFloat); \
@property (nonatomic, readonly) returnClass *(^setEstimatedSectionFooterHeight)(CGFloat); \
@property (nonatomic, readonly) returnClass *(^setSeparatorInset)(UIEdgeInsets); \
@property (nonatomic, readonly) returnClass *(^setBackgroundView)(UIView *); \
@property (nonatomic, readonly) returnClass *(^setEditing)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setAllowsSelection)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setAllowsSelectionDuringEditing)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setAllowsMultipleSelection)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setAllowsMultipleSelectionDuringEditing)(BOOL); \

@interface UITableView (IUChain)

@IUChainMethod_UITableView(UITableView)

@end
