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

- (void)update {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _v1.transform = _transform;
    } completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _v1 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)].setBackgroundColor([UIColor redColor]).intoView(self.view);
    
    _motionManager = [[CMMotionManager alloc] init];
    _motionManager.accelerometerUpdateInterval = 0.05;
    [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
//        double d = sqrt(accelerometerData.acceleration.x * accelerometerData.acceleration.x + accelerometerData.acceleration.y + accelerometerData.acceleration.y);
        double x = accelerometerData.acceleration.x;
        double y = accelerometerData.acceleration.y;
        double z = accelerometerData.acceleration.z;
        _transform = CGAffineTransformMakeTranslation(-x * 100, y *100);

//        double rotation = atan2(accelerometerData.acceleration.x, accelerometerData.acceleration.y) - M_PI;
//        _transform = CGAffineTransformMakeRotation(rotation);
        NSLog(@"%.4f, %.4f, %.4f", x, y, z);
    }];
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    return;
    
    self.navigationItem.title = @"esdfsdf";
    
    _s = [[UISearchController alloc] initWithSearchResultsController:nil];
    [self.view addSubview:_s.searchBar];
    
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
