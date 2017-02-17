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
    
    self.title = @"esdfsdf";
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
//    self.view.setBackgroundColor([UIColor blackColor]);
    
    [IURequestConfig globalConfig].enableRequestLog = YES;
    
    NSLog(@"%@", [NSURL URLWithString:@"http://多舒服的方式地方?多舒服就离开=都是发挥空间"].absoluteString);
    
    IURequestConfig *config = [IURequestConfig config];
  
    NSLog(@"%@", config);
    IURequestConfig *config2 = [config deepCopy];
    NSLog(@"%@", config2);

    [self.view addSubview:[[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 100)].setClearButtonMode(UITextFieldViewModeWhileEditing).setBackgroundColor([UIColor cyanColor]).setMaxCharacterLength(5)];
    
    _v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)].setBackgroundColor([UIColor blueColor]).intoView(self.view);
    _v.userInteractionEnabled = YES;
    [_v sd_setImageWithURL:[NSURL URLWithString:@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg"]];
//    [self registerPreviewingWithSourceView:_v];
}

//- (UIViewController *)viewControllerForPreviewingWithSourceView:(UIView *)sourceView {
//    return [[IUImageBrowseViewController alloc] initWithUrls:@[@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg",@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg"]];
//}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [[IURouter router] open:@"ViewController"];
//    [self.navigationController pushViewController:[[ViewController alloc] init] animated:YES];
    IUImageBrowseViewController *ib = [[IUImageBrowseViewController alloc] initWithUrls:@[@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg",@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg",@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg",@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg",@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg"]];
    [self presentViewController:ib animated:YES completion:nil];
}

- (NSArray *)magicViewsTransitionFromViewController:(UIViewController *)viewController {
    return @[_v];
}

- (BOOL)enableMagicViewsLiftDropWhenTransitionToViewController:(UIViewController *)viewController {
    return NO;
}

- (NSArray *)magicViewsTransitionToViewController:(UIViewController *)viewController {
    return @[_v];
}

@end
