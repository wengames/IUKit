//
//  UITableView+IUDataBinder.h
//  IUUtil
//
//  Created by admin on 2017/1/24.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IUTableViewCellClassDeclaration <NSObject>

// or implement -[valueForKey:@"cellClassName"]
// if NOT implement, it will find cell class name by transform self class name
// (append "TableViewCell", "TableCell", "Cell" and remove "Model" in tail)
@optional
- (NSString *)cellClassName; // class which conforms Protocol IUTableViewCellModelSettable

@end

@protocol IUTableViewPreviewing;

@interface UITableView (IUDataBinder)

@property (nonatomic, weak) id<IUTableViewPreviewing> delegate;

// call method below with animated YES
// one order datas in sections with row 0
// two order datas in sections and rows, type of "NSArray <NSArray <id<IUTableViewCellClassDeclaration>> *> *"
@property (nonatomic, strong) NSArray <id<IUTableViewCellClassDeclaration>> *datas;
- (void)setDatas:(NSArray *)datas animated:(BOOL)animated;

@end

@protocol IUTableViewCellModelSettable <NSObject>

@optional
- (void)setModel:(id)model;

@end

@protocol IUTableViewPreviewing <UITableViewDelegate>

@optional
// implements preview action
- (UIViewController *)tableView:(UITableView *)tableView viewControllerToPreviewAtIndexPath:(NSIndexPath *)indexPath;

@end
