//
//  UIViewController+IUAlertController.m
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IUAlertController.h"
#import "objc/runtime.h"

static char TAG_COMFIRM_COMPLETE;
static char TAG_COMFIRM_RESULT;

static char TAG_BUTTON_HANDLE;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"

@interface UIActionSheet (UIActionSheetDelegate) <UIActionSheetDelegate>

@end

@implementation UIActionSheet (UIActionSheetDelegate)

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    void(^handle)(NSInteger i) = objc_getAssociatedObject(actionSheet, &TAG_BUTTON_HANDLE);
    if (handle) handle(buttonIndex);
}

@end

@interface UIAlertView (UIAlertViewDelegate) <UIAlertViewDelegate>

@end

@implementation UIAlertView (UIAlertViewDelegate)

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    void(^handle)(NSInteger i) = objc_getAssociatedObject(alertView, &TAG_BUTTON_HANDLE);
    if (handle) handle(buttonIndex);
    
    // confirm()方法使用
    if (objc_getAssociatedObject(self, &TAG_COMFIRM_COMPLETE)) {
        objc_setAssociatedObject(alertView, &TAG_COMFIRM_COMPLETE, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(alertView, &TAG_COMFIRM_RESULT, @(buttonIndex == 1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end

#pragma clang diagnostic pop

@implementation UIViewController (IUAlertController)

- (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message handle:(void(^)(NSInteger buttonIndex))handle cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:10];
    va_list params;  //定义一个指向个数可变的参数列表指针；
    id argument;
    if (otherButtonTitles) {
        [titles addObject:otherButtonTitles];
        va_start(params, otherButtonTitles);
        while ((argument = va_arg(params, NSString *))) {
            [titles addObject:argument];
        }
        va_end(params);//释放列表指针
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        BOOL hasCancelButton = [self isExistString:cancelButtonTitle];
        for (int i = 0; i < [titles count]; i++) {
            [alertController addAction:[UIAlertAction actionWithTitle:titles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (handle) handle(hasCancelButton ? i + 1 : i);
            }]];
        }
        
        if (hasCancelButton) {
            [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (handle) handle(0);
            }]];
        }
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:nil];
#pragma clang diagnostic pop
        if (handle) {
            objc_setAssociatedObject(actionSheet, &TAG_BUTTON_HANDLE, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            actionSheet.delegate = actionSheet;
        }
        for (int i = 0; i < [titles count]; i++) {
            [actionSheet addButtonWithTitle:titles[i]];
        }
        [actionSheet showInView:self.view];
    }
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message handle:(void(^)(NSInteger buttonIndex))handle cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:10];
    va_list params;  //定义一个指向个数可变的参数列表指针；
    id argument;
    if (otherButtonTitles) {
        [titles addObject:otherButtonTitles];
        va_start(params, otherButtonTitles);
        while ((argument = va_arg(params, NSString *))) {
            [titles addObject:argument];
        }
        va_end(params);//释放列表指针
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        BOOL hasCancelButton = [self isExistString:cancelButtonTitle];
        for (int i = 0; i < [titles count]; i++) {
            [alertController addAction:[UIAlertAction actionWithTitle:titles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (handle) handle(hasCancelButton ? i + 1 : i);
            }]];
        }
        
        if (hasCancelButton) {
            [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (handle) handle(0);
            }]];
        }
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
#pragma clang diagnostic pop
        if (handle) {
            objc_setAssociatedObject(alertView, &TAG_BUTTON_HANDLE, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            alertView.delegate = alertView;
        }
        for (int i = 0; i < [titles count]; i++) {
            [alertView addButtonWithTitle:titles[i]];
        }
        [alertView show];
    }
}

- (BOOL)isExistString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]] ||
        string == nil ||
        [string isEqualToString:@""] ||
        [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return NO;
    }
    return YES;
}

@end

BOOL confirm(NSString *message) {
    id alert;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            objc_setAssociatedObject(alertController, &TAG_COMFIRM_COMPLETE, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(alertController, &TAG_COMFIRM_RESULT, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            objc_setAssociatedObject(alertController, &TAG_COMFIRM_COMPLETE, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(alertController, &TAG_COMFIRM_RESULT, @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }]];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        
        alert = alertController;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
#pragma clang diagnostic pop
        alertView.delegate = alertView;
        [alertView show];
        
        alert = alertView;
    }
    objc_setAssociatedObject(alert, &TAG_COMFIRM_COMPLETE, @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(alert, &TAG_COMFIRM_RESULT, @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    while (![objc_getAssociatedObject(alert, &TAG_COMFIRM_COMPLETE) boolValue]) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    return [objc_getAssociatedObject(alert, &TAG_COMFIRM_RESULT) boolValue];
}
