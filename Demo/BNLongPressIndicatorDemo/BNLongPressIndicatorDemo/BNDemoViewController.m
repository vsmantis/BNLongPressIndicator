//
//  BNDemoViewController.m
//  BNLongPressIndicatorDemo
//
//  Created by Aaron Ritchie on 2013-05-15.
//  Copyright (c) 2013 BNOTIONS. All rights reserved.
//

#import "BNDemoViewController.h"

@implementation BNDemoViewController

@synthesize longPressIndicator;

- (id)init
{
    NSString* xibType = nil;
    
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        xibType = @"iPhone";

    else
        xibType = @"iPad";
    
    NSString* xibName = [NSString stringWithFormat:@"%@-%@", self.class.description, xibType];
    
    if (self = [super initWithNibName:xibName bundle:nil])
    {
        longPressIndicator = [
            [BNLongPressIndicator alloc]
            initWithTarget:self
            action:@selector(didRecognizeGesture:)
        ];
        
        longPressIndicator.requiredDuration = 1.0;
        
        [self.view addGestureRecognizer:longPressIndicator];
    }
    return self;
}

- (void)didRecognizeGesture:(BNLongPressIndicator*)gesture
{
    //Perform action
}

@end
