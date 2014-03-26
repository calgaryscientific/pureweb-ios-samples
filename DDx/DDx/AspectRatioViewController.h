//
//  AspectRatioViewController.h
//  DDxSample
//
//  Created by Chris Garrett on 4/11/12.
//  Copyright (c) 2012 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWNavigationController.h"

@class PWView;

@interface AspectRatioViewController : UIViewController <PWNavigationControllerDelegate>
{
    PWView *_aspectView;
}

@end
