//
//  IUImageBrowseViewController.h
//  IUKitDemo
//
//  Created by admin on 2017/2/17.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUFadeModalViewController.h"

@class IUImageBrowseObject;
@protocol IUImageBrowseViewControllerDelegate;

@interface IUImageBrowseViewController : IUFadeModalViewController

@property (nonatomic) NSInteger currentIndex;

- (instancetype)initWithDelegate:(id<IUImageBrowseViewControllerDelegate>)delegate;
- (instancetype)initWithObjects:(NSArray <IUImageBrowseObject *> *)objects;
- (instancetype)initWithImages:(NSArray <UIImage *> *)images;
- (instancetype)initWithUrls:(NSArray <NSString *> *)urls;

- (void)reloadData;

@end

@protocol IUImageBrowseViewControllerDelegate <NSObject>

@optional
- (NSInteger)numberOfImagesInImageBrowseViewController:(IUImageBrowseViewController *)imageViewController;
- (IUImageBrowseObject *)imageBrowseViewController:(IUImageBrowseViewController *)imageViewController imageBrowseObjectAtIndex:(NSInteger)index;

@end

@interface IUImageBrowseObject : NSObject

@property (nonatomic, strong) UIImage  *image;
@property (nonatomic, strong) NSString *url;

+ (instancetype)objectWithImage:(UIImage *)image url:(NSString *)url;
+ (instancetype)objectWithUrl:(NSString *)url;

@end
