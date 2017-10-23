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
#import <UserNotifications/UserNotifications.h>
#import "PushedViewController.h"

@interface ViewController ()
{
    UIView *_v1;
    UIImageView *_v;
    UISearchController *_s;
    CMMotionManager *_motionManager;
    CGAffineTransform _transform;
    int _i;
}
@end

@implementation ViewController

- (void)push {
    [self.navigationController pushViewController:[[PushedViewController alloc] init] animated:YES];
}

- (int)i {
    @try {
        return _i;
    } @catch (NSException *exception) {
        
    } @finally {
        _i++;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _i = 100;
    _i = _i + [self i];
    NSLog(@"%d", _i);
    
    _i = 100;
    _i = [self i] + _i;
    NSLog(@"%d", _i);

    _i = 100;
    _i += [self i];
    NSLog(@"%d", _i);
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    scrollView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    scrollView.contentSize = CGSizeMake(100, 200);
    [self.view addSubview:scrollView];
    [scrollView addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)].setBackgroundColor([UIColor greenColor])];
    NSLog(@"%f",scrollView.contentSize.height);
    
    _v = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    _v.backgroundColor = [UIColor lightGrayColor];
    _v.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_v];
    
    return;
    
    UITextView *t = [[UITextView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    t.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:t];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake(100, 200, 100, 100);
    [b addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];

    return;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"G yyyy MMMM dd EEEE 'T' aa h:mm:ss.SSS ZZZ";
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSLog(@"%@", [df stringFromDate:[NSDate date]]);
    
    NSMutableString *mutableString = [NSMutableString stringWithString:@""];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    NSLog(@"%@", mutableString);
    
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 123456;
    self.navigationItem.title = @"esdfsdf";
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"title";
    content.subtitle = @"subtitle";
    content.body = @"body";
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"local" content:content trigger:[UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO]];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    vc.delegate = self;
    vc.sourceType = UIImagePickerControllerSourceTypeCamera;
    vc.allowsEditing = NO;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    [picker dismissViewControllerAnimated:YES completion:nil];
    _v.image = image;
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
