//
//  UIViewController+IUSubviews.m
//  IUController
//
//  Created by admin on 2017/2/10.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IUSubviews.h"
#import <objc/runtime.h>
#import "IUMethodSwizzling.h"
#import "UIViewController+IUKeyboard.h"

static char TAG_VIEW_CONTROLLER_SCROLL_VIEW;
static char TAG_VIEW_CONTROLLER_TABLE_VIEW_STYLE;
static char TAG_VIEW_CONTROLLER_TABLE_VIEW;
static char TAG_VIEW_CONTROLLER_COLLECTION_VIEW_LAYOUT;
static char TAG_VIEW_CONTROLLER_COLLECTION_VIEW;

@interface UIViewController (_IUSubviewsDelegate) <UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation UIViewController (IUSubviews)

+ (void)load {
    [self swizzleInstanceSelector:@selector(loadView) toSelector:@selector(iuSubviews_UIViewController_loadView)];
    [self swizzleInstanceSelector:@selector(viewDidLoad) toSelector:@selector(iuSubviews_UIViewController_viewDidLoad)];
}

- (void)iuSubviews_UIViewController_loadView {
    [self iuSubviews_UIViewController_loadView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)iuSubviews_UIViewController_viewDidLoad {
    [self iuSubviews_UIViewController_viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark scrollView
- (UIScrollView *)scrollView {
    UIScrollView *scrollView = objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_SCROLL_VIEW);
    if (scrollView == nil) {
        scrollView = [[UIScrollView alloc] init];
        objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_SCROLL_VIEW, scrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = self.view.backgroundColor;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        scrollView.frame = self.view.bounds;
        [self.view addSubview:scrollView];
        self.keyboardFittingScrollView = scrollView;
    }
    return scrollView;
}

#pragma mark tableView
- (void)setTableViewSytle:(UITableViewStyle)tableViewSytle {
    if (self.tableViewSytle == tableViewSytle) return;
    NSAssert(objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_TABLE_VIEW) == nil, @"IUController error: call -setTableViewSytle: before -tableView invoked if you want to change the tableViewSytle");
    objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_TABLE_VIEW_STYLE, @(tableViewSytle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITableViewStyle)tableViewSytle {
    return [objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_TABLE_VIEW_STYLE) integerValue];
}

- (UITableView *)tableView {
    UITableView *tableView = objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_TABLE_VIEW);
    if (tableView == nil) {
        tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.tableViewSytle];
        objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_TABLE_VIEW, tableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
        tableView.sectionHeaderHeight = 0;
        tableView.sectionFooterHeight = 0;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.backgroundColor = self.view.backgroundColor;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.frame = self.view.bounds;
        [self.view addSubview:tableView];
        self.keyboardFittingScrollView = tableView;
    }
    return tableView;
}

#pragma mark collectionView
- (void)setCollectionViewLayout:(UICollectionViewLayout *)collectionViewLayout {
    if (objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_COLLECTION_VIEW_LAYOUT) == collectionViewLayout) return;
    NSAssert(objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_COLLECTION_VIEW) == nil, @"IUController error: call -setCollectionViewLayout: before -collectionView invoked if you want to change the collectionViewLayout");
    objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_COLLECTION_VIEW_LAYOUT, collectionViewLayout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UICollectionViewLayout *)collectionViewLayout {
    UICollectionViewLayout *collectionViewLayout = objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_COLLECTION_VIEW_LAYOUT);
    if (collectionViewLayout == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_COLLECTION_VIEW_LAYOUT, layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.itemSize = self.view.bounds.size;
        collectionViewLayout = layout;
    }
    return collectionViewLayout;
}

- (UICollectionView *)collectionView {
    UICollectionView *collectionView = objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_COLLECTION_VIEW);
    if (collectionView == nil) {
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
        objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_COLLECTION_VIEW, collectionView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = self.view.backgroundColor;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        collectionView.frame = self.view.bounds;
        [self.view addSubview:collectionView];
        self.keyboardFittingScrollView = collectionView;
    }
    return collectionView;
}

@end

@implementation UIViewController (_IUSubviewsDelegate)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end

@implementation UIButton (IUEnableExclusiveTouch)

@dynamic exclusiveTouch;

+ (void)load {
    [self swizzleInstanceSelector:@selector(initWithFrame:) toSelector:@selector(iuEnableExclusiveTouch_UIButton_initWithFrame:)];
}

- (instancetype)iuEnableExclusiveTouch_UIButton_initWithFrame:(CGRect)frame {
    UIButton *button = [self iuEnableExclusiveTouch_UIButton_initWithFrame:frame];
    if (button) {
        button.exclusiveTouch = YES;
    }
    return button;
}

@end
