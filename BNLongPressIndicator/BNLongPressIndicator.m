//
//  BNLongPressIndicator.m
//  BNLongPressIndicatorDemo
//
//  Created by Aaron Ritchie on 2013-05-15.
//  Copyright (c) 2013 BNOTIONS. All rights reserved.
//

#import "BNLongPressIndicator.h"

@implementation BNLongPressIndicator

@synthesize indicator;
@synthesize circle;
@synthesize timer;
@synthesize counter;
@synthesize animating;
@synthesize selector;
@synthesize selectorTarget;
@synthesize requiredDuration;
@synthesize radius;
@synthesize color;

- (id)initWithTarget:(id)target action:(SEL)action
{
    if (self = [super initWithTarget:self action:@selector(handle:)])
    {
        self.animating            = NO;
        self.selector             = action;
        self.selectorTarget       = target;
        self.requiredDuration     = REQUIRED_DURATION;
        self.radius               = INDICATOR_RADIUS;
        self.color                = COLOR;
        self.minimumPressDuration = RECOGNITION_DELAY;
    }
    return self;
}

- (void)handle:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        self.animating = YES;
        self.counter = 0;
        self.timer = [
            NSTimer
            scheduledTimerWithTimeInterval:(self.requiredDuration + 0.25) - self.minimumPressDuration
            target:self
            selector:@selector(complete)
            userInfo:nil
            repeats:NO
        ];
        [self createIndicatorAtPoint:[gesture locationInView:self.view]];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        if (animating)
        {
            CGPoint point = [gesture locationInView:self.view];
            indicator.position = CGPointMake(point.x, point.y);
            circle.position = CGPointMake(point.x, point.y);
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [self.timer invalidate];
        [indicator removeFromSuperlayer];
        [circle removeFromSuperlayer];
    }
}

- (void)complete
{
    self.animating = NO;
    
    [self indicatorDidCompleteAnimation];
    
    NSInvocation *invocation = [
        NSInvocation
        invocationWithMethodSignature:[
            [self.selectorTarget class]
            instanceMethodSignatureForSelector:self.selector
        ]
    ];
    invocation.target = self.selectorTarget;
    invocation.selector = self.selector;
    [invocation invoke];
}

- (void)createIndicatorAtPoint:(CGPoint)point
{
    circle = [CAShapeLayer layer];
    circle.frame = CGRectMake(0, 0, 2.0 * radius, 2.0 * radius);
    circle.bounds = circle.frame;
    circle.anchorPoint = CGPointMake(0.5, 0.5);
    circle.opacity = 0.0;
    circle.path = [
        UIBezierPath
        bezierPathWithRoundedRect:circle.frame
        cornerRadius:radius
    ].CGPath;
    circle.position = CGPointMake(point.x, point.y);
    circle.fillColor = self.color;
    circle.strokeColor = [UIColor clearColor].CGColor;
    circle.lineWidth = 0;
    [self.view.layer addSublayer:circle];
    
    CABasicAnimation* animation = [
        CABasicAnimation
        animationWithKeyPath:@"opacity"
    ];
    animation.duration = 0.25;
    animation.repeatCount = 0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:0.25];
    animation.timingFunction = [
        CAMediaTimingFunction
        functionWithName:kCAMediaTimingFunctionEaseOut
    ];
    [circle addAnimation:animation forKey:animation.keyPath];
    
    CABasicAnimation* scaleAnimation = [
        CABasicAnimation
        animationWithKeyPath:@"transform.scale"
    ];
    scaleAnimation.duration = 0.25;
    scaleAnimation.repeatCount = 0;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.timingFunction = [
        CAMediaTimingFunction
        functionWithName:kCAMediaTimingFunctionEaseOut
    ];
    scaleAnimation.delegate = self;
    [scaleAnimation setValue:@"circleGrow" forKey:@"animateLayer"];
    [circle addAnimation:scaleAnimation forKey:scaleAnimation.keyPath];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    NSString* value = [theAnimation valueForKey:@"animateLayer"];
    if ([value isEqualToString:@"circleGrow"])
    {
        indicator = [CAShapeLayer layer];
        indicator.frame = CGRectMake(0, 0, 2.0 * (radius - 3), 2.0 * (radius - 3));
        indicator.bounds = indicator.frame;
        indicator.anchorPoint = CGPointMake(0.5, 0.5);
        indicator.path = [
            UIBezierPath
            bezierPathWithRoundedRect:indicator.frame
            cornerRadius:radius - 3
        ].CGPath;
        indicator.position = CGPointMake(
            circle.frame.origin.x + radius,
            circle.frame.origin.y + radius
        );
        indicator.fillColor = [UIColor clearColor].CGColor;
        indicator.strokeColor = self.color;
        indicator.lineWidth = 6;
        [self.view.layer addSublayer:indicator];

        //Configure animation
        CABasicAnimation* drawAnimation = [
            CABasicAnimation
            animationWithKeyPath:@"strokeEnd"
        ];
        drawAnimation.duration = self.requiredDuration - self.minimumPressDuration;
        drawAnimation.repeatCount = 1.0;
        drawAnimation.removedOnCompletion = NO;
        drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        drawAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        drawAnimation.timingFunction = [
            CAMediaTimingFunction
            functionWithName:kCAMediaTimingFunctionLinear
        ];

        //Add the animation to the indicator
        [indicator addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    }
    else if ([value isEqualToString:@"circleShrink"])
    {
        [indicator removeFromSuperlayer];
        [circle removeFromSuperlayer];
    }
}

- (void)indicatorDidCompleteAnimation
{
    //Fade out indicator
    CABasicAnimation* indicatorOpacityAnimation = [
        CABasicAnimation
        animationWithKeyPath:@"opacity"
    ];
    indicatorOpacityAnimation.duration = 0.25;
    indicatorOpacityAnimation.repeatCount = 0;
    indicatorOpacityAnimation.removedOnCompletion = NO;
    indicatorOpacityAnimation.fillMode = kCAFillModeForwards;
    indicatorOpacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    indicatorOpacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    indicatorOpacityAnimation.timingFunction = [
        CAMediaTimingFunction
        functionWithName:kCAMediaTimingFunctionEaseOut
    ];
    [indicator addAnimation:indicatorOpacityAnimation forKey:indicatorOpacityAnimation.keyPath];
    
    //Scale indicator
    CABasicAnimation* indicatorScaleAnimation = [
        CABasicAnimation
        animationWithKeyPath:@"transform.scale"
    ];
    indicatorScaleAnimation.duration = 0.25;
    indicatorScaleAnimation.repeatCount = 0;
    indicatorScaleAnimation.removedOnCompletion = NO;
    indicatorScaleAnimation.fillMode = kCAFillModeForwards;
    indicatorScaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    indicatorScaleAnimation.toValue = [NSNumber numberWithFloat:1.5];
    indicatorScaleAnimation.timingFunction = [
        CAMediaTimingFunction
        functionWithName:kCAMediaTimingFunctionEaseOut
    ];
    indicatorScaleAnimation.delegate = self;
    [indicator addAnimation:indicatorScaleAnimation forKey:indicatorScaleAnimation.keyPath];
    
    //Fade out circle
    CABasicAnimation* circleOpacityAnimation = [
        CABasicAnimation
        animationWithKeyPath:@"opacity"
    ];
    circleOpacityAnimation.duration = 0.25;
    circleOpacityAnimation.repeatCount = 0;
    circleOpacityAnimation.removedOnCompletion = NO;
    circleOpacityAnimation.fillMode = kCAFillModeForwards;
    circleOpacityAnimation.fromValue = [NSNumber numberWithFloat:0.25];
    circleOpacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    circleOpacityAnimation.timingFunction = [
        CAMediaTimingFunction
        functionWithName:kCAMediaTimingFunctionEaseOut
    ];
    [circle addAnimation:circleOpacityAnimation forKey:circleOpacityAnimation.keyPath];
    
    //Scale circle
    CABasicAnimation* circleScaleAnimation = [
        CABasicAnimation
        animationWithKeyPath:@"transform.scale"
    ];
    circleScaleAnimation.duration = 0.25;
    circleScaleAnimation.repeatCount = 0;
    circleScaleAnimation.removedOnCompletion = NO;
    circleScaleAnimation.fillMode = kCAFillModeForwards;
    circleScaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    circleScaleAnimation.toValue = [NSNumber numberWithFloat:0.5];
    circleScaleAnimation.timingFunction = [
        CAMediaTimingFunction
        functionWithName:kCAMediaTimingFunctionEaseOut
    ];
    circleScaleAnimation.delegate = self;
    [circleScaleAnimation setValue:@"circleShrink" forKey:@"animateLayer"];
    [circle addAnimation:circleScaleAnimation forKey:circleScaleAnimation.keyPath];
}

@end
