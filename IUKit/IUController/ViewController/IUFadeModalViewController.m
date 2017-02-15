//
//  IUFadeModalViewController.m
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUFadeModalViewController.h"
#import "UIViewController+IUModalTransition.h"

@interface IUFadeModalViewController ()

@end

@implementation IUFadeModalViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.modalType = IUTransitionTypeFade;
    }
    return self;
}

@end
