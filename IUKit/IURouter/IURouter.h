//
//  IURouter.h
//  IURouter
//
//  Created by admin on 2017/2/7.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+IURouter.h"
#import "IURouterWebViewController.h"
#import "IURouterBehavior.h"

@interface IURouter : NSObject

@property (nonatomic, strong, readonly) NSArray <NSString *> *urlSchemes;
@property (nonatomic, strong, readonly) NSDictionary <NSString *, NSString *> *aliasMap;
@property (nonatomic, strong) UIViewController *(^webViewController)(NSString *url); // view controller for undefined url, default nil

+ (instancetype)router;

- (void)setAlias:(NSString *)alias forController:(NSString *)controller;
- (void)setAliases:(NSArray <NSString *> *)aliases forController:(NSString *)controller;

/**
 open url in native or web view by push view controller in navigation controller in the key window
 if there is no navigation controller conforms, it will present view controller on key window's root view controller

 protocol  (optional) - http://     open as a web url
                        https://    open as a web url
                        {scheme}:// open as a native url if the scheme directs self app, or open by application
                        <null>      open as a native url
 operation (optional) - ../     back once
                        /       back to root
                        ./      do nothing
                        <null>  do nothing
 path      (required) - {target}/{param1}/{param2}/?{key1}={value1}&{key2}={value2}&...
 target    (required) - name of view controller or it's alias
 param     (optional) - path parameter with name, can be found in viewController.argv
 key,value (optional) - parameters with key and value, can be found in viewController.parameters
 
 e.g.   [IURouter open:@"http://www.baidu.com"]
        [IURouter open:@"/UIViewController/1?title=expample"]
 
 @param route {protocol}{operation}{path}
 @return    behavior(YES) if can open route, otherwise NO.
 */
- (IURouterBehavior *)behavior:(NSString *)route;
- (BOOL)open:(NSString *)route;

@end
