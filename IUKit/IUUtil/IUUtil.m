//
//  IUUtil.m
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUUtil.h"

@implementation IUUtil

+ (void)showMessage:(NSString *)message {
    if ([message length] == 0) return;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, screenWidth - 80, 0)];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.text = message;
    [messageLabel sizeToFit];
    
    NSTimeInterval delayTime = 1.5 + 0.05 * [messageLabel.text length];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, messageLabel.bounds.size.width + 20, messageLabel.bounds.size.height + 20)];
    contentView.userInteractionEnabled = NO;
    contentView.center = CGPointMake(screenWidth / 2.f, screenHeight / 2.f);
    contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    contentView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    [contentView addSubview:messageLabel];
    
    contentView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:contentView];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        contentView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:delayTime options:UIViewAnimationOptionCurveEaseIn animations:^{
            contentView.alpha = 0;
        } completion:^(BOOL finished) {
            [contentView removeFromSuperview];
        }];
    }];
}

+ (UIViewController *)currentTopViewController {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (YES) {
        if (viewController.presentedViewController) {
            viewController = viewController.presentedViewController;
        } else if ([viewController isKindOfClass:[UITabBarController class]]) {
            viewController = [(UITabBarController *)viewController selectedViewController];
        } else if ([viewController isKindOfClass:[UINavigationController class]]) {
            viewController = [(UINavigationController *)viewController visibleViewController];
        } else {
            break;
        }
    }
    
    return viewController;
}

+ (CGPoint)pointWithBezierCurveForControlPoints:(CGPoint *)cp atPercent:(float)t {
    // x = (1-t)^3 *x0 + 3*t*(1-t)^2 *x1 + 3*t^2*(1-t) *x2 + t^3 *x3
    // y = (1-t)^3 *y0 + 3*t*(1-t)^2 *y1 + 3*t^2*(1-t) *y2 + t^3 *y3
    
    float   ax, bx, cx;
    float   ay, by, cy;
    float   tSquared, tCubed;
    CGPoint result;
    
    /*計算多項式系数*/
    
    cx = 3.0 * (cp[1].x - cp[0].x);
    bx = 3.0 * (cp[2].x - cp[1].x) - cx;
    ax = cp[3].x - cp[0].x - cx - bx;
    
    cy = 3.0 * (cp[1].y - cp[0].y);
    by = 3.0 * (cp[2].y - cp[1].y) - cy;
    ay = cp[3].y - cp[0].y - cy - by;
    
    /*计算t处的曲线点*/
    
    tSquared = t * t;
    tCubed = tSquared * t;
    
    result.x = (ax * tCubed) + (bx * tSquared) + (cx * t) + cp[0].x;
    result.y = (ay * tCubed) + (by * tSquared) + (cy * t) + cp[0].y;
    
    return result;
}

@end
