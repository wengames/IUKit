//
//  UIView+IUTouchAreaExpand.m
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIView+IUTouchAreaExpand.h"
#import <objc/runtime.h>
#import "IUMethodSwizzling.h"

static char TAG_VIEW_TOUCH_AREA_EXPAND_INSETS;

@implementation UIView (IUTouchAreaExpand)

+ (void)load {
    [self swizzleInstanceSelector:@selector(pointInside:withEvent:) toSelector:@selector(iuTouchAreaExpand_UIView_pointInside:withEvent:)];
}

- (void)setExpandEdge:(CGFloat)edge {
    self.expandInsets = UIEdgeInsetsMake(edge, edge, edge, edge);
}

- (void)setExpandInsets:(UIEdgeInsets)expandInsets {
    objc_setAssociatedObject(self, &TAG_VIEW_TOUCH_AREA_EXPAND_INSETS, [NSValue valueWithUIEdgeInsets:expandInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)expandInsets {
    return [objc_getAssociatedObject(self, &TAG_VIEW_TOUCH_AREA_EXPAND_INSETS) UIEdgeInsetsValue];
}

- (BOOL)iuTouchAreaExpand_UIView_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL result = [self iuTouchAreaExpand_UIView_pointInside:point withEvent:event];
    UIEdgeInsets expandInsets = self.expandInsets;
    if (result || UIEdgeInsetsEqualToEdgeInsets(expandInsets, UIEdgeInsetsZero)) {
        return result;
    } else {
        CGRect rect = self.bounds;
        rect.origin.x -= expandInsets.left;
        rect.origin.y -= expandInsets.top;
        rect.size.width += expandInsets.left + expandInsets.right;
        rect.size.height += expandInsets.top + expandInsets.bottom;
        return CGRectContainsPoint(rect, point);
    }
}

@end
