//
//  IUForceTouchGestureRecognizer.h
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IUForceTouchGestureRecognizer : UIGestureRecognizer

@property (nonatomic, readonly) float force;
@property (nonatomic, readonly) float maximumPossibleForce;

@property (nonatomic) float      minimumForceRequired;      // Default is 1.0, Where 1.0 represents the force of an average touch
@property (nonatomic) NSUInteger numberOfTouchesRequired;   // Default is 1. Number of fingers that must be held down for the gesture to be recognized
@property (nonatomic) CGFloat    allowableMovement;         // Default is 10.

@end
