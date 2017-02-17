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
    UIView *_v;
}
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

    [self.view addSubview:[[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 100)].setClearButtonMode(UITextFieldViewModeWhileEditing).setBackgroundColor([UIColor cyanColor]).setMaxCharacterLength(5)];
    
//    [[[UIImageView alloc] init] sd_setImageWithURL:[NSURL URLWithString:@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg"]];
    _v = [[UIView alloc] initWithFrame:CGRectMake(100, 250, 100, 100)].setBackgroundColor([UIColor blueColor]).intoView(self.view);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self presentViewController:[[IUImageBrowseViewController alloc] initWithUrls:@[@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg",@"http://pic1.5442.com:82/2015/0409/01/15.jpg%21960.jpg"]] animated:YES completion:nil];
}

- (NSArray *)magicViewsTransitionFromViewController:(UIViewController *)viewController {
    return @[_v];
}

- (NSArray *)magicViewsTransitionToViewController:(UIViewController *)viewController {
    return @[_v];
}

@end
