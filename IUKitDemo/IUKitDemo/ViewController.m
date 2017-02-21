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

@interface ViewController ()
{
    UIImageView *_v;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"esdfsdf";
    
    [IURequestConfig globalConfig].enableRequestLog = YES;
    
    NSLog(@"%@", [NSURL URLWithString:@"http://多舒服的方式地方?多舒服就离开=都是发挥空间"].absoluteString);
    
    IURequestConfig *config = [IURequestConfig config];
  
    NSLog(@"%@", config);
    IURequestConfig *config2 = [config deepCopy];
    NSLog(@"%@", config2);

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
    
    UIView *dl;
    [self.view addSubview:[IUDashLineView dashLine].setFrame(CGRectMake(0, 250, 100, 1)).assign(&dl)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:2 delay:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            dl.frame = CGRectMake(0, 250, 300, 1);
        } completion:nil];
    });
    
}

//- (UIViewController *)viewControllerForPreviewingWithSourceView:(UIView *)sourceView {
//    return [[IUImageBrowseViewController alloc] initWithUrls:@[@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg",@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg"]];
//}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    IUBottomSheetViewController *vc = [[IUBottomSheetViewController alloc] init];
    vc.contentView.setFrame(CGRectMake(0, 0, 100, 200)).setBackgroundColor([UIColor whiteColor]);
    [self presentViewController:vc animated:YES completion:nil];
    return;
    
//    [[IURouter router] open:@"ViewController"];
//    [self.navigationController pushViewController:[[ViewController alloc] init] animated:YES];
    IUImageBrowseViewController *ib = [[IUImageBrowseViewController alloc] initWithUrls:@[@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg",@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg",@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg",@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg",@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg"]];
    [self presentViewController:ib animated:YES completion:nil];
}

- (NSArray *)magicViewsTransitionFromViewController:(UIViewController *)viewController {
    return @[_v];
}

- (NSArray *)magicViewsTransitionToViewController:(UIViewController *)viewController {
    return @[_v];
}

@end
