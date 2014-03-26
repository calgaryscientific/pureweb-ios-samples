//
//  PGViewController.h
//  DDxSample
//
//  Created by Chris Garrett on 4/11/12.
//  Copyright (c) 2012 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWNavigationController.h"
#import "PGSettingsViewController.h"
#import "OptionsPanelDelegate.h"

@class DDxView;
@class PWTouchButtonView;

@interface PGViewController : UIViewController <PWNavigationControllerDelegate, PGSettingsViewControllerDelegate, OptionsPanelDelegate>
{
    DDxView *_pgView;
    PWTouchButtonView *_touchButton;
    UILabel *_encodingQuality;
}

@end
