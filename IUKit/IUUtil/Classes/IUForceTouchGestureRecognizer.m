//
//  IUForceTouchGestureRecognizer.m
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUForceTouchGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface IUForceTouchGestureRecognizer ()
{
    CGPoint _startTouchLocation;
}
@end

@implementation IUForceTouchGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    // 判断设备是否支持 Force Touch
    if ([[UIScreen mainScreen] respondsToSelector:@selector(traitCollection)] && [[UIScreen mainScreen].traitCollection respondsToSelector:@selector(forceTouchCapability)] && [UIScreen mainScreen].traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        if (self = [super initWithTarget:target action:action]) {
            self.cancelsTouchesInView = NO;
            
            _minimumForceRequired = 1.0;
            _numberOfTouchesRequired = 1;
            _allowableMovement = 10;
        }
        return self;
    }
    return nil;
}

- (void)setForceWithTouches:(NSSet<UITouch *> *)touches {
    UITouch *touch = touches.anyObject;
    if (touch == nil) {
        _force = 0;
        _maximumPossibleForce = 0;
        return;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        _force = touch.force;
        _maximumPossibleForce = touch.maximumPossibleForce;
    } else {
        _force = 0;
        _maximumPossibleForce = 0;
    }
}

- (void)changeStateWithTouches:(NSSet<UITouch *> *)touches targetState:(UIGestureRecognizerState)targetState {
    switch (self.state) {
        case UIGestureRecognizerStatePossible:
        {
            if (_force > _minimumForceRequired && [touches count] >= _numberOfTouchesRequired) {
                self.state = UIGestureRecognizerStateBegan;
            }
        }
            break;
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            switch (targetState) {
                case UIGestureRecognizerStateChanged:
                {
                    UITouch *touch = touches.anyObject;
                    CGPoint currentLocation = [touch locationInView:touch.view];
                    CGFloat distance = sqrt((currentLocation.x - _startTouchLocation.x) * (currentLocation.x - _startTouchLocation.x) + (currentLocation.y - _startTouchLocation.y) * (currentLocation.y - _startTouchLocation.y));
                    
                    if (distance > _allowableMovement) {
                        self.state = UIGestureRecognizerStateFailed;
                    } else {
                        self.state = UIGestureRecognizerStateChanged;
                    }
                }
                    break;
                    
                default:
                    self.state = targetState;
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (void)reset {
    [super reset];
    [self setForceWithTouches:nil];
    self.state = UIGestureRecognizerStatePossible;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setForceWithTouches:touches];
    
    UITouch *touch = touches.anyObject;
    _startTouchLocation = [touch locationInView:touch.view];
    [self changeStateWithTouches:touches targetState:UIGestureRecognizerStateBegan];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self setForceWithTouches:touches];
    [self changeStateWithTouches:touches targetState:UIGestureRecognizerStateChanged];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self setForceWithTouches:touches];
    [self changeStateWithTouches:touches targetState:UIGestureRecognizerStateEnded];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self setForceWithTouches:touches];
    [self changeStateWithTouches:touches targetState:UIGestureRecognizerStateCancelled];
}

@end
