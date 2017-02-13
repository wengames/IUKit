//
//  IUTabPageView.m
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUTabPageView.h"

#define kCellIdentifier @"_IUTabPageViewCellIdentifier"

@interface _IUTabPageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIView *customView;

@end

@implementation _IUTabPageCollectionViewCell

@synthesize customView = _customView;

- (UIView *)customView {
    if (_customView == nil) {
        _customView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        _customView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _customView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_customView];
    }
    return _customView;
}

@end

@interface _IUTabTextCollectionViewCell : _IUTabPageCollectionViewCell

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong, readonly) UILabel *normalLabel;
@property (nonatomic, strong, readonly) UILabel *selectedLabel;
@property (nonatomic, strong, readonly) UIView  *normalMask;
@property (nonatomic, strong, readonly) UIView  *selectedMask;

- (void)updateSelectedWithSelectedLine:(UIView *)selectedLine;

@end

@implementation _IUTabTextCollectionViewCell

@synthesize normalLabel = _normalLabel, selectedLabel = _selectedLabel, normalMask = _normalMask, selectedMask = _selectedMask;

- (void)setText:(NSString *)text {
    _text = text;
    self.normalLabel.text = text;
    self.selectedLabel.text = text;
}

- (UILabel *)normalLabel {
    if (_normalLabel == nil) {
        _normalLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _normalLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _normalLabel.textAlignment = NSTextAlignmentCenter;
        _selectedLabel.layer.mask = self.normalMask.layer;
        [self.contentView addSubview:_normalLabel];
        if (_selectedLabel) [self.contentView bringSubviewToFront:_selectedLabel];
    }
    return _normalLabel;
}

- (UILabel *)selectedLabel {
    if (_selectedLabel == nil) {
        _selectedLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _selectedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _selectedLabel.textAlignment = NSTextAlignmentCenter;
        _selectedLabel.layer.mask = self.selectedMask.layer;
        [self.contentView addSubview:_selectedLabel];
    }
    return _selectedLabel;
}

- (UIView *)normalMask {
    if (_normalMask == nil) {
        _normalMask = [[UIView alloc] init];
        _normalMask.backgroundColor = [UIColor blackColor];
    }
    return _normalMask;
}

- (UIView *)selectedMask {
    if (_selectedMask == nil) {
        _selectedMask = [[UIView alloc] init];
        _selectedMask.backgroundColor = [UIColor blackColor];
    }
    return _selectedMask;
}

- (void)updateSelectedWithSelectedLine:(UIView *)selectedLine {
    CGRect frame = [self.selectedLabel convertRect:selectedLine.frame fromView:selectedLine.superview];
    frame.origin.y = 0;
    frame.size.height = _selectedLabel.bounds.size.height;
    self.selectedMask.frame = frame;
    
    if (frame.origin.x < 0) {
        frame.origin.x += frame.size.width;
        frame.origin.x = MAX(frame.origin.x, 0);
    } else if (frame.origin.x + frame.size.width > self.normalLabel.bounds.size.width) {
        frame.origin.x -= frame.size.width;
        frame.origin.x = MIN(frame.origin.x, 0);
    } else {
        frame = CGRectZero;
    }
    self.normalMask.frame = frame;
}

@end

#pragma mark -

@interface IUTabPageView () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    BOOL _dataLoaded;
}
@end

@implementation IUTabPageView

@synthesize tabCollectionView = _tabCollectionView, pageCollectionView = _pageCollectionView, selectedLine = _selectedLine;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _dataLoaded = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.tabHeight = 49;
        self.tabPadding = UIEdgeInsetsMake(0, 10, 0, 10);
        self.tabFont = [UIFont systemFontOfSize:16];
        self.tabTextColor = [UIColor colorWithWhite:102/255.f alpha:1];
        self.tabTextColorSelected = [UIColor redColor];
        [self.tabCollectionView registerClass:[_IUTabTextCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
        [self.pageCollectionView registerClass:[_IUTabPageCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
        
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        [self.tabCollectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == _selectedLine && [keyPath isEqualToString:@"frame"]) {
        for (_IUTabTextCollectionViewCell *cell in [_tabCollectionView visibleCells]) {
            if (![cell isKindOfClass:[_IUTabTextCollectionViewCell class]]) break;
            [cell updateSelectedWithSelectedLine:_selectedLine];
        }
    } else if (object == self && [keyPath isEqualToString:@"frame"]) {
        [self reloadTabsAndPages];
    } else if (object == self.tabCollectionView && [keyPath isEqualToString:@"contentSize"]) {
        _dataLoaded = YES;
        [self.tabCollectionView removeObserver:self forKeyPath:@"contentSize"];
        [self scrollViewDidScroll:self.pageCollectionView]; // 加载selectedLine位置
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    if (!_dataLoaded) [_tabCollectionView removeObserver:self forKeyPath:@"contentSize"];
    [self removeObserver:self forKeyPath:@"frame"];
    [_selectedLine removeObserver:self forKeyPath:@"frame"];
}

- (void)reloadTabs {
    [self.tabCollectionView reloadData];
    [self performSelector:@selector(reselect) withObject:nil afterDelay:0];
}

- (void)reloadTabsAndPages {
    [self.tabCollectionView reloadData];
    [self.pageCollectionView reloadData];
    [self performSelector:@selector(reselect) withObject:nil afterDelay:0];
}

- (void)reselect {
    self.selectedIndex = self.selectedIndex;
}

- (void)setTabPadding:(UIEdgeInsets)tabPadding {
    _tabPadding = tabPadding;
    [_tabCollectionView reloadData];
}

- (void)setTabHeight:(CGFloat)tabHeight {
    _tabHeight = tabHeight;
    _tabCollectionView.frame = CGRectMake(0, 0, self.bounds.size.width, _tabHeight);
    _pageCollectionView.frame = CGRectMake(0, _tabHeight, self.bounds.size.width, self.bounds.size.height - _tabHeight);
}

- (void)setTabFont:(UIFont *)tabFont {
    _tabFont = tabFont;
    [_tabCollectionView reloadData];
}

- (void)setTabTextColor:(UIColor *)tabTextColor {
    _tabTextColor = tabTextColor;
    [_tabCollectionView reloadData];
}

- (void)setTabTextColorSelected:(UIColor *)tabTextColorSelected {
    _tabTextColorSelected = tabTextColorSelected;
    [_tabCollectionView reloadData];
}

- (UICollectionView *)tabCollectionView {
    if (_tabCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _tabCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, _tabHeight) collectionViewLayout:layout];
        _tabCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
        [_tabCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _tabCollectionView.backgroundColor = [UIColor clearColor];
        _tabCollectionView.showsHorizontalScrollIndicator = NO;
        _tabCollectionView.showsVerticalScrollIndicator = NO;
        _tabCollectionView.dataSource = self;
        _tabCollectionView.delegate = self;
        [self addSubview:_tabCollectionView];
    }
    return _tabCollectionView;
}

- (UICollectionView *)pageCollectionView {
    if (_pageCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _pageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _tabHeight, self.bounds.size.width, self.bounds.size.height - _tabHeight) collectionViewLayout:layout];
        _pageCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_pageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _pageCollectionView.backgroundColor = [UIColor clearColor];
        _pageCollectionView.showsHorizontalScrollIndicator = NO;
        _pageCollectionView.showsVerticalScrollIndicator = NO;
        _pageCollectionView.pagingEnabled = YES;
        _pageCollectionView.allowsSelection = NO;
        _pageCollectionView.dataSource = self;
        _pageCollectionView.delegate = self;
        [self addSubview:_pageCollectionView];
    }
    return _pageCollectionView;
}

- (UIView *)selectedLine {
    if (_selectedLine == nil) {
        _selectedLine = [[UIView alloc] init];
        _selectedLine.backgroundColor = [UIColor redColor];
        _selectedLine.frame = CGRectMake(0, self.tabCollectionView.bounds.size.height - 2, 0, 2);
        _selectedLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [_selectedLine addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        [self.tabCollectionView addSubview:_selectedLine];
    }
    return _selectedLine;
}

- (void)setSelectedLine:(UIView *)selectedLine {
    if (_selectedLine) {
        [_selectedLine removeFromSuperview];
        _selectedLine = nil;
    }
    
    if (selectedLine) {
        _selectedLine = selectedLine;
        [self.tabCollectionView insertSubview:_selectedLine atIndex:0];
        if (_dataLoaded) [self scrollViewDidScroll:self.pageCollectionView];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    NSInteger count = [self.tabCollectionView numberOfItemsInSection:0];
    if (selectedIndex < 0) {
        selectedIndex = 0;
    }
    if (selectedIndex < count) {
        _selectedIndex = selectedIndex;
    } else if (count > 0) {
        _selectedIndex = count - 1;
    } else {
        return;
    }
    [self.tabCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self.pageCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    for (_IUTabTextCollectionViewCell *cell in [_tabCollectionView visibleCells]) {
        [cell updateSelectedWithSelectedLine:_selectedLine];
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(numberOfTabsInTabPageView:)]) {
        return [self.delegate numberOfTabsInTabPageView:self];
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _tabCollectionView) {
        if ([self.delegate respondsToSelector:@selector(tabPageView:widthForTabAtIndex:)]) {
            return CGSizeMake([self.delegate tabPageView:self widthForTabAtIndex:indexPath.item], _tabCollectionView.bounds.size.height);
        } else if ([self.delegate respondsToSelector:@selector(tabPageView:titleForTabAtIndex:)]) {
            return CGSizeMake([[self.delegate tabPageView:self titleForTabAtIndex:indexPath.item] boundingRectWithSize:CGSizeMake(0, _tabCollectionView.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.tabFont} context:nil].size.width + self.tabPadding.left + self.tabPadding.right + 1, _tabCollectionView.bounds.size.height);
        }
    } else if (collectionView == _pageCollectionView) {
        return _pageCollectionView.bounds.size;
    }
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectedLine.superview sendSubviewToBack:self.selectedLine]; // 置底selectedLine
    _IUTabPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (collectionView == _tabCollectionView) {
        if ([self.delegate respondsToSelector:@selector(tabPageView:titleForTabAtIndex:)]) {
            _IUTabTextCollectionViewCell *textCell = (_IUTabTextCollectionViewCell *)cell;
            textCell.normalLabel.font = self.tabFont;
            textCell.selectedLabel.font = self.tabFont;
            textCell.normalLabel.textColor = self.tabTextColor;
            textCell.selectedLabel.textColor = self.tabTextColorSelected;
            textCell.normalLabel.frame = CGRectMake(self.tabPadding.left, self.tabPadding.top, cell.contentView.bounds.size.width - self.tabPadding.left - self.tabPadding.right, cell.contentView.bounds.size.height - self.tabPadding.top - self.tabPadding.bottom);
            textCell.selectedLabel.frame = textCell.normalLabel.frame;
            textCell.text = [self.delegate tabPageView:self titleForTabAtIndex:indexPath.item];
            [textCell updateSelectedWithSelectedLine:self.selectedLine];
        }
        if ([self.delegate respondsToSelector:@selector(tabPageView:willDisplayTabCustomView:atIndex:)]) {
            [self.delegate tabPageView:self willDisplayTabCustomView:cell.customView atIndex:indexPath.item];
        }
    } else if (collectionView == _pageCollectionView && [self.delegate respondsToSelector:@selector(tabPageView:willDisplayPageCustomView:atIndex:)]) {
        [self.delegate tabPageView:self willDisplayPageCustomView:cell.customView atIndex:indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {
    [self.selectedLine.superview sendSubviewToBack:self.selectedLine]; // 置底selectedLine
    if (collectionView == _tabCollectionView) {
        if ([self.delegate respondsToSelector:@selector(tabPageView:titleForTabAtIndex:)]) {
            _IUTabTextCollectionViewCell *textCell = (_IUTabTextCollectionViewCell *)cell;
            textCell.normalLabel.font = self.tabFont;
            textCell.selectedLabel.font = self.tabFont;
            textCell.normalLabel.textColor = self.tabTextColor;
            textCell.selectedLabel.textColor = self.tabTextColorSelected;
            textCell.normalLabel.frame = CGRectMake(self.tabPadding.left, self.tabPadding.top, cell.contentView.bounds.size.width - self.tabPadding.left - self.tabPadding.right, cell.contentView.bounds.size.height - self.tabPadding.top - self.tabPadding.bottom);
            textCell.selectedLabel.frame = textCell.normalLabel.frame;
            textCell.text = [self.delegate tabPageView:self titleForTabAtIndex:indexPath.item];
            [textCell updateSelectedWithSelectedLine:self.selectedLine];
        }
        if ([self.delegate respondsToSelector:@selector(tabPageView:willDisplayTabCustomView:atIndex:)]) {
            [self.delegate tabPageView:self willDisplayTabCustomView:[(_IUTabPageCollectionViewCell *)cell customView] atIndex:indexPath.item];
        }
    } else if (collectionView == _pageCollectionView && [self.delegate respondsToSelector:@selector(tabPageView:willDisplayPageCustomView:atIndex:)]) {
        [self.delegate tabPageView:self willDisplayPageCustomView:[(_IUTabPageCollectionViewCell *)cell customView] atIndex:indexPath.item];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _tabCollectionView
        && [self.delegate respondsToSelector:@selector(tabPageView:willDisplayTabCustomView:atIndex:)]
        && [self.delegate respondsToSelector:@selector(tabPageView:didEndDisplayingTabCustomView:atIndex:)]) {
        
        [self.delegate tabPageView:self didEndDisplayingTabCustomView:[(_IUTabPageCollectionViewCell *)cell customView] atIndex:indexPath.item];
        
    } else if (collectionView == _pageCollectionView
               && [self.delegate respondsToSelector:@selector(tabPageView:willDisplayPageCustomView:atIndex:)]
               && [self.delegate respondsToSelector:@selector(tabPageView:didEndDisplayingPageCustomView:atIndex:)]) {
        
        [self.delegate tabPageView:self didEndDisplayingPageCustomView:[(_IUTabPageCollectionViewCell *)cell customView] atIndex:indexPath.item];
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setSelectedIndex:indexPath.item animated:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tabCollectionView) {
        if ([self.delegate respondsToSelector:@selector(tabPageView:tabDidScroll:)]) {
            [self.delegate tabPageView:self tabDidScroll:_tabCollectionView];
        }
    }
    
    if (scrollView != _pageCollectionView) return;
    
    if ([self.delegate respondsToSelector:@selector(tabPageView:pageDidScroll:)]) {
        [self.delegate tabPageView:self pageDidScroll:_pageCollectionView];
    }
    
    CGFloat frameWidth = (float)self.bounds.size.width;
    CGFloat floatIndex = scrollView.contentOffset.x / frameWidth;
    NSInteger floorIndex = floor(floatIndex);
    NSInteger ceilIndex = ceil(floatIndex);
    NSInteger minIndex = 0;
    NSInteger maxIndex = [_tabCollectionView numberOfItemsInSection:0] - 1;
    
    NSInteger index = round(floatIndex);
    index = MIN(maxIndex, index);
    index = MAX(minIndex, index);
    _selectedIndex = index;
    [_tabCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    CGFloat width = 0;
    CGPoint center = CGPointZero;
    if (maxIndex >= minIndex) {
        if (floorIndex >= maxIndex) {
            UICollectionViewLayoutAttributes *attributes = [_tabCollectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:maxIndex inSection:0]];
            width = attributes.bounds.size.width - self.tabPadding.left - self.tabPadding.right;
            center = CGPointMake(attributes.center.x, self.selectedLine.center.y);
        } else if (ceilIndex <= minIndex) {
            UICollectionViewLayoutAttributes *attributes = [_tabCollectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:minIndex inSection:0]];
            width = attributes.bounds.size.width - self.tabPadding.left - self.tabPadding.right;
            center = CGPointMake(attributes.center.x, self.selectedLine.center.y);
        } else {
            UICollectionViewLayoutAttributes *attributes1 = [_tabCollectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:floorIndex inSection:0]];
            UICollectionViewLayoutAttributes *attributes2 = [_tabCollectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:ceilIndex inSection:0]];
            
            CGFloat width1 = attributes1.bounds.size.width - self.tabPadding.left - self.tabPadding.right;
            CGFloat width2 = attributes2.bounds.size.width - self.tabPadding.left - self.tabPadding.right;
            width = width1 + (width2 - width1) * (floatIndex - floorIndex);
            CGFloat centerX1 = attributes1.center.x;
            CGFloat centerX2 = attributes2.center.x;
            center = CGPointMake(centerX1 + (centerX2 - centerX1) * (floatIndex - floorIndex), self.selectedLine.center.y);
        }
    }
    
    center.x += (self.tabPadding.left - self.tabPadding.right) / 2.f;
    CGRect frame = self.selectedLine.frame;
    frame.size.width = width;
    self.selectedLine.frame = frame;
    self.selectedLine.center = center;
    
    CGFloat offsetX = center.x - frameWidth / 2.f;
    offsetX = MIN(_tabCollectionView.contentSize.width - frameWidth, offsetX);
    offsetX = MAX(0, offsetX);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _tabCollectionView.contentOffset = CGPointMake(offsetX, 0);
    } completion:nil];
}

@end
