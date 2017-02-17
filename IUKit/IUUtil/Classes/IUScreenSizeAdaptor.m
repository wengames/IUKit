//
//  IUScreenSizeAdaptor.m
//
//  Created by lhw on 16/3/25.
//  Copyright © 2016年 刘海文. All rights reserved.
//

#import "IUScreenSizeAdaptor.h"

@interface IUScreenSizeAdaptor ()

@property (nonatomic) float scaleFactor320;
@property (nonatomic) float scaleFactor640;
@property (nonatomic) float scaleFactor375;
@property (nonatomic) float scaleFactor750;

@end

@implementation IUScreenSizeAdaptor

+ (instancetype)sharedAdaptor {
    __strong static IUScreenSizeAdaptor *sharedUtil;
    static dispatch_once_t adaptorOnceToken;
    dispatch_once(&adaptorOnceToken, ^{
        sharedUtil = [[IUScreenSizeAdaptor alloc] init];
    });
    return sharedUtil;
}

- (float)scaleFactor320 {
    if (_scaleFactor320 == 0) {
        _scaleFactor320 = MIN(IUScreenWidth, IUScreenHeight) / 320.f;
    }
    return _scaleFactor320;
}

- (float)scaleFactor640 {
    if (_scaleFactor640 == 0) {
        _scaleFactor640 = MIN(IUScreenWidth, IUScreenHeight) / 640.f;
    }
    return _scaleFactor640;
}

- (float)scaleFactor375 {
    if (_scaleFactor375 == 0) {
        _scaleFactor375 = MIN(IUScreenWidth, IUScreenHeight) / 375.f;
    }
    return _scaleFactor375;
}

- (float)scaleFactor750 {
    if (_scaleFactor750 == 0) {
        _scaleFactor750 = MIN(IUScreenWidth, IUScreenHeight) / 750.f;
    }
    return _scaleFactor750;
}

+ (float)scaleFactorWithOriginalScreenWidth:(int)originalScreenWidth {
    switch (originalScreenWidth) {
        case 320:
            return [IUScreenSizeAdaptor sharedAdaptor].scaleFactor320;
        case 640:
            return [IUScreenSizeAdaptor sharedAdaptor].scaleFactor640;
        case 375:
            return [IUScreenSizeAdaptor sharedAdaptor].scaleFactor375;
        case 750:
            return [IUScreenSizeAdaptor sharedAdaptor].scaleFactor750;
    }
    return MIN(IUScreenWidth, IUScreenHeight) / (float)originalScreenWidth;
}

@end
