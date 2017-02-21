//
//  IUDashLineView.m
//  IUKitDemo
//
//  Created by admin on 2017/2/21.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUDashLineView.h"

@interface IUDashLineView ()

@property (nonatomic, strong) CAShapeLayer *dashLayer;

@end

@implementation IUDashLineView

@dynamic lineColor, lineDashPattern;

+ (instancetype)dashLine {
    return [self dashLineWithColor:nil];
}
+ (instancetype)dashLineWithColor:(UIColor *)color {
    return [self dashLineWithColor:nil pattern:nil];
}
+ (instancetype)dashLineWithColor:(UIColor *)color pattern:(NSArray *)pattern {
    return [self dashLineWithDirection:IUDashLineViewDirectionHorizontal color:nil pattern:nil];
}
+ (instancetype)dashLineWithDirection:(IUDashLineViewDirection)direction color:(UIColor *)color pattern:(NSArray *)pattern {
    IUDashLineView *view = [[self alloc] init];
    view.direction = direction;
    view.lineColor = color;
    view.lineDashPattern = pattern;
    return view;
}

- (instancetype)init {
    if (self = [super init]) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadDashLine];
}

- (void)reloadDashLine {
    CGMutablePathRef path = CGPathCreateMutable();
    switch (self.direction) {
        case IUDashLineViewDirectionHorizontal:
            CGPathMoveToPoint(path, NULL, 0, CGRectGetHeight(self.frame) / 2.f);
            CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 2.f);
            self.dashLayer.lineWidth = CGRectGetHeight(self.frame);
            break;
        case IUDashLineViewDirectionVertical:
            CGPathMoveToPoint(path, NULL, CGRectGetWidth(self.frame) / 2.f, 0);
            CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame) / 2.f, CGRectGetHeight(self.frame));
            self.dashLayer.lineWidth = CGRectGetWidth(self.frame);
            break;
        case IUDashLineViewDirectionUpperLeftToLowerRight:
            CGPathMoveToPoint(path, NULL, 0, 0);
            CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            break;
        case IUDashLineViewDirectionLowerLeftToUpperRight:
            CGPathMoveToPoint(path, NULL, 0, CGRectGetHeight(self.frame));
            CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), 0);
            break;

        default:
            break;
    }
    self.dashLayer.path = path;
    CGPathRelease(path);
}

- (CAShapeLayer *)dashLayer {
    if (_dashLayer == nil) {
        _dashLayer = [CAShapeLayer layer];
        _dashLayer.strokeColor = [UIColor blackColor].CGColor;
        _dashLayer.lineCap = kCALineCapButt;
        _dashLayer.lineDashPattern = @[@5, @5];
        _dashLayer.lineWidth = 1;
        [self.layer addSublayer:_dashLayer];
    }
    return _dashLayer;
}

- (void)setDirection:(IUDashLineViewDirection)direction {
    if (_direction == direction) return;
    _direction = direction;
    [self reloadDashLine];
}

- (void)setLineColor:(UIColor *)lineColor {
    if (lineColor == nil) return;
    self.dashLayer.strokeColor = lineColor.CGColor;
}

- (UIColor *)lineColor {
    return [UIColor colorWithCGColor:self.dashLayer.strokeColor];
}

- (void)setLineDashPattern:(NSArray *)lineDashPattern {
    if (lineDashPattern == nil) return;
    self.dashLayer.lineDashPattern = lineDashPattern;
}

- (NSArray *)lineDashPattern {
    return self.dashLayer.lineDashPattern;
}

@end
