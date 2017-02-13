//
//  UIView+IUTouchAreaExpand.h
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IUTouchAreaExpand)

@property (nonatomic, assign) UIEdgeInsets expandInsets;

- (void)setExpandEdge:(CGFloat)edge;

@end
