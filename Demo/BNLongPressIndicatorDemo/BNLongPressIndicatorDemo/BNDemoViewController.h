//
//  BNDemoViewController.h
//  BNLongPressIndicatorDemo
//
//  Created by Aaron Ritchie on 2013-05-15.
//  Copyright (c) 2013 BNOTIONS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNLongPressIndicator.h"

@interface BNDemoViewController : UIViewController
{
    BNLongPressIndicator* longPressIndicator;
}

@property (strong) BNLongPressIndicator* longPressIndicator;

- (void)didRecognizeGesture:(BNLongPressIndicator*)gesture;

@end
