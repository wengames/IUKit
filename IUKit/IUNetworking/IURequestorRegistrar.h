//
//  IURequestorRegistrar.h
//  IUKitDemo
//
//  Created by admin on 2017/2/14.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IURequest;
@protocol IUNetworkingRequestDelegate;

typedef void(^IUNetworkingRetry)(void);

typedef id<IUNetworkingRequestDelegate>(^IUNetworkWeakRequestor)(void);

@interface IURequestorRegistrar : NSObject

@property (nonatomic, strong) NSArray <IUNetworkWeakRequestor> *requestors;

+ (instancetype)sharedInstance;

- (void)setRequestor:(id<IUNetworkingRequestDelegate>)requestor;
- (void)addRequestor:(id<IUNetworkingRequestDelegate>)requestor;
- (void)removeRequestor:(id<IUNetworkingRequestDelegate>)requestor;
- (void)clear;

@end

@protocol IUNetworkingRequestDelegate <NSObject>

@optional
- (void)request:(IURequest *)request didStart:(NSInteger)requestingCount;
- (void)request:(IURequest *)request didComplete:(NSInteger)requestingCount;
- (void)request:(IURequest *)request didFailWithError:(NSError *)error;

@end

@interface NSObject (IUBecomeRequestor) <IUNetworkingRequestDelegate>

// convenience methods to set self be requestor
- (void)setRequestor;
- (void)addRequestor;
- (void)removeRequestor;
- (void)clearRequestor;

@end
