//
//  IUWebViewController.h
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IUWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong, readonly) UIView    *loadingBar;
@property (nonatomic, strong, readonly) UIWebView *webView;

- (instancetype)initWithURL:(NSString *)url;

@end
