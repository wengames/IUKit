//
//  IUController.h
//  IUController
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef __OBJC__

// view controller
#import "UIViewController+IUContainView.h"
#import "UIViewController+IUAppear.h"
#import "UIViewController+IUPreviewing.h"
#import "UIViewController+IUSubviews.h"
#import "UIViewController+IUKeyboard.h"
#import "UIViewController+IUModalTransition.h"
#import "IUFadeModalViewController.h"
#import "IUBottomSheetViewController.h"
#import "IUAlertPromptViewController.h"
#import "IUImageBrowseViewController.h"
#import "IUWebViewController.h"

// orientation
#import "UIViewController+IUOrientation.h"
#import "UINavigationController+IUOrientation.h"
#import "UITabBarController+IUOrientation.h"

// status bar
// effects when set "View controller-based status bar appearance" to "YES" in info.plist
#import "UIViewController+IUStatusBarAutoRefresh.h"
#import "UIViewController+IUStatusBarHidden.h"
#import "UIViewController+IUStatusBarStyle.h"
#import "UINavigationController+IUStatusBar.h"
#import "UITabBarController+IUStatusBar.h"

// navigation controller
#import "UINavigationController+IUAutoHidesBottomBarWhenPushed.h"
#import "UINavigationController+IUFullScreenInteractivePopGestureRecognizer.h"
#import "UIViewController+IUNavigationBarHidden.h"

// transition
#import "IUTransitionAnimator.h"
#import "IUTransitioningDelegate.h"
#import "UIViewController+IUMagicTransition.h"

#endif
