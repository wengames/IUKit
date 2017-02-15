//
//  ViewController.m
//  IUKitDemo
//
//  Created by admin on 2017/2/13.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "ViewController.h"
#import "TestDataFetcher.h"

@interface ViewController ()
{
    TestDataFetcher *_f;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.setBackgroundColor([UIColor blackColor]);
    
    [IURequestConfig globalConfig].enableRequestLog = YES;
    
    _f = [TestDataFetcher dataFetcher];
    _f.config.fakeRequest = YES;
    _f.parameters = @{
                      @"version" : @"1.0.0",
                      @"platform" : @0
                      };
    NSLog(@"%@", [NSURL URLWithString:@"http://多舒服的方式地方?多舒服就离开=都是发挥空间"].absoluteString);
}

@end
