//
//  IUTabPageView.h
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IUTabPageViewDelegate;

@interface IUTabPageView : UIView

@property (nonatomic, weak) id<IUTabPageViewDelegate> delegate;

/*
 *  view on the tabCollectionView
 *  default is bottom line with thickness 2
 *  no effect on setting frame.origin.x or frame.size.width
 */
@property (nonatomic, strong) UIView *selectedLine;
@property (nonatomic)         CGFloat tabHeight;  // default is 49

// shows effect when implements -tabPageView:titleForTabAtIndex:
@property (nonatomic)    UIEdgeInsets tabPadding; // default is (0, 10, 0, 10)
@property (nonatomic, strong) UIFont  *tabFont;
@property (nonatomic, strong) UIColor *tabTextColor;
@property (nonatomic, strong) UIColor *tabTextColorSelected;

// do not change data source or delegate for these collection views
@property (nonatomic, strong, readonly) UICollectionView *tabCollectionView;
@property (nonatomic, strong, readonly) UICollectionView *pageCollectionView;

// setting method calls -setSelectedIndex:animated: with animated NO
@property (nonatomic) NSInteger selectedIndex;
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;

/// reload tabs only
- (void)reloadTabs;
/// reload all tabs and pages
- (void)reloadTabsAndPages;

@end

@protocol IUTabPageViewDelegate <NSObject>

@required
- (NSUInteger)numberOfTabsInTabPageView:(IUTabPageView *)tabPageView;

@optional
/// tab title
- (NSString *)tabPageView:(IUTabPageView *)tabPageView titleForTabAtIndex:(NSInteger)index;
/// tab width
- (CGFloat)tabPageView:(IUTabPageView *)tabPageView widthForTabAtIndex:(NSInteger)index;

/// custom tab add on the tab view
- (void)tabPageView:(IUTabPageView *)tabPageView willDisplayTabCustomView:(UIView *)tabCustomView atIndex:(NSInteger)index;
//  calls only when the method above is implemented
//  manage view controller when tab disappeared
- (void)tabPageView:(IUTabPageView *)tabPageView didEndDisplayingTabCustomView:(UIView *)tabCustomView atIndex:(NSInteger)index;

/// custom page add on the page view
- (void)tabPageView:(IUTabPageView *)tabPageView willDisplayPageCustomView:(UIView *)pageCustomView atIndex:(NSInteger)index;
//  calls only when the method above is implemented
//  manage view controller when page disappeared
- (void)tabPageView:(IUTabPageView *)tabPageView didEndDisplayingPageCustomView:(UIView *)pageCustomView atIndex:(NSInteger)index;

// scroll listener to tab and page
- (void)tabPageView:(IUTabPageView *)tabPageView tabDidScroll:(UICollectionView *)tabCollectionView;
- (void)tabPageView:(IUTabPageView *)tabPageView pageDidScroll:(UICollectionView *)pageCollectionView;

@end
