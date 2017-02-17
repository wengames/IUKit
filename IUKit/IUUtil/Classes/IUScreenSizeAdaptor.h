//
//  IUScreenSizeAdaptor.h
//
//  Created by lhw on 16/3/25.
//  Copyright © 2016年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define IUScreenSize        [[UIScreen mainScreen] bounds].size
#define IUScreenWidth       IUScreenSize.width
#define IUScreenHeight      IUScreenSize.height

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH IUScreenWidth
#endif

#ifndef SCREEN_HEIGHT
#define SCREEN_HEIGHT IUScreenHeight
#endif

#define IUScale_320         [IUScreenSizeAdaptor scaleFactorWithOriginalScreenWidth:320]
#define IUScale_640         [IUScreenSizeAdaptor scaleFactorWithOriginalScreenWidth:640]
#define IUScale_375         [IUScreenSizeAdaptor scaleFactorWithOriginalScreenWidth:375]
#define IUScale_750         [IUScreenSizeAdaptor scaleFactorWithOriginalScreenWidth:750]

#define IUScaleFrom320(n)   floor(n*IUScale_320)
#define IUScaleFrom640(n)   floor(n*IUScale_640)
#define IUScaleFrom375(n)   floor(n*IUScale_375)
#define IUScaleFrom750(n)   floor(n*IUScale_750)

#define kSF320(n)           IUScaleFrom320(n)
#define kSF640(n)           IUScaleFrom640(n)
#define kSF375(n)           IUScaleFrom375(n)
#define kSF750(n)           IUScaleFrom750(n)

@interface IUScreenSizeAdaptor : NSObject

+ (float)scaleFactorWithOriginalScreenWidth:(int)originalScreenWidth;

@end
