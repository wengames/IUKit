//
//  IUDashLineView.h
//  IUKitDemo
//
//  Created by admin on 2017/2/21.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    IUDashLineViewDirectionHorizontal = 0,
    IUDashLineViewDirectionVertical,
    IUDashLineViewDirectionUpperLeftToLowerRight,
    IUDashLineViewDirectionLowerLeftToUpperRight
} IUDashLineViewDirection;

@interface IUDashLineView : UIView

@property (nonatomic) IUDashLineViewDirection direction;     // default is horizontal
@property (nonatomic) UIColor *lineColor;                    // default is black color
@property (nonatomic) NSArray <NSNumber *> *lineDashPattern; // default is [5, 5]

+ (instancetype)dashLine;
+ (instancetype)dashLineWithColor:(UIColor *)color;
+ (instancetype)dashLineWithColor:(UIColor *)color pattern:(NSArray *)pattern;
+ (instancetype)dashLineWithDirection:(IUDashLineViewDirection)direction color:(UIColor *)color pattern:(NSArray *)pattern;

@end
