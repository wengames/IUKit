//
//  TestRequestResult.m
//  IUKitDemo
//
//  Created by admin on 2017/2/16.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "TestRequestResult.h"
#import "MJExtension.h"

@implementation TestRequestResult

- (id)responseObject {
    if (_responseObject == nil && self.config.fakeRequest && self.config.modelClass) {
        _responseObject = [self.model mj_keyValues];
    }
    return _responseObject;
}

- (id)model {
    if (_model == nil && self.config.modelClass) {
        if (self.config.fakeRequest) {
            if ([self.config.modelClass respondsToSelector:@selector(randomData)]) {
                _model = [self.config.modelClass randomData];
            }
        } else if (_responseObject) {
            _model = [self.config.modelClass mj_objectWithKeyValues:self.responseObject];
        }
    }
    return _model;
}

@end
