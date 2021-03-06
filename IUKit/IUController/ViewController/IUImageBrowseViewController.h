//
//  IUImageBrowseViewController.h
//  IUKitDemo
//
//  Created by admin on 2017/2/17.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUFadeModalViewController.h"

@class IUImageBrowseObject;
@protocol IUImageBrowseViewControllerDelegate;

@interface IUImageBrowseViewController : IUFadeModalViewController

@property (nonatomic, assign) CGFloat spacingBetweenImage; // default is 15;
@property (nonatomic) NSInteger currentIndex;

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;

- (instancetype)initWithDelegate:(id<IUImageBrowseViewControllerDelegate>)delegate;
- (instancetype)initWithObjects:(NSArray <IUImageBrowseObject *> *)objects;
- (instancetype)initWithImages:(NSArray <UIImage *> *)images;
- (instancetype)initWithUrls:(NSArray <NSString *> *)urls;

- (void)didLongPressObject:(IUImageBrowseObject *)object atIndex:(NSInteger)index; // override point, defaults do nothing
- (void)didSingleTapObject:(IUImageBrowseObject *)object atIndex:(NSInteger)index; // override point, defaults do dismiss
- (BOOL)canDismissByPanning; // override point

- (void)reloadData;
@end

@protocol IUImageBrowseViewControllerDelegate <NSObject>

@optional
- (NSInteger)numberOfImagesInImageBrowseViewController:(IUImageBrowseViewController *)imageViewController;
- (IUImageBrowseObject *)imageBrowseViewController:(IUImageBrowseViewController *)imageViewController imageBrowseObjectAtIndex:(NSInteger)index;

@end

@interface IUImageBrowseObject : NSObject

@property (nonatomic, strong) UIImage  *image;
@property (nonatomic, strong) NSString *url;

+ (instancetype)objectWithImage:(UIImage *)image url:(NSString *)url;
+ (instancetype)objectWithUrl:(NSString *)url;

@end
