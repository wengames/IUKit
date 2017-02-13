//
//  IURouter.m
//  IURouter
//
//  Created by admin on 2017/2/7.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IURouter.h"

@interface IURouter ()
{
    NSMutableDictionary *_aliasMap;
}
@end

@implementation IURouter

+ (instancetype)router {
    static dispatch_once_t onceToken;
    static IURouter *__router = nil;
    dispatch_once(&onceToken, ^{
        __router = [[self alloc] init];
    });
    return __router;
}

- (instancetype)init {
    if (self = [super init]) {        
        NSArray *urlTypes = [[NSBundle mainBundle] infoDictionary][@"CFBundleURLTypes"];
        NSMutableArray *urlSchemes = [@[] mutableCopy];
        for (NSDictionary *urlType in urlTypes) {
            if (urlType[@"CFBundleURLSchemes"]) [urlSchemes addObject:urlType[@"CFBundleURLSchemes"]];
        }
        _urlSchemes = [urlSchemes copy];
        _aliasMap   = [@{} mutableCopy];
    }
    return self;
}

- (NSDictionary<NSString *,NSString *> *)aliasMap {
    return [_aliasMap copy];
}

- (void)setAlias:(NSString *)alias forController:(NSString *)controller {
    if (alias == nil || controller == nil) return;
    _aliasMap[alias] = controller;
}

- (void)setAliases:(NSArray<NSString *> *)aliases forController:(NSString *)controller {
    if (controller == nil) return;
    for (NSString *alias in aliases) {
        _aliasMap[alias] = controller;
    }
}

- (BOOL)open:(NSString *)route {
    IURouterBehavior *behavior = [self behavior:route];
    if (behavior) {
        [behavior show];
        return YES;
    }
    return NO;
}

- (IURouterBehavior *)behavior:(NSString *)route {
    return [self behaviorWebRoute:route] ?: [self behaviorNativeRoute:route];
}

- (IURouterBehavior *)behaviorWebRoute:(NSString *)route {
    if (self.webViewController == nil) return nil;
    NSString *url = [route isKindOfClass:[NSURL class]] ? [(NSURL *)route absoluteString] : route;
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        IURouterBehavior *behavior = [[IURouterBehavior alloc] init];
        UIViewController *(^webViewController)(NSString *url) = self.webViewController;
        if (webViewController) {
            behavior.controller = ^{
                return webViewController(url);
            };
        }
        return behavior;
    }
    return nil;
}

- (IURouterBehavior *)behaviorNativeRoute:(NSString *)route {
    NSString *url = [route isKindOfClass:[NSURL class]] ? [(NSURL *)route absoluteString] : route;
    NSArray *components = [url componentsSeparatedByString:@"://"];
    if ([components count] > 2 ||
        [components count] == 0 ||
        ([components count] == 2 && ![self.urlSchemes containsObject:[components firstObject]])) {
        return nil;
    }
    
    NSString *path = [components lastObject];
    /* path : ../viewController/1?key=value */
    NSMutableDictionary *params = [@{} mutableCopy];
    NSArray *targetWithParams = [path componentsSeparatedByString:@"?"];
    if ([targetWithParams count] > 2) {
        return nil;
    } else if ([targetWithParams count] == 2) {
        NSString *paramsStr = [targetWithParams lastObject];
        /* params : key=value */
        for (NSString *component in [paramsStr componentsSeparatedByString:@"&"]) {
            NSArray *keyWithValue = [component componentsSeparatedByString:@"="];
            if ([keyWithValue count] != 2) continue;
            params[[keyWithValue firstObject]] = [keyWithValue lastObject];
        }
    }
    
    IURouterBehavior *behavior = [[IURouterBehavior alloc] init];
    Class clazz = nil;
    NSMutableArray *argv = [@[] mutableCopy];
    for (NSString *component in [[targetWithParams firstObject] componentsSeparatedByString:@"/"]) {
        /* behaviors : [.., viewController, 1] */
        if (clazz == nil) {
            if ([component isEqualToString:@".."]) {
                if (behavior.backCount < IURouterBehaviorBackToRoot) behavior.backCount++;
            } else if ([component isEqualToString:@""]) {
                behavior.backCount = IURouterBehaviorBackToRoot;
            } else if ([component isEqualToString:@"."]) {
                // do nothing
            } else {
                NSString *target = self.aliasMap[component];
                clazz = (NSClassFromString(target) ?: NSClassFromString(component)) ?: NSClassFromString([component stringByAppendingString:@"ViewController"]);
                if (clazz == nil) break;
            }
        } else {
            [argv addObject:component];
        }
    }
    
    if (clazz) {
        behavior.controller = ^{
            UIViewController *viewController = [[clazz alloc] init];
            IURouterParameter *parameters = [[IURouterParameter alloc] init];
            parameters.argv = argv;
            parameters.params = params;
            viewController.parameters = parameters;
            return viewController;
        };
        return behavior;
    }
    
    return nil;
}

@end
