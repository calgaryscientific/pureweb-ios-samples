//
//  DDxViewController.h
//  DDxSample
//
//  Created by Chris Garrett on 4/11/12.
//  Copyright (c) 2012 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWNavigationController.h"
#import "DDxSettingsViewController.h"
#import "OptionsPanelDelegate.h"

@class DDxView;
@class PWFramework;
@class PWAcetateToolset;

@interface DDxViewController : UIViewController <PWNavigationControllerDelegate, DDxSettingsViewControllerDelegate, OptionsPanelDelegate>
{
    NSMutableArray *_ddxViews;
    DDxView *_lastViewInput;
    CGRect _lastResize;
    __weak PWFramework *_framework;
    PWAcetateToolset     *_toolset;
}

@property (nonatomic, weak) PWFramework *framework;
@property (nonatomic, strong) PWAcetateToolset *toolset;

@end
