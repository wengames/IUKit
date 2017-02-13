//
//  UIViewController+IUSubviews.h
//  IUController
//
//  Created by admin on 2017/2/10.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (IUSubviews)

// a scroll view fits view size, lazy loading
@property (nonatomic, strong, readonly) UIScrollView     *scrollView;

// configure tableViewSytle for tableView below, default is UITableViewStylePlain, call before -tableView invoked
@property (nonatomic, assign)           UITableViewStyle  tableViewSytle;
// a table view fits view size, lazy loading
@property (nonatomic, strong, readonly) UITableView      *tableView;

// configure layout for collectionView below, default is UICollectionViewFlowLayout with all 0 edges, call before -collectionView invoked
@property (nonatomic, strong)     UICollectionViewLayout *collectionViewLayout;
// a collection view fits view size, lazy loading
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

@end

@interface UIButton (IUEnableExclusiveTouch)

@property(nonatomic,getter=isExclusiveTouch) BOOL exclusiveTouch __TVOS_PROHIBITED; // default is YES

@end
