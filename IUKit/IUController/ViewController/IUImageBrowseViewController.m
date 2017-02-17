//
//  IUImageBrowseViewController.m
//  IUKitDemo
//
//  Created by admin on 2017/2/17.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUImageBrowseViewController.h"
#import "UIImageView+WebCache.h"
#import "UINavigationController+IUFullScreenInteractivePopGestureRecognizer.h"
#import "UIViewController+IUMagicTransition.h"

@interface _IUImageBrowserCollectionViewCell : UICollectionViewCell <UIScrollViewDelegate>

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (nonatomic, strong) IUImageBrowseObject *object;

@end

@interface IUImageBrowseViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak)   id<IUImageBrowseViewControllerDelegate> browserDelegate;
@property (nonatomic, strong) NSArray <IUImageBrowseObject *> *objects;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITapGestureRecognizer *dismissGestureRecognizer;

@end

@implementation IUImageBrowseViewController

- (instancetype)initWithDelegate:(id<IUImageBrowseViewControllerDelegate>)delegate {
    if (self = [self init]) {
        self.browserDelegate = delegate;
    }
    return self;
}

- (instancetype)initWithObjects:(NSArray<IUImageBrowseObject *> *)objects {
    if (self = [self init]) {
        self.objects = objects;
    }
    return self;
}

- (instancetype)initWithImages:(NSArray<UIImage *> *)images {
    NSMutableArray *objects = [@[] mutableCopy];
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [objects addObject:[IUImageBrowseObject objectWithImage:obj url:nil]];
    }];
    return [self initWithObjects:[objects copy]];
}

- (instancetype)initWithUrls:(NSArray<NSString *> *)urls {
    NSMutableArray *objects = [@[] mutableCopy];
    [urls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [objects addObject:[IUImageBrowseObject objectWithUrl:obj]];
    }];
    return [self initWithObjects:[objects copy]];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_collectionView registerClass:[_IUImageBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self.view addSubview:_collectionView];
        [_collectionView layoutIfNeeded];
        
        [_collectionView addGestureRecognizer:self.dismissGestureRecognizer];
    }
    return _collectionView;
}

- (UITapGestureRecognizer *)dismissGestureRecognizer {
    if (_dismissGestureRecognizer == nil) {
        _dismissGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    }
    return _dismissGestureRecognizer;
}

#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self imageNumber];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _IUImageBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [self.dismissGestureRecognizer requireGestureRecognizerToFail:cell.doubleTapGestureRecognizer];
    cell.object = [self objectAtIndex:indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(_IUImageBrowserCollectionViewCell *)cell scrollView].zoomScale = 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size;
}

#pragma mark Private Method
- (NSInteger)imageNumber {
    if ([self.browserDelegate respondsToSelector:@selector(numberOfImagesInImageBrowseViewController:)]) {
        return [self.browserDelegate numberOfImagesInImageBrowseViewController:self];
    }
    return [self.objects count];
}

- (IUImageBrowseObject *)objectAtIndex:(NSInteger)index {
    if ([self.browserDelegate respondsToSelector:@selector(imageBrowseViewController:imageBrowseObjectAtIndex:)]) {
        return [self.browserDelegate imageBrowseViewController:self imageBrowseObjectAtIndex:index];
    }
    return self.objects[index];
}

- (NSArray *)magicViewsTransitionFromViewController:(UIViewController *)viewController {
    UIView *view = [(_IUImageBrowserCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]] imageView];
    return CGRectEqualToRect(CGRectZero, view.bounds) ? nil : @[view];
}

- (NSArray *)magicViewsTransitionToViewController:(UIViewController *)viewController {
    UIView *view = [(_IUImageBrowserCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]] imageView];
    return CGRectEqualToRect(CGRectZero, view.bounds) ? nil : @[view];
}

- (BOOL)enableMagicViewsLiftDropWhenTransitionToViewController:(UIViewController *)viewController {
    return NO;
}

- (BOOL)enableMagicViewsLiftDropWhenTransitionFromViewController:(UIViewController *)viewController {
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end

@implementation _IUImageBrowserCollectionViewCell

@synthesize imageView = _imageView;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.scrollView.zoomScale = 1;
    self.scrollView.maximumZoomScale = 1;
    self.imageView.image = nil;
    self.imageView.frame = CGRectZero;
}

- (void)setObject:(IUImageBrowseObject *)object {
    _object = object;
    if (object.image) {
        self.imageView.image = object.image;
        [self fitsImage];
    } else {
        __weak typeof(self) weakSelf = self;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:object.url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            object.image = image;
            if (weakSelf.object == object) [weakSelf fitsImage];
        }];
    }
}

- (void)fitsImage {
    if (self.imageView.image == nil) {
        self.imageView.frame = CGRectZero;
        return;
    }
    UIImage *image = self.imageView.image;
    CGSize  viewSize = self.scrollView.bounds.size;
    
    CGFloat width  = MAX(image.size.width, 1);
    CGFloat height = MAX(image.size.height, 1);
    CGFloat scale  = MIN(viewSize.width / width, viewSize.height / height);
    scale = MIN(scale, 1);
    width *= scale;
    height *= scale;
    self.imageView.frame = CGRectMake(
                                      MAX(0, (viewSize.width - width) / 2.f),
                                      MAX(0, (viewSize.height - height) / 2.f),
                                      width,
                                      height
                                      );
    
    self.scrollView.maximumZoomScale = 1 / scale;
}

- (void)resetImageViewFrame {
    self.imageView.frame = CGRectMake(
                                      MAX(0, (self.scrollView.frame.size.width - self.imageView.frame.size.width) / 2.f),
                                      MAX(0, (self.scrollView.frame.size.height - self.imageView.frame.size.height) / 2.f),
                                      self.imageView.frame.size.width,
                                      self.imageView.frame.size.height
                                      );

}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self.contentView addSubview:self.scrollView];
    }
    return _scrollView;
}

- (UITapGestureRecognizer *)doubleTapGestureRecognizer {
    if (_doubleTapGestureRecognizer == nil) {
        _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    }
    return _doubleTapGestureRecognizer;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor redColor];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:self.doubleTapGestureRecognizer];
        [self.scrollView addSubview:_imageView];
    }
    return _imageView;
}

#pragma mark - Zoom methods
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    if (self.scrollView.zoomScale != 1) {
        [self.scrollView setZoomScale:1 animated:YES];
    } else {
        CGRect zoomRect = [self zoomRectForScale:self.scrollView.maximumZoomScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = self.scrollView.frame.size.height / scale;
    zoomRect.size.width  = self.scrollView.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self resetImageViewFrame];
}

@end

@implementation IUImageBrowseObject

+ (instancetype)objectWithImage:(UIImage *)image url:(NSString *)url {
    IUImageBrowseObject *object = [[self alloc] init];
    object.image = image;
    object.url = url;
    return object;
}

+ (instancetype)objectWithUrl:(NSString *)url {
    return [self objectWithImage:nil url:url];
}

@end
