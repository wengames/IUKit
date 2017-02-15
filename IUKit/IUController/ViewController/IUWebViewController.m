//
//  IUWebViewController.m
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUWebViewController.h"

@interface IUWebViewController () <UIWebViewDelegate>

@end

@implementation IUWebViewController

@synthesize loadingBar = _loadingBar, webView = _webView;

- (instancetype)initWithURL:(NSString *)url {
    if (self = [self init]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _webView.delegate = self;
        _webView.backgroundColor = self.view.backgroundColor;
        _webView.frame = self.view.bounds;
        [self.view addSubview:_webView];
        [self.view bringSubviewToFront:self.loadingBar];
    }
    return _webView;
}

- (UIView *)loadingBar {
    if (_loadingBar == nil) {
        _loadingBar = [[UIView alloc] init];
        _loadingBar.backgroundColor = [UIColor redColor];
        _loadingBar.userInteractionEnabled = NO;
        _loadingBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        [self.view addSubview:_loadingBar];
    }
    return _loadingBar;
}

- (void)_showLoadingBar {
    self.loadingBar.frame = CGRectMake(0, 0, 0, 2);
    self.loadingBar.alpha = 1;
    [UIView animateWithDuration:0.8 animations:^{
        self.loadingBar.frame = CGRectMake(0, 0, self.view.bounds.size.width * 0.5, 2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            self.loadingBar.frame = CGRectMake(0, 0, self.view.bounds.size.width * 0.8, 2);
        } completion:nil];
    }];
}

- (void)finishLoadingBar {
    [UIView animateWithDuration:0.3 animations:^{
        self.loadingBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.loadingBar.alpha = 0;
        } completion:nil];
    }];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self _showLoadingBar];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self finishLoadingBar];
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self finishLoadingBar];
}

@end
