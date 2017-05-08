//
//  PushedViewController.m
//  IUKitDemo
//
//  Created by admin on 2017/5/8.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "PushedViewController.h"

@interface PushedViewController ()

@end

@implementation PushedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.navigationItem.title = @"2";
    
    UITextView *t = [[UITextView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    t.backgroundColor = [UIColor greenColor];
    [self.view addSubview:t];
}

@end
