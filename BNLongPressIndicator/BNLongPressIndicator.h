//
//  BNLongPressIndicator.h
//  BNLongPressIndicatorDemo
//
//  Created by Aaron Ritchie on 2013-05-15.
//  Copyright (c) 2013 BNOTIONS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define REQUIRED_DURATION       1.0
#define RECOGNITION_DELAY       0.5
#define INDICATOR_RADIUS        50.0
#define COLOR                   [UIColor blackColor].CGColor

@interface BNLongPressIndicator : UILongPressGestureRecognizer
{
    CAShapeLayer* indicator;
    CAShapeLayer* circle;
    BOOL          animating;
    CGFloat       requiredDuration;
    CGFloat       radius;
    CGColorRef    color;
}

@property (strong)            CAShapeLayer* indicator;
@property (strong)            CAShapeLayer* circle;
@property (strong, nonatomic) NSTimer*      timer;
@property (assign)            NSUInteger    counter;
@property (assign)            BOOL          animating;
@property (assign)            SEL           selector;
@property (assign)            id            selectorTarget;
@property                     CGFloat       requiredDuration;
@property                     CGFloat       radius;
@property                     CGColorRef    color;

- (void)handle:(UILongPressGestureRecognizer*)gesture;
- (void)complete;
- (void)createIndicatorAtPoint:(CGPoint)point;
- (void)indicatorDidCompleteAnimation;

@end