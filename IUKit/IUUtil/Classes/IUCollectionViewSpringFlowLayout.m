//
//  IUCollectionViewSpringFlowLayout.m
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUCollectionViewSpringFlowLayout.h"

@interface IUCollectionViewSpringFlowLayout ()
{
    BOOL    _shouldResetFlag;
    CGSize  _contentSize;
}

@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation IUCollectionViewSpringFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        _shouldResetFlag = YES;
        _springEnabled = YES;
        _damping = 1;
        _frequency = 2;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _resistance = sqrt(screenSize.width * screenSize.width + screenSize.height * screenSize.height);
    }
    return self;
}

- (UIDynamicAnimator *)animator {
    if (_animator == nil) {
        _animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    }
    return _animator;
}

#pragma mark - Spring Method
- (void)setSpringEnabled:(BOOL)springEnabled {
    _springEnabled = springEnabled;
    [self.collectionView reloadData];
}

- (void)setDamping:(CGFloat)damping {
    if (_damping == damping) return;
    
    _damping = damping;
    for (UIAttachmentBehavior *spring in self.animator.behaviors) {
        spring.damping = _damping;
    }
}

- (void)setFrequency:(CGFloat)frequency {
    if (_frequency == frequency) return;
    
    _frequency = frequency;
    for (UIAttachmentBehavior *spring in self.animator.behaviors) {
        spring.frequency = _frequency;
    }
}

#pragma mark - Override Method
- (CGSize)collectionViewContentSize {
    return _contentSize;
}

- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context {
    if (context.invalidateDataSourceCounts) _shouldResetFlag = YES;
    [super invalidateLayoutWithContext:context];
}

- (void)prepareLayout {
    [super prepareLayout];
    if (_shouldResetFlag) [self reset];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return (NSArray<UICollectionViewLayoutAttributes *> *)[self.animator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.animator layoutAttributesForCellAtIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return [self.animator layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if (self.springEnabled) {
        UIScrollView *scrollView = self.collectionView;
        CGPoint deltaOffset = CGPointMake(newBounds.origin.x - scrollView.bounds.origin.x, newBounds.origin.y - scrollView.bounds.origin.y);
        CGPoint touchLocation = [scrollView.panGestureRecognizer locationInView:scrollView];
        CGPoint pointFromTouch;
        CGFloat scrollResistance;
        for (UIAttachmentBehavior *spring in self.animator.behaviors) {
            pointFromTouch = CGPointMake(spring.anchorPoint.x - touchLocation.x, spring.anchorPoint.y - touchLocation.y);
            scrollResistance = sqrt(pointFromTouch.x * pointFromTouch.x + pointFromTouch.y * pointFromTouch.y) / self.resistance;
            scrollResistance = MIN(1, scrollResistance);
            
            UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes *)spring.items.firstObject;
            CGPoint center = item.center;
            center.x += deltaOffset.x * scrollResistance;
            center.y += deltaOffset.y * scrollResistance;
            item.center = center;
            [self.animator updateItemUsingCurrentState:item];
        }
    }
    return NO;
}

#pragma mark - Private Method
- (NSArray<UICollectionViewLayoutAttributes *> *)allItems {
    _contentSize = [super collectionViewContentSize];
    NSArray *superItems = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, _contentSize.width, _contentSize.height)];
    
    id<IUCollectionViewDelegateWaterfallLayout> delegate = (id<IUCollectionViewDelegateWaterfallLayout>)self.collectionView.delegate;
    if ([delegate respondsToSelector:@selector(numberOfWaterfallInCollectionView:layout:)] && [delegate numberOfWaterfallInCollectionView:self.collectionView layout:self] > 0) {
        NSInteger number = [delegate numberOfWaterfallInCollectionView:self.collectionView layout:self];
        
        UICollectionViewLayoutAttributes *(^findSectionHeader)(NSInteger section) = ^(NSInteger section) {
            UICollectionViewLayoutAttributes *targetAttributes = nil;
            for (UICollectionViewLayoutAttributes *attributes in superItems) {
                if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView && [attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader] && attributes.indexPath.section == section) {
                    targetAttributes = attributes;
                    break;
                }
            }
            return targetAttributes;
        };
        
        UICollectionViewLayoutAttributes *(^findSectionFooter)(NSInteger section) = ^(NSInteger section) {
            UICollectionViewLayoutAttributes *targetAttributes = nil;
            for (UICollectionViewLayoutAttributes *attributes in superItems) {
                if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView && [attributes.representedElementKind isEqualToString:UICollectionElementKindSectionFooter] && attributes.indexPath.section == section) {
                    targetAttributes = attributes;
                    break;
                }
            }
            return targetAttributes;
        };
        
        UICollectionViewLayoutAttributes *(^findCell)(NSInteger section, NSInteger item) = ^(NSInteger section, NSInteger item) {
            UICollectionViewLayoutAttributes *targetAttributes = nil;
            for (UICollectionViewLayoutAttributes *attributes in superItems) {
                if (attributes.representedElementCategory == UICollectionElementCategoryCell && attributes.indexPath.item == item && attributes.indexPath.section == section) {
                    targetAttributes = attributes;
                    break;
                }
            }
            return targetAttributes;
        };
        
        switch (self.scrollDirection) {
            case UICollectionViewScrollDirectionVertical:
            {
                NSMutableArray *heights = [NSMutableArray arrayWithCapacity:number];
                NSMutableArray *widths = [NSMutableArray arrayWithCapacity:number];
                NSMutableArray *positions = [NSMutableArray arrayWithCapacity:number];
                __block CGFloat sectionHeaderEnd = 0;
                
                CGFloat contentWidth = self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing * (number - 1);
                CGFloat totalWidth = self.sectionInset.left;
                for (int i = 0 ; i < number; i++) {
                    [heights addObject:@(sectionHeaderEnd)];
                    
                    if ([delegate respondsToSelector:@selector(collectionView:layout:widthForWaterfallAtIndex:)]) {
                        totalWidth += [delegate collectionView:self.collectionView layout:self widthForWaterfallAtIndex:i];
                    } else {
                        totalWidth += contentWidth / (float)number;
                    }
                    [widths addObject:@(totalWidth)];
                }
                
                CGFloat itemSpacing = 0;
                if (number > 1) {
                    itemSpacing = (self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right - totalWidth) / (number - 1);
                }
                [positions addObject:@(self.sectionInset.left)];
                for (int i = 0; i < number; i++) {
                    [positions addObject:@([widths[i] floatValue] + itemSpacing * (i + 1))];
                }
                
                CGRect(^putFrameAtMinHeight)(CGRect frame) = ^(CGRect frame){
                    __block NSInteger minHeight = [[heights firstObject] integerValue];
                    __block NSUInteger minIdx = 0;
                    [heights enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj integerValue] < minHeight) {
                            minHeight = [obj integerValue];
                            minIdx = idx;
                        }
                    }];
                    
                    if (minHeight != sectionHeaderEnd) minHeight += self.minimumLineSpacing;
                    
                    frame.origin.y = minHeight;
                    frame.origin.x = [positions[minIdx] integerValue];
                    CGFloat targetWidth = [positions[minIdx + 1] floatValue] - [positions[minIdx] floatValue] - itemSpacing;
                    frame.size.height = round(frame.size.height * targetWidth / frame.size.width);
                    frame.size.width = round(targetWidth);
                    
                    heights[minIdx] = @(minHeight + frame.size.height);
                    return frame;
                };
                
                CGFloat(^getMaxHeightAndIncreaseHeight)(CGFloat height) = ^(CGFloat height) {
                    __block CGFloat maxLength = [[heights firstObject] floatValue];
                    [heights enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj floatValue] > maxLength) {
                            maxLength = [obj floatValue];
                        }
                    }];
                    
                    sectionHeaderEnd = maxLength + height;
                    for (int i = 0; i < heights.count; i++) {
                        heights[i] = @(sectionHeaderEnd);
                    }
                    return maxLength;
                };
                
                UICollectionViewLayoutAttributes *attributes;
                for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
                    attributes = findSectionHeader(section);
                    if (attributes) {
                        CGRect frame = attributes.frame;
                        frame.origin.y = getMaxHeightAndIncreaseHeight(frame.size.height);
                        attributes.frame = frame;
                    }
                    
                    getMaxHeightAndIncreaseHeight(self.sectionInset.top);
                    
                    for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
                        attributes = findCell(section, item);
                        if (attributes) {
                            attributes.frame = putFrameAtMinHeight(attributes.frame);
                        }
                    }
                    
                    getMaxHeightAndIncreaseHeight(self.sectionInset.bottom);
                    
                    attributes = findSectionFooter(section);
                    if (attributes) {
                        CGRect frame = attributes.frame;
                        frame.origin.y = getMaxHeightAndIncreaseHeight(frame.size.height);
                        attributes.frame = frame;
                    }
                }
                _contentSize.height = getMaxHeightAndIncreaseHeight(0);
            }
                break;
            case UICollectionViewScrollDirectionHorizontal:
            {
                NSMutableArray *widths = [NSMutableArray arrayWithCapacity:number];
                NSMutableArray *heights = [NSMutableArray arrayWithCapacity:number];
                NSMutableArray *positions = [NSMutableArray arrayWithCapacity:number];
                __block CGFloat sectionHeaderEnd = 0;
                
                CGFloat contentHeight = self.collectionView.bounds.size.height - self.sectionInset.top - self.sectionInset.bottom - self.minimumInteritemSpacing * (number - 1);
                CGFloat totalHeight = self.sectionInset.top;
                for (int i = 0 ; i < number; i++) {
                    [widths addObject:@(sectionHeaderEnd)];
                    
                    if ([delegate respondsToSelector:@selector(collectionView:layout:widthForWaterfallAtIndex:)]) {
                        totalHeight += [delegate collectionView:self.collectionView layout:self widthForWaterfallAtIndex:i];
                    } else {
                        totalHeight += contentHeight / (float)number;
                    }
                    [heights addObject:@(totalHeight)];
                }
                
                CGFloat itemSpacing = 0;
                if (number > 1) {
                    itemSpacing = (self.collectionView.bounds.size.height - self.sectionInset.top - self.sectionInset.bottom - totalHeight) / (number - 1);
                }
                [positions addObject:@(self.sectionInset.top)];
                for (int i = 0; i < number; i++) {
                    [positions addObject:@([heights[i] floatValue] + itemSpacing * (i + 1))];
                }
                
                CGRect(^putFrameAtMinWidth)(CGRect frame) = ^(CGRect frame){
                    __block NSInteger minWidth = [[widths firstObject] integerValue];
                    __block NSUInteger minIdx = 0;
                    [widths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj integerValue] < minWidth) {
                            minWidth = [obj integerValue];
                            minIdx = idx;
                        }
                    }];
                    
                    if (minWidth != sectionHeaderEnd) minWidth += self.minimumLineSpacing;
                    
                    frame.origin.y = [positions[minIdx] integerValue];
                    frame.origin.x = minWidth;
                    CGFloat targetHeight = [positions[minIdx + 1] floatValue] - [positions[minIdx] floatValue] - itemSpacing;
                    frame.size.width = round(frame.size.width * targetHeight / frame.size.height);
                    frame.size.height = round(targetHeight);
                    
                    widths[minIdx] = @(minWidth + frame.size.width);
                    return frame;
                };
                
                CGFloat(^getMaxWidthAndIncreaseWidth)(CGFloat width) = ^(CGFloat width) {
                    __block CGFloat maxWidth = [[widths firstObject] floatValue];
                    [widths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj floatValue] > maxWidth) {
                            maxWidth = [obj floatValue];
                        }
                    }];
                    
                    sectionHeaderEnd = maxWidth + width;
                    for (int i = 0; i < widths.count; i++) {
                        widths[i] = @(sectionHeaderEnd);
                    }
                    return maxWidth;
                };
                
                UICollectionViewLayoutAttributes *attributes;
                for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
                    attributes = findSectionHeader(section);
                    if (attributes) {
                        CGRect frame = attributes.frame;
                        frame.origin.x = getMaxWidthAndIncreaseWidth(frame.size.width);
                        attributes.frame = frame;
                    }
                    
                    getMaxWidthAndIncreaseWidth(self.sectionInset.left);
                    
                    for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
                        attributes = findCell(section, item);
                        if (attributes) {
                            attributes.frame = putFrameAtMinWidth(attributes.frame);
                        }
                    }
                    
                    getMaxWidthAndIncreaseWidth(self.sectionInset.right);
                    
                    attributes = findSectionFooter(section);
                    if (attributes) {
                        CGRect frame = attributes.frame;
                        frame.origin.x = getMaxWidthAndIncreaseWidth(frame.size.width);
                        attributes.frame = frame;
                    }
                }
                _contentSize.width = getMaxWidthAndIncreaseWidth(0);
            }
                break;
                
            default:
                break;
        }
        return superItems;
    } else {
        return superItems;
    }
}

- (void)reset {
    _shouldResetFlag = NO;
    
    NSArray *items = [self allItems];
    [self.animator removeAllBehaviors];
    for (UICollectionViewLayoutAttributes *item in items) {
        UIAttachmentBehavior *spring = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:item.center];
        spring.length = 0;
        spring.damping = self.damping;
        spring.frequency = self.frequency;
        [self.animator addBehavior:spring];
    }
}

@end
