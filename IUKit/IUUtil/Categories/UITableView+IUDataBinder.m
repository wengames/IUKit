//
//  UITableView+IUDataBinder.m
//  IUUtil
//
//  Created by admin on 2017/1/24.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UITableView+IUDataBinder.h"
#import "UIView+IUEmpty.h"
#import "UIResponder+IUController.h"
#import "objc/runtime.h"
#import "IUMethodSwizzling.h"

static char TAG_TABLE_VIEW_DATA_BINDER;

@interface IUTableViewDataBinder : NSObject <UITableViewDataSource,UITableViewDelegate,UIViewControllerPreviewingDelegate>
{
    BOOL _isDatasTwoOrder;
}
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *datas;

- (void)setDatas:(NSArray *)datas animated:(BOOL)animated;

@property (nonatomic, weak) id<UITableViewDataSource> dataSource;
@property (nonatomic, weak) id<IUTableViewPreviewing> delegate;

@property (nonatomic, strong) NSMutableDictionary <NSString *, UITableViewCell *> *templateCellsByIdentifiers;

@end

@interface UITableView () <UITableViewDataSource,IUTableViewPreviewing>

@property (nonatomic, strong, readonly) IUTableViewDataBinder *dataBinder;

@end

@implementation UITableView (IUDataBinder)

+ (void)load {
    if ([self instancesRespondToSelector:@selector(setLayoutMargins:)] || [self instancesRespondToSelector:@selector(setSeparatorInset:)]) {
        [self swizzleInstanceSelector:@selector(initWithFrame:style:) toSelector:@selector(iuDataBinder_UITableView_initWithFrame:style:)];
    }
    [self swizzleInstanceSelector:@selector(setDataSource:) toSelector:@selector(iuDataBinder_UITableView_setDataSource:)];
    [self swizzleInstanceSelector:@selector(setDelegate:) toSelector:@selector(iuDataBinder_UITableView_setDelegate:)];
}

- (instancetype)iuDataBinder_UITableView_initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    UITableView *obj = [self iuDataBinder_UITableView_initWithFrame:frame style:style];
    if (obj) {
        if ([obj respondsToSelector:@selector(setLayoutMargins:)]) obj.layoutMargins = UIEdgeInsetsZero;
        if ([obj respondsToSelector:@selector(setSeparatorInset:)]) obj.separatorInset = UIEdgeInsetsZero;
    }
    return obj;
}

- (void)iuDataBinder_UITableView_setDataSource:(id<UITableViewDataSource>)dataSource {
    if (objc_getAssociatedObject(self, &TAG_TABLE_VIEW_DATA_BINDER)) {
        self.dataBinder.dataSource = dataSource;
    } else {
        [self iuDataBinder_UITableView_setDataSource:dataSource];
    }
}

- (void)iuDataBinder_UITableView_setDelegate:(id<UITableViewDelegate>)delegate {
    if (objc_getAssociatedObject(self, &TAG_TABLE_VIEW_DATA_BINDER)) {
        self.dataBinder.delegate = (id<IUTableViewPreviewing>)delegate;
    } else {
        [self iuDataBinder_UITableView_setDelegate:delegate];
    }
}

- (IUTableViewDataBinder *)dataBinder {
    IUTableViewDataBinder *dataBinder = objc_getAssociatedObject(self, &TAG_TABLE_VIEW_DATA_BINDER);
    if (dataBinder == nil) {
        dataBinder = [[IUTableViewDataBinder alloc] init];
        objc_setAssociatedObject(self, &TAG_TABLE_VIEW_DATA_BINDER, dataBinder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        dataBinder.tableView = self;
        dataBinder.dataSource = self.dataSource;
        dataBinder.delegate = (id<IUTableViewPreviewing>)self.delegate;
        
        [self iuDataBinder_UITableView_setDataSource:dataBinder];
        [self iuDataBinder_UITableView_setDelegate:dataBinder];
    }
    return dataBinder;
}

- (void)setDatas:(NSArray *)datas {
    [self setDatas:datas animated:YES];
}

- (NSArray *)datas {
    return self.dataBinder.datas;
}

- (void)setDatas:(NSArray *)datas animated:(BOOL)animated {
    [self.dataBinder setDatas:datas animated:animated];
}

@end

@implementation IUTableViewDataBinder

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [self.dataSource respondsToSelector:aSelector] || [self.delegate respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.dataSource respondsToSelector:aSelector]) {
        return self.dataSource;
    } else if ([self.delegate respondsToSelector:aSelector]) {
        return self.delegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (void)setDatas:(NSArray *)datas {
    [self setDatas:datas animated:YES];
}

- (void)setDatas:(NSArray *)datas animated:(BOOL)animated {
  
    _isDatasTwoOrder = [self _cellClassWithData:[datas firstObject]] == nil && [[datas firstObject] isKindOfClass:[NSArray class]];
    
    if (!animated) {
        
        _datas = datas;
        [self.tableView reloadData];
        
    } else {
        NSUInteger oldLength = [self.tableView numberOfSections];
        NSUInteger newLength = [datas count];
        _datas = datas;
        if (oldLength == newLength) {
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newLength)] withRowAnimation:UITableViewRowAnimationFade];
            
        } else if (oldLength > newLength) {
            
            [self.tableView beginUpdates];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newLength)] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(newLength, oldLength - newLength)] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView endUpdates];

        } else {
            
            [self.tableView beginUpdates];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, oldLength)] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(oldLength, newLength - oldLength)] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView endUpdates];
            
        }
        
    }
    
    [self.tableView setEmpty:[_datas count] == 0 animated:animated];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.datas count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _isDatasTwoOrder ? [self.datas[section] count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id data = _isDatasTwoOrder ? self.datas[indexPath.section][indexPath.row] : self.datas[indexPath.section];
    
    Class cellClass = [self cellClassWithData:data];
    
    UITableViewCell <IUTableViewCellModelSettable> *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
    if (cell == nil) {
        cell = [cellClass alloc];
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(cellClass)];
        
        UIViewController *viewController = self.tableView.viewController;
        if ([viewController respondsToSelector:@selector(traitCollection)] &&
            [viewController.traitCollection respondsToSelector:@selector(forceTouchCapability)] &&
            viewController.traitCollection.forceTouchCapability != UIForceTouchCapabilityUnavailable) {
            [viewController registerForPreviewingWithDelegate:self sourceView:cell];
        }
    }
    
    if ([cell respondsToSelector:@selector(setModel:)]) cell.model = data;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:_cmd]) {
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    id data = _isDatasTwoOrder ? self.datas[indexPath.section][indexPath.row] : self.datas[indexPath.section];
    return [self cellHeightWithData:data inTableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if ([self.delegate respondsToSelector:@selector(tableView:viewControllerToPreviewAtIndexPath:)]) {
            UIViewController *viewController = [self.delegate tableView:self.tableView viewControllerToPreviewAtIndexPath:indexPath];
            if (viewController) {
                [self.tableView.viewController.navigationController pushViewController:viewController animated:YES];
            }
        }
    }
}

#pragma mark UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    if ([self.delegate respondsToSelector:@selector(tableView:viewControllerToPreviewAtIndexPath:)]) {
        UIViewController *viewController = [self.delegate tableView:self.tableView viewControllerToPreviewAtIndexPath:[self.tableView indexPathForCell:(UITableViewCell *)previewingContext.sourceView]];
        if (viewController) {
            @try { [viewController setValue:nil forKey:@"dismissButtonItem"]; } @catch (NSException *exception) {}
            return [[UINavigationController alloc] initWithRootViewController:viewController];
        }
    }
    return nil;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    while ([viewControllerToCommit isKindOfClass:[UINavigationController class]]) {
        viewControllerToCommit = [(UINavigationController *)viewControllerToCommit topViewController];
    }
    [self.tableView.viewController.navigationController pushViewController:viewControllerToCommit animated:NO];
}

#pragma mark Private Method
- (NSMutableDictionary<NSString *,UITableViewCell *> *)templateCellsByIdentifiers {
    if (_templateCellsByIdentifiers == nil) {
        _templateCellsByIdentifiers = [@{} mutableCopy];
    }
    return _templateCellsByIdentifiers;
}

- (Class)cellClassWithData:(id)data {
    Class cellClass = [self _cellClassWithData:data];
    
    NSAssert(cellClass != nil, @"cell class is NOT declared");
    
    return cellClass;
}

- (Class)_cellClassWithData:(id)data {
    Class cellClass = nil;
    if ([data respondsToSelector:@selector(cellClassName)] || [data isKindOfClass:[NSDictionary class]]) {
        @try {
            cellClass = NSClassFromString([data valueForKey:@"cellClassName"]);
        } @catch (NSException *exception) {
            cellClass = nil;
        }
    }
    for (int i = 0; cellClass == nil && i < 6; i++) {
        NSString *cellClassName = NSStringFromClass([data class]);
        if (i < 3) {
            if ([cellClassName hasSuffix:@"Model"]) {
                cellClassName = [cellClassName substringToIndex:cellClassName.length - 5];
            } else {
                continue;
            }
        }
        switch (i % 3) {
            case 0:
                cellClassName = [cellClassName stringByAppendingString:@"TableViewCell"];
                break;
            case 1:
                cellClassName = [cellClassName stringByAppendingString:@"TableCell"];
                break;
            case 2:
                cellClassName = [cellClassName stringByAppendingString:@"Cell"];
                break;
                
            default:
                break;
        }
        
        cellClass = NSClassFromString(cellClassName);
    }
        
    return cellClass;
}

- (CGFloat)cellHeightWithData:(id)data inTableView:(UITableView *)tableView {
    if (data == nil) return 0;
    Class cellClass = [self cellClassWithData:data];
    UITableViewCell <IUTableViewCellModelSettable> *templateCell = (UITableViewCell <IUTableViewCellModelSettable> *)[self templateCellWithCellClass:cellClass];
    [templateCell prepareForReuse];
    if ([templateCell respondsToSelector:@selector(setModel:)]) templateCell.model = data;
    return [self heightWithCell:templateCell inTableView:tableView];
}

- (UITableViewCell *)templateCellWithCellClass:(Class)cellClass {
    NSString *templateIdentifier = [NSStringFromClass(cellClass) stringByAppendingString:@"_TEMPLATE"];
    UITableViewCell *templateCell = self.templateCellsByIdentifiers[templateIdentifier];
    if (templateCell == nil) {
        templateCell = [cellClass alloc];
        templateCell = [templateCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:templateIdentifier];
        templateCell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        self.templateCellsByIdentifiers[templateIdentifier] = templateCell;
    }
    return templateCell;
}

- (CGFloat)heightWithCell:(UITableViewCell *)cell inTableView:(UITableView *)tableView {
    CGFloat contentViewWidth = CGRectGetWidth(tableView.frame);
    
    // If a cell has accessory view or system accessory type, its content view's width is smaller
    // than cell's by some fixed values.
    if (cell.accessoryView) {
        contentViewWidth -= 16 + CGRectGetWidth(cell.accessoryView.frame);
    } else {
        static const CGFloat systemAccessoryWidths[] = {
            [UITableViewCellAccessoryNone] = 0,
            [UITableViewCellAccessoryDisclosureIndicator] = 34,
            [UITableViewCellAccessoryDetailDisclosureButton] = 68,
            [UITableViewCellAccessoryCheckmark] = 40,
            [UITableViewCellAccessoryDetailButton] = 48
        };
        contentViewWidth -= systemAccessoryWidths[cell.accessoryType];
    }
    
    // If not using auto layout, you have to override "-sizeThatFits:" to provide a fitting size by yourself.
    // This is the same height calculation passes used in iOS8 self-sizing cell's implementation.
    //
    // 1. Try "- systemLayoutSizeFittingSize:" first. (skip this step if 'fd_enforceFrameLayout' set to YES.)
    // 2. Warning once if step 1 still returns 0 when using AutoLayout
    // 3. Try "- sizeThatFits:" if step 1 returns 0
    // 4. Use a valid height or default row height (44) if not exist one
    
    CGFloat fittingHeight = 0;
    
    if (contentViewWidth > 0) {
        // Add a hard width constraint to make dynamic content views (like labels) expand vertically instead
        // of growing horizontally, in a flow-layout manner.
        NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
        [cell.contentView addConstraint:widthFenceConstraint];
        
        // Auto layout engine does its math
        fittingHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        [cell.contentView removeConstraint:widthFenceConstraint];
    }
    
    if (fittingHeight == 0) {
        fittingHeight = [cell sizeThatFits:CGSizeMake(contentViewWidth, 0)].height;
    }
    
    // Still zero height after all above.
    if (fittingHeight == 0) {
        // Use default row height.
        fittingHeight = tableView.rowHeight ?: 44;
    }
    
    // Add 1px extra space for separator line if needed, simulating default UITableViewCell.
    if (tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
        fittingHeight += 1.0 / [UIScreen mainScreen].scale;
    }
    
    return fittingHeight;
}

@end

@interface UITableViewCell (IUSeparatorSetting)

@end

@implementation UITableViewCell (IUSeparatorSetting)

+ (void)load {
    if ([self instancesRespondToSelector:@selector(setLayoutMargins:)] || [self instancesRespondToSelector:@selector(setSeparatorInset:)]) {
        [self swizzleInstanceSelector:@selector(initWithStyle:reuseIdentifier:) toSelector:@selector(iuSeparatorSetting_UITableViewCell_initWithStyle:reuseIdentifier:)];
    }
}

- (instancetype)iuSeparatorSetting_UITableViewCell_initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    UITableViewCell *obj = [self iuSeparatorSetting_UITableViewCell_initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (obj) {
        if ([obj respondsToSelector:@selector(setLayoutMargins:)]) obj.layoutMargins = UIEdgeInsetsZero;
        if ([obj respondsToSelector:@selector(setSeparatorInset:)]) obj.separatorInset = UIEdgeInsetsZero;
    }
    return obj;
}

@end
