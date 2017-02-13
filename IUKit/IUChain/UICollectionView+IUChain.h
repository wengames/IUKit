//
//  UICollectionView+IUChain.h
//  IUChain
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+IUChain.h"

#define IUChainMethod_UICollectionView(returnClass) \
\
IUChainMethod_UIScrollView(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setCollectionViewLayout)(UICollectionViewLayout *); \
@property (nonatomic, readonly) returnClass *(^setDataSource)(id<UICollectionViewDataSource>); \
@property (nonatomic, readonly) returnClass *(^setDelegate)(id<UICollectionViewDelegate>); \
@property (nonatomic, readonly) returnClass *(^setPrefetchDataSource)(id<UICollectionViewDataSourcePrefetching>); \
@property (nonatomic, readonly) returnClass *(^setPrefetchingEnabled)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setBackgroundView)(UIView *); \
@property (nonatomic, readonly) returnClass *(^setAllowsSelection)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setAllowsMultipleSelection)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setVisibleCells)(NSArray<__kindof UICollectionViewCell *> *); \
@property (nonatomic, readonly) returnClass *(^setIndexPathsForVisibleItems)(NSArray<NSIndexPath *> *); \
@property (nonatomic, readonly) returnClass *(^setRemembersLastFocusedIndexPath)(BOOL); \

@interface UICollectionView (IUChain)

@IUChainMethod_UICollectionView(UICollectionView)

@end
