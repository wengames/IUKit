//
//  NSURL+IUProtect.m
//  IUKitDemo
//
//  Created by admin on 2017/2/15.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "NSURL+IUProtect.h"
#import "IUMethodSwizzling.h"

@implementation NSURL (IUProtect)

+ (void)load {
    [self swizzleInstanceSelector:@selector(initWithString:relativeToURL:) toSelector:@selector(iuProtect_NSURL_initWithString:relativeToURL:)];
}

- (instancetype)iuProtect_NSURL_initWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL {
    NSURL *url = [self iuProtect_NSURL_initWithString:URLString relativeToURL:baseURL];
    if (url == nil) {
        url = [self iuProtect_NSURL_initWithString:[URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]] relativeToURL:baseURL];
    }
    return url;
}

- (NSString *)absoluteString_decoded {
    return [self.absoluteString stringByRemovingPercentEncoding];
}

- (NSString *)path_decoded {
    return [self.path stringByRemovingPercentEncoding];
}

- (NSString *)query_decoded {
    return [self.query stringByRemovingPercentEncoding];
}

@end
