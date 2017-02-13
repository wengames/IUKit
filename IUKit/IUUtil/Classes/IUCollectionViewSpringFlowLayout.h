//
//  IUCollectionViewSpringFlowLayout.h
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IUCollectionViewSpringFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, readwrite) BOOL    springEnabled;  // default is YES, turn off to disable spring animation;
@property (nonatomic, readwrite) CGFloat damping;        // default is 1, critical damping;
@property (nonatomic, readwrite) CGFloat frequency;      // default is 2, in Hertz;
@property (nonatomic, readwrite) CGFloat resistance;     // default is screen diagonal length;

@end

@protocol IUCollectionViewDelegateWaterfallLayout <NSObject>

// if the collection view delegate implementes method below
// layout will change from flow layout to waterfall layout
@optional
- (NSInteger)numberOfWaterfallInCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout;
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout widthForWaterfallAtIndex:(NSInteger)index;

@end
