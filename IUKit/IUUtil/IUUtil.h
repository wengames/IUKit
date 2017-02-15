//
//  IUUtil.h
//  IUUtil
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef __OBJC__

#import "NSDate+IUQuickDate.h"
#import "NSString+IURegex.h"
#import "NSString+IUEvaluate.h"
#import "NSString+IUTokenizer.h"
#import "NSString+IUJsonTransform.h"
#import "NSString+IUCrypto.h"
#import "NSString+IUAttributedStringTransform.h"

#import "UIImage+IUColor.h"
#import "UIImage+IUFilter.h"
#import "UIImage+IUGif.h"
#import "UIImage+IURotation.h"
#import "UIImage+IUTransform.h"

#import "UIColor+IUGenerator.h"

#import "UIResponder+IUController.h"

#import "UIView+IUEmpty.h"
#import "UIView+IUTouchAreaExpand.h"
#import "UITableView+IUDataBinder.h"
#import "UIButton+IUColor.h"

#import "UIViewController+IUAlertController.h"

#import "IUCollectionViewSpringFlowLayout.h"
#import "IUForceTouchGestureRecognizer.h"
#import "IUTabPageView.h"
#import "IUTabPageViewController.h"

#endif

#define IUDeviceVersion                 [[[UIDevice currentDevice] systemVersion] floatValue]
#define IUDeviceVersionNotLessThan(v)   (kDeviceVersion >= v)

@interface IUUtil : NSObject

/**
 *  显示弹窗, 弹窗信息为message
 *
 *  @param message  弹窗信息
 */
+ (void)showMessage:(NSString *)message;

/**
 *  返回当前页面最最上层的viewController(非tabbar非navi)
 *
 *  @return 最最上层的viewController(非tabbar非navi)
 */
+ (UIViewController *)currentTopViewController;

/**
 *  获取由 ControlPoints 生成的贝赛尔曲线, 在位置 t 的坐标
 *
 *  @param  cp  CGPoint[4]
 *  @param  t   位置(0-1)
 *  @return     点坐标
 */
+ (CGPoint)pointWithBezierCurveForControlPoints:(CGPoint *)cp atPercent:(float)t;

@end
