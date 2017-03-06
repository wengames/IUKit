//
//  IUImageBrowseViewController.m
//  IUKitDemo
//
//  Created by admin on 2017/2/17.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUImageBrowseViewController.h"
#import "IUMethodSwizzling.h"
#import "UIImageView+WebCache.h"
#import "UINavigationController+IUFullScreenInteractivePopGestureRecognizer.h"
#import "UIViewController+IUMagicTransition.h"
#import "UIViewController+IUStatusBarHidden.h"
#import "IUTransitioningDelegate.h"

#import "UIViewController+IUModalTransition.h"

@interface _IUImageBrowserCollectionViewCell : UICollectionViewCell <UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    CGAffineTransform _originTransform;
}
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (nonatomic, strong) IUImageBrowseObject *object;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, weak)   IUImageBrowseViewController *viewController;

@end

@interface IUImageBrowseViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    BOOL _shouldRotate;
}
@property (nonatomic, weak)   id<IUImageBrowseViewControllerDelegate> browserDelegate;
@property (nonatomic, strong) NSArray <IUImageBrowseObject *> *objects;

@property (nonatomic, strong) UITapGestureRecognizer *dismissGestureRecognizer;

@end

@implementation IUImageBrowseViewController

@synthesize collectionView = _collectionView, pageControl = _pageControl;

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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _spacingBetweenImage = 15;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.collectionView.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _shouldRotate = YES;
    self.collectionView.alpha = 1;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    } completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)setSpacingBetweenImage:(CGFloat)spacingBetweenImage {
    _spacingBetweenImage = spacingBetweenImage;
    self.collectionView.frame = CGRectMake(-spacingBetweenImage / 2.f, 0, self.view.bounds.size.width + spacingBetweenImage, self.view.bounds.size.height);
    [self reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    self.pageControl.currentPage = currentIndex;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (NSInteger)currentIndex {
    return self.pageControl.currentPage;
}

- (void)_didLongPressCell:(_IUImageBrowserCollectionViewCell *)cell {
    [self didLongPressObject:cell.object atIndex:[self.collectionView indexPathForCell:cell].item];
}

- (void)didLongPressObject:(IUImageBrowseObject *)object atIndex:(NSInteger)index {
    
}

- (void)reloadData {
    self.pageControl.numberOfPages = [self imageNumber];
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.frame = CGRectMake(-_spacingBetweenImage / 2.f, 0, self.view.bounds.size.width + _spacingBetweenImage, self.view.bounds.size.height);
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_collectionView registerClass:[_IUImageBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self.view insertSubview:_collectionView belowSubview:self.pageControl];
        [_collectionView layoutIfNeeded];
        
        [_collectionView addGestureRecognizer:self.dismissGestureRecognizer];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 20)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.5];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.numberOfPages = [self imageNumber];
        [self.view addSubview:_pageControl];
    }
    return _pageControl;
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
    cell.spacing = self.spacingBetweenImage;
    [self.dismissGestureRecognizer requireGestureRecognizerToFail:cell.doubleTapGestureRecognizer];
    cell.object = [self objectAtIndex:indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(_IUImageBrowserCollectionViewCell *)cell scrollView].zoomScale = 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.bounds.size;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[self.collectionView convertPoint:self.collectionView.center fromView:self.collectionView.superview]];
    if (indexPath) {
        self.pageControl.currentPage = indexPath.item;
    } else if (scrollView.contentOffset.x < 0) {
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = self.pageControl.numberOfPages - 1;
    }
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

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return _shouldRotate;
}

- (BOOL)prefersStatusBarHidden {
    return _shouldRotate || [super prefersStatusBarHidden];
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

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.zoomScale = 1;
    self.scrollView.contentSize = self.scrollView.bounds.size;
    [self fitsImage];
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
    
    self.scrollView.maximumZoomScale = 2 / scale;
}

- (void)resetImageViewFrame {
    self.imageView.frame = CGRectMake(
                                      MAX(0, (self.scrollView.frame.size.width - self.imageView.frame.size.width) / 2.f),
                                      MAX(0, (self.scrollView.frame.size.height - self.imageView.frame.size.height) / 2.f),
                                      self.imageView.frame.size.width,
                                      self.imageView.frame.size.height
                                      );

}

- (void)setSpacing:(CGFloat)spacing {
    _spacing = spacing;
    self.scrollView.frame = CGRectMake(spacing / 2.f, 0, self.contentView.bounds.size.width - spacing, self.contentView.bounds.size.height);
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

- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (_panGestureRecognizer == nil) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanDismiss:)];
        _panGestureRecognizer.delegate = self;
    }
    return _panGestureRecognizer;
}

- (UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (_longPressGestureRecognizer == nil) {
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    }
    return _longPressGestureRecognizer;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:self.doubleTapGestureRecognizer];
        [_imageView addGestureRecognizer:self.panGestureRecognizer];
        [_imageView addGestureRecognizer:self.longPressGestureRecognizer];
        [self.scrollView addSubview:_imageView];
    }
    return _imageView;
}

#pragma mark - Zoom methods
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    switch (longPressGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self.viewController _didLongPressCell:self];
            break;
            
        default:
            break;
    }
}
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

- (void)handlePanDismiss:(UIPanGestureRecognizer *)panGestureRecognizer {
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            _originTransform = self.imageView.transform;
            [(IUTransitioningDelegate *)self.viewController.transitioningDelegate beginInteractiveTransition];
            [self.viewController dismiss];
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
            self.imageView.transform = CGAffineTransformTranslate(_originTransform, translation.x, translation.y);
            CGFloat percent = [panGestureRecognizer translationInView:panGestureRecognizer.view].y / self.viewController.view.bounds.size.height;
            percent = MIN(1, percent);
            percent = MAX(0, percent);
            [[(IUTransitioningDelegate *)self.viewController.transitioningDelegate interactiveTransition] updateInteractiveTransition:percent];
        }
            break;
        case UIGestureRecognizerStateEnded:
            if ([panGestureRecognizer translationInView:panGestureRecognizer.view].y > self.viewController.view.bounds.size.height / 12.f &&
                [panGestureRecognizer velocityInView:panGestureRecognizer.view].y    > 0) {
                // finish
                CGFloat duration = [(IUTransitioningDelegate *)self.viewController.transitioningDelegate interactiveTransition].duration;
                CGFloat percent = [(IUTransitioningDelegate *)self.viewController.transitioningDelegate interactiveTransition].percentComplete;
                [UIView animateWithDuration:duration*(1-percent) delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseIn animations:^{
                    self.imageView.transform = _originTransform;
                } completion:nil];
                [[(IUTransitioningDelegate *)self.viewController.transitioningDelegate interactiveTransition] finishInteractiveTransition];
                [(IUTransitioningDelegate *)self.viewController.transitioningDelegate endInteractiveTransition];
                break;
            }
            // no break here
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            // cancel
            [self animateTransitionCancel];
            break;
            
        default:
            break;
    }
}

- (void)animateTransitionCancel {
    IUTransitioningDelegate *transitioningDelegate = (IUTransitioningDelegate *)self.viewController.transitioningDelegate;
    UIPercentDrivenInteractiveTransition *interactiveTransition = transitioningDelegate.interactiveTransition;
    __block CGFloat percent = interactiveTransition.percentComplete;
    CGAffineTransform transform = CGAffineTransformConcat(self.imageView.transform, CGAffineTransformInvert(_originTransform));
    __block CGFloat tx = transform.tx;
    __block CGFloat ty = transform.ty;
    __block int number = 20;
    CGFloat dx = tx / number;
    CGFloat dy = ty / number;
    CGFloat dp = percent / number;

    __block void(^blockAnimate)(void);
    void(^animate)(void) = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            number--;
            tx -= dx;
            ty -= dy;
            percent -= dp;
            if (number == 0) {
                self.imageView.transform = _originTransform;
                [interactiveTransition updateInteractiveTransition:0];
            } else {
                self.imageView.transform = CGAffineTransformTranslate(_originTransform, tx, ty);
                [interactiveTransition updateInteractiveTransition:percent];
            }
            if (number > 0) {
                blockAnimate();
            } else {
                [interactiveTransition cancelInteractiveTransition];
                [transitioningDelegate endInteractiveTransition];
                [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveLinear animations:^{
                    self.imageView.transform = _originTransform;
                } completion:nil];
            }
        });
    };
    blockAnimate = animate;
    
    animate();
}

- (IUImageBrowseViewController *)viewController {
    if (_viewController == nil) {
        UIResponder *responder = self;
        while (responder && ![responder isKindOfClass:[IUImageBrowseViewController class]]) {
            responder = [responder nextResponder];
        }
        _viewController = (IUImageBrowseViewController *)responder;
    }
    return _viewController;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self resetImageViewFrame];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGestureRecognizer) {
        if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait) return NO;
        CGPoint velocity = [self.panGestureRecognizer velocityInView:self.panGestureRecognizer.view];
        return velocity.y > fabs(velocity.x);
    }
    return YES;
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
