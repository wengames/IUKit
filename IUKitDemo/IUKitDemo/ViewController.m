//
//  ViewController.m
//  IUKitDemo
//
//  Created by admin on 2017/2/13.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "ViewController.h"
#import "TestRequestResult.h"
#import "UIImageView+WebCache.h"
#import <CoreMotion/CoreMotion.h>
#import "TestLabel.h"

@interface ViewController ()
{
    UIView *_v1;
    UIImageView *_v;
    UISearchController *_s;
    CMMotionManager *_motionManager;
    CGAffineTransform _transform;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"esdfsdf";
    
    _s = [[UISearchController alloc] initWithSearchResultsController:nil];
    [self.view addSubview:_s.searchBar];
    
    [IURequestConfig globalConfig].enableRequestLog = YES;
    
    IURequestConfig *config = [IURequestConfig config];
  
    NSLog(@"%@", config);
    IURequestConfig *config2 = [config deepCopy];
    NSLog(@"%@", config2);
    
    [self.view addSubview:[[TestLabel alloc] initWithFrame:CGRectMake(100, 200, 100, 100)].setText(@"213").setBackgroundColor([UIColor greenColor])];

    [self.view addSubview:[[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 100)].setClearButtonMode(UITextFieldViewModeWhileEditing).setBackgroundColor([UIColor cyanColor]).setMaxCharacterLength(5)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 200, 100, 100);
    [button setTitle:@"ttt" forState:UIControlStateNormal];
    [self.view addSubview:button];

    _v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)].setBackgroundColor([UIColor blueColor]).intoView(self.view);
    _v.userInteractionEnabled = YES;
    [_v sd_setImageWithURL:[NSURL URLWithString:@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg"]];
//    self.navigationController.navigationBar
//    [self registerPreviewingWithSourceView:_v];
    
}

//- (UIViewController *)viewControllerForPreviewingWithSourceView:(UIView *)sourceView {
//    return [[IUImageBrowseViewController alloc] initWithUrls:@[@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg",@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg"]];
//}

//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
////    IUBottomSheetViewController *vc = [[IUBottomSheetViewController alloc] init];
////    vc.contentView.setFrame(CGRectMake(0, 0, 100, 200)).setBackgroundColor([UIColor whiteColor]);
////    [self presentViewController:vc animated:YES completion:nil];
////    return;
////    
////    [[IURouter router] open:@"ViewController"];
////    [self.navigationController pushViewController:[[ViewController alloc] init] animated:YES];
//    IUImageBrowseViewController *ib = [[IUImageBrowseViewController alloc] initWithUrls:@[@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg",@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg",@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg",@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg",@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg"]];
//    [self presentViewController:ib animated:YES completion:nil];
//}

//- (NSArray *)magicViewsTransitionFromViewController:(UIViewController *)viewController {
//    return @[_v];
//}
//
//- (NSArray *)magicViewsTransitionToViewController:(UIViewController *)viewController {
//    return @[_v];
//}

@end
