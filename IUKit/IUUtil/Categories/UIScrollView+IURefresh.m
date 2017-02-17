//
//  UIScrollView+IURefresh.m
//  IUKitDemo
//
//  Created by admin on 2017/2/17.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIScrollView+IURefresh.h"
#import "objc/runtime.h"

static char TAG_TOP_REFRESH_VIEW;
static char TAG_BOTTOM_REFRESH_VIEW;

#define IUScrollViewRefreshViewObserverKeyPathContentOffset @"contentOffset"
#define IUScrollViewRefreshViewObserverKeyPathContentSize   @"contentSize"
#define IUScrollViewRefreshViewObserverKeyPathContentInset  @"contentInset"
#define IUScrollViewRefreshViewObserverKeyPathFrame         @"frame"

#define IUScrollViewRefreshViewDefaultHeight 50

#define IUScrollViewRefreshViewCompleteAnimationDuration 0.3
#define IUScrollViewRefreshViewCompleteWaitDuration      1

@interface IUScrollViewRefreshView ()

@property (nonatomic, readonly)   UIScrollView *scrollView;
@property (nonatomic)             CGFloat  inset;
@property (nonatomic)             IUScrollViewRefreshState    state;

- (void)resetFrame;

@end

@interface UIScrollView ()

@property (nonatomic) IUScrollViewRefreshView *topRefreshView;
@property (nonatomic) IUScrollViewRefreshView *bottomRefreshView;

@end

@interface _IUDefaultRefreshLoadingView : UIView <IUScrollViewRefreshLoadingViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel                 *completeLabel;

@end

@implementation _IUDefaultRefreshLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.activityIndicatorView];
    }
    return self;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (_activityIndicatorView == nil) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
        _activityIndicatorView.hidesWhenStopped = NO;
        _activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _activityIndicatorView.color = [UIColor grayColor];
    }
    return _activityIndicatorView;
}

- (UILabel *)completeLabel {
    if (_completeLabel == nil) {
        _completeLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _completeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _completeLabel.textAlignment = NSTextAlignmentCenter;
        _completeLabel.textColor = [UIColor grayColor];
        _completeLabel.font = [UIFont systemFontOfSize:14];
        _completeLabel.text = @"加载完成";
    }
    return _completeLabel;
}

#pragma mark - IURefreshLoadingViewDelegate
- (void)setComplete:(BOOL)complete {
    if (complete) {
        if (!self.completeLabel.superview) {
            self.completeLabel.alpha = 0;
            [self addSubview:self.completeLabel];
            [UIView animateWithDuration:IUScrollViewRefreshViewCompleteAnimationDuration delay:IUScrollViewRefreshViewCompleteAnimationDuration options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
                self.activityIndicatorView.alpha = 0;
                self.completeLabel.alpha = 1;
            } completion:^(BOOL finished) {
                [self.activityIndicatorView removeFromSuperview];
                self.activityIndicatorView.alpha = 1;
            }];
        }
    } else {
        if (!self.activityIndicatorView.superview) {
            self.activityIndicatorView.alpha = 0;
            [self addSubview:self.activityIndicatorView];
            [UIView animateWithDuration:IUScrollViewRefreshViewCompleteAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
                self.completeLabel.alpha = 0;
                self.activityIndicatorView.alpha = 1;
            } completion:^(BOOL finished) {
                [self.completeLabel removeFromSuperview];
                self.completeLabel.alpha = 1;
            }];
        }
    }
}

- (BOOL)complete {
    return _completeLabel.superview != nil;
}

- (void)startAnimating {
    self.complete = NO;
    [self.activityIndicatorView startAnimating];
}

- (void)stopAnimating {
    self.complete = NO;
    [self.activityIndicatorView stopAnimating];
}

- (void)animateWithOffset:(CGFloat)offset {
    if (![self.activityIndicatorView isAnimating]) {
        self.activityIndicatorView.transform = CGAffineTransformMakeRotation(M_PI / 6.f * round(offset / 10.f));
    }
}

- (void)setDisabled:(BOOL)disabled {
    self.hidden = disabled;
}

@end

@implementation UIScrollView (IURefresh)

- (void)setRefreshHandler:(IUScrollViewRefreshHandler)handler {
    [self setRefreshHandler:handler forPosition:IUScrollViewRefreshPositionTop];
}

- (void)setRefreshHandler:(IUScrollViewRefreshHandler)handler forPosition:(IUScrollViewRefreshPosition)position {
    IUScrollViewRefreshView *refreshView = [self refreshViewWithPositon:position];
    
    if (refreshView) {
        refreshView.handler = handler;
    } else {
        [self setRefreshView:[IUScrollViewRefreshView refreshViewWithPosition:position handler:handler]];
    }
}


- (void)setRefreshView:(IUScrollViewRefreshView *)refreshView {
    switch (refreshView.position) {
        case IUScrollViewRefreshPositionTop:
            self.topRefreshView = refreshView;
            break;
        case IUScrollViewRefreshPositionBottom:
            self.bottomRefreshView = refreshView;
            break;
            
        default:
            break;
    }
}

- (IUScrollViewRefreshView *)refreshViewWithPositon:(IUScrollViewRefreshPosition)position {
    IUScrollViewRefreshView *refreshView;
    switch (position) {
        case IUScrollViewRefreshPositionTop:
            refreshView = self.topRefreshView;
            break;
        case IUScrollViewRefreshPositionBottom:
            refreshView = self.bottomRefreshView;
            break;
            
        default:
            break;
    }
    return refreshView;
}

- (void)runRefreshHandlerForPosition:(IUScrollViewRefreshPosition)position {
    IUScrollViewRefreshView *refreshView = nil;
    switch (position) {
        case IUScrollViewRefreshPositionTop:
            refreshView = self.topRefreshView;
            break;
        case IUScrollViewRefreshPositionBottom:
            refreshView = self.bottomRefreshView;
            break;
            
        default:
            break;
    }
    
    if (refreshView == nil) return;
    
    refreshView.state = IUScrollViewRefreshStateRefreshing;
    
    switch (position) {
        case IUScrollViewRefreshPositionTop:
            [self setContentOffset:CGPointMake(0, -self.contentInset.top) animated:YES];
            break;
        case IUScrollViewRefreshPositionBottom:
            [self setContentOffset:CGPointMake(0, -self.contentInset.bottom) animated:YES];
            break;
            
        default:
            break;
    }
    
}

- (void)setTopRefreshView:(IUScrollViewRefreshView *)topRefreshView {
    IUScrollViewRefreshView *topRefreshViewBefore = self.topRefreshView;
    
    if (topRefreshViewBefore == topRefreshView) return;
    
    if (topRefreshViewBefore) {
        [topRefreshViewBefore removeFromSuperview];
        objc_setAssociatedObject(self, &TAG_TOP_REFRESH_VIEW, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (topRefreshView) {
        [self addSubview:topRefreshView];
        objc_setAssociatedObject(self, &TAG_TOP_REFRESH_VIEW, topRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (IUScrollViewRefreshView *)topRefreshView {
    return objc_getAssociatedObject(self, &TAG_TOP_REFRESH_VIEW);
}

- (void)setBottomRefreshView:(IUScrollViewRefreshView *)bottomRefreshView {
    IUScrollViewRefreshView *bottomRefreshViewBefore = self.bottomRefreshView;
    
    if (bottomRefreshViewBefore == bottomRefreshView) return;
    
    if (bottomRefreshViewBefore) {
        [bottomRefreshViewBefore removeFromSuperview];
        objc_setAssociatedObject(self, &TAG_BOTTOM_REFRESH_VIEW, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (bottomRefreshView) {
        [self addSubview:bottomRefreshView];
        objc_setAssociatedObject(self, &TAG_BOTTOM_REFRESH_VIEW, bottomRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (IUScrollViewRefreshView *)bottomRefreshView {
    return objc_getAssociatedObject(self, &TAG_BOTTOM_REFRESH_VIEW);
}

- (void)resetContentInset {
    UIEdgeInsets contentInset = self.contentInset;
    
    if (self.topRefreshView) {
        contentInset.top = -self.topRefreshView.frame.origin.y;
        if (self.topRefreshView.state != IUScrollViewRefreshStateRefreshing) {
            contentInset.top -= self.topRefreshView.bounds.size.height;
        }
    }
    
    if (self.bottomRefreshView) {
        contentInset.bottom = self.bottomRefreshView.frame.origin.y + self.bottomRefreshView.frame.size.height - self.contentSize.height;
        if (self.bottomRefreshView.state != IUScrollViewRefreshStateRefreshing) {
            contentInset.bottom -= self.bottomRefreshView.bounds.size.height;
        }
    }
    
    [UIView animateWithDuration:IUScrollViewRefreshViewCompleteAnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.contentInset = contentInset;
    } completion:nil];
}

@end

#pragma mark -

@implementation IUScrollViewRefreshView

@synthesize loadingView = _loadingView;

+ (instancetype)refreshViewWithPosition:(IUScrollViewRefreshPosition)position handler:(IUScrollViewRefreshHandler)handler {
    IUScrollViewRefreshView *refreshView = [[self alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, IUScrollViewRefreshViewDefaultHeight)];
    refreshView.position = position;
    refreshView.handler = handler;
    switch (position) {
        case IUScrollViewRefreshPositionTop:
            
            break;
        case IUScrollViewRefreshPositionBottom:
            refreshView.refreshImmediately = YES;
            break;
            
        default:
            break;
    }
    return refreshView;
}

- (instancetype)init {
    if (self = [super init]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.threshold = IUScrollViewRefreshViewDefaultHeight;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.threshold = self.bounds.size.height;
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    
    CGAffineTransform translation = CGAffineTransformIdentity;
    switch (_position) {
        case IUScrollViewRefreshPositionTop:
            offset = -offset - _inset;
            translation = CGAffineTransformMakeTranslation(0, MIN(0, _threshold - offset));
            break;
        case IUScrollViewRefreshPositionBottom:
            offset = offset + scrollView.bounds.size.height - self.frame.origin.y;
            translation = CGAffineTransformMakeTranslation(0, MAX(0, offset - _threshold));
            break;
            
        default:
            break;
    }
    
    self.loadingView.transform = translation;
    if ([self.loadingView respondsToSelector:@selector(animateWithOffset:)]) [self.loadingView animateWithOffset:offset];
    
    switch (_state) {
        case IUScrollViewRefreshStateNormal:
        case IUScrollViewRefreshStateReleaseToRefresh:
            if ((self.refreshImmediately && offset >= _threshold) || (!self.scrollView.isDragging && _state == IUScrollViewRefreshStateReleaseToRefresh)) {
                self.state = IUScrollViewRefreshStateRefreshing;
            } else if (self.scrollView.isDragging) {
                if (offset < _threshold) {
                    self.state = IUScrollViewRefreshStateNormal;
                } else {
                    self.state = IUScrollViewRefreshStateReleaseToRefresh;
                }
            }
            break;
        case IUScrollViewRefreshStateRefreshing:
            // do nothing
            break;
        case IUScrollViewRefreshStateComplete:
            self.state = IUScrollViewRefreshStateNormal;
            break;
            
        default:
            break;
    }
}

- (UIScrollView *)scrollView {
    if (self.superview && [self.superview isKindOfClass:[UIScrollView class]]) {
        return (UIScrollView *)self.superview;
    }
    return nil;
}

- (void)setDisabled:(BOOL)disabled {
    _disabled = disabled;
    if ([self.loadingView respondsToSelector:@selector(setDisabled:)]) {
        self.loadingView.disabled = _disabled;
    }
}

- (void)setLoadingView:(UIView<IUScrollViewRefreshLoadingViewDelegate> *)loadingView {
    if (loadingView != nil) {
        loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.frame = loadingView.bounds;
        [self resetFrame];
        self.threshold = loadingView.bounds.size.height;
    }
    
    if (_loadingView.superview) {
        [_loadingView removeFromSuperview];
    }
    
    _loadingView = loadingView;
    [self addSubview:loadingView];
}

- (UIView<IUScrollViewRefreshLoadingViewDelegate> *)loadingView {
    if (_loadingView == nil) {
        _loadingView = [[_IUDefaultRefreshLoadingView alloc] initWithFrame:self.bounds];
        [self addSubview:_loadingView];
    }
    return _loadingView;
}

#pragma mark Private Method
- (void)setState:(IUScrollViewRefreshState)state {
    if (self.disabled && state != IUScrollViewRefreshStateNormal && state != IUScrollViewRefreshStateComplete) return;
    if (_state == state) return;
    
    _state = state;
    switch (_state) {
        case IUScrollViewRefreshStateNormal:
            [self resetScrollViewContentInset];
            break;
        case IUScrollViewRefreshStateReleaseToRefresh:
            [self resetScrollViewContentInset];
            break;
        case IUScrollViewRefreshStateRefreshing:
            [self resetScrollViewContentInset];
            
            if ([self.loadingView respondsToSelector:@selector(startAnimating)]) [self.loadingView startAnimating];
            
            if (_handler) {
                __weak typeof(self) weakSelf = self;
                _handler(^{
                    weakSelf.state = IUScrollViewRefreshStateComplete;
                });
            }
            break;
        case IUScrollViewRefreshStateComplete:
        {
            if ([self.loadingView respondsToSelector:@selector(stopAnimating)]) [self.loadingView stopAnimating];
            
            if (self.refreshImmediately) {
                [self resetScrollViewContentInset];
            } else {
                if ([self.loadingView respondsToSelector:@selector(setComplete:)]) [self.loadingView setComplete:YES];
                [self performSelector:@selector(resetScrollViewContentInset) withObject:nil afterDelay:IUScrollViewRefreshViewCompleteWaitDuration inModes:@[NSRunLoopCommonModes]];
            }
        }
            break;
            
        default:
            break;
    }
}

static int _resettingCount = 0;

- (void)resetScrollViewContentInset {
    if (self.scrollView) {
        _resettingCount++; //屏蔽自身重新计算inset步骤
        [self.scrollView resetContentInset];
        _resettingCount--;  //解除屏蔽
    }
    [self performSelector:@selector(resetLoadingView) withObject:nil afterDelay:IUScrollViewRefreshViewCompleteAnimationDuration inModes:@[NSRunLoopCommonModes]];
}

- (void)resetLoadingView {
    if ([self.loadingView respondsToSelector:@selector(setComplete:)]) [self.loadingView setComplete:NO];
}

- (void)resetInset {
    if (_resettingCount == 0 && self.scrollView) {
        CGFloat inset = 0;
        switch (_position) {
            case IUScrollViewRefreshPositionTop:
                inset = self.scrollView.contentInset.top;
                break;
            case IUScrollViewRefreshPositionBottom:
                inset = self.scrollView.contentInset.bottom;
                break;
                
            default:
                break;
        }
        
        if (_state == IUScrollViewRefreshStateRefreshing) {
            inset -= self.bounds.size.height;
        }
        
        if (_inset != inset) {
            _inset = inset;
            [self resetFrame];
        }
    }
}

#pragma mark Observing
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (self.superview) [self removeObserversForObject:self.superview];
    if (newSuperview) [self addObserversForObject:newSuperview];
}

- (void)addObserversForObject:(id)object {
    [object addObserver:self forKeyPath:IUScrollViewRefreshViewObserverKeyPathContentOffset options:NSKeyValueObservingOptionNew context:nil];
    [object addObserver:self forKeyPath:IUScrollViewRefreshViewObserverKeyPathContentSize options:NSKeyValueObservingOptionNew context:nil];
    [object addObserver:self forKeyPath:IUScrollViewRefreshViewObserverKeyPathContentInset options:NSKeyValueObservingOptionNew context:nil];
    [object addObserver:self forKeyPath:IUScrollViewRefreshViewObserverKeyPathFrame options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserversForObject:(id)object {
    [object removeObserver:self forKeyPath:IUScrollViewRefreshViewObserverKeyPathContentOffset];
    [object removeObserver:self forKeyPath:IUScrollViewRefreshViewObserverKeyPathContentSize];
    [object removeObserver:self forKeyPath:IUScrollViewRefreshViewObserverKeyPathContentInset];
    [object removeObserver:self forKeyPath:IUScrollViewRefreshViewObserverKeyPathFrame];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:IUScrollViewRefreshViewObserverKeyPathContentOffset]) {
        [self scrollViewDidScroll:object];
    } else if ([keyPath isEqualToString:IUScrollViewRefreshViewObserverKeyPathContentSize]) {
        [self resetFrame];
    } else if ([keyPath isEqualToString:IUScrollViewRefreshViewObserverKeyPathContentInset]) {
        [self resetInset];
    } else if ([keyPath isEqualToString:IUScrollViewRefreshViewObserverKeyPathFrame]) {
        [self resetFrame];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark Frame
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self resetInset];
    [self resetFrame];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self resetFrame];
}

- (void)setPosition:(IUScrollViewRefreshPosition)position {
    _position = position;
    [self resetFrame];
}

- (void)resetFrame {
    if (self.scrollView) {
        CGRect frame = CGRectMake((self.scrollView.bounds.size.width - self.bounds.size.width) / 2.f, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
        switch (_position) {
            case IUScrollViewRefreshPositionTop:
                frame.origin.y = -self.bounds.size.height - _inset;
                break;
            case IUScrollViewRefreshPositionBottom:
                frame.origin.y = MAX(self.scrollView.contentSize.height + _inset, self.scrollView.bounds.size.height);
                break;
                
            default:
                break;
        }
        super.frame = frame;
    }
}

@end
