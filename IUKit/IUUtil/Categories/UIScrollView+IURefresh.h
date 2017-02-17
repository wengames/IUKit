//
//  UIScrollView+IURefresh.h
//  IUKitDemo
//
//  Created by admin on 2017/2/17.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    IUScrollViewRefreshPositionTop    = 0,
    IUScrollViewRefreshPositionBottom = 1
} IUScrollViewRefreshPosition;

typedef enum {
    IUScrollViewRefreshStateNormal            = 0,
    IUScrollViewRefreshStateReleaseToRefresh  = 1,
    IUScrollViewRefreshStateRefreshing        = 2,
    IUScrollViewRefreshStateComplete          = 3
} IUScrollViewRefreshState;

typedef void(^IUScrollViewRefreshingCompletionBlock)();
typedef void(^IUScrollViewRefreshHandler)(IUScrollViewRefreshingCompletionBlock completion); //call compeltion at last

@protocol IUScrollViewRefreshLoadingViewDelegate <NSObject>

@optional

@property (nonatomic) BOOL complete;

- (void)startAnimating;
- (void)stopAnimating;

// offset is calculate from loading view border inside scrollview
// when offset is greater than or equals to threshold, means release to refresh
- (void)animateWithOffset:(CGFloat)offset;

- (void)setDisabled:(BOOL)disabled;

@end

@interface IUScrollViewRefreshView : UIView

@property (nonatomic)           BOOL    disabled;
@property (nonatomic)           CGFloat threshold;
@property (nonatomic)           BOOL    refreshImmediately;
@property (nonatomic)           IUScrollViewRefreshPosition position;
@property (nonatomic, strong)   IUScrollViewRefreshHandler  handler;
@property (nonatomic, readonly) IUScrollViewRefreshState    state;

// set loading view will auto change threshold to be it's height
@property (nonatomic, strong)   UIView <IUScrollViewRefreshLoadingViewDelegate> *loadingView;

+ (instancetype)refreshViewWithPosition:(IUScrollViewRefreshPosition)position handler:(IUScrollViewRefreshHandler)handler;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

// 上拉下拉刷新列表
@interface UIScrollView (IURefresh)

- (void)setRefreshHandler:(IUScrollViewRefreshHandler)handler;
- (void)setRefreshHandler:(IUScrollViewRefreshHandler)handler forPosition:(IUScrollViewRefreshPosition)position;
- (void)setRefreshView:(IUScrollViewRefreshView *)refreshView;
- (IUScrollViewRefreshView *)refreshViewWithPositon:(IUScrollViewRefreshPosition)position;
- (void)runRefreshHandlerForPosition:(IUScrollViewRefreshPosition)position;

@end
