//
//  ViewController.m
//  IUKitDemo
//
//  Created by admin on 2017/2/13.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "ViewController.h"
#import "TestRequestResult.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.setBackgroundColor([UIColor blackColor]);
    
    [IURequestConfig globalConfig].enableRequestLog = YES;
    
    NSLog(@"%@", [NSURL URLWithString:@"http://多舒服的方式地方?多舒服就离开=都是发挥空间"].absoluteString);
    
    IURequestConfig *config = [IURequestConfig config];
  
    NSLog(@"%@", config);
    IURequestConfig *config2 = [config deepCopy];
    NSLog(@"%@", config2);

    [self.view addSubview:[[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 100)].setBackgroundColor([UIColor cyanColor]).setMaxCharacterLength(5)];
}

@end
