//
//  AppDelegate.h
//  DDxSample
//
//  Created by Chris Garrett on 4/11/12.
//  Copyright (c) 2012 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWLoginViewController.h"
#import "PWNavigationController.h"
#import <PureWeb/PureWeb.h>

@class PWLoginViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, 
                                                 PWFrameworkDelegate, 
                                                 PWWebClientDelegate> 
{
    UIWindow    *window;
    NSURL       *_url;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet PWNavigationController *viewController;
@property (nonatomic, strong) NSURL *url;

@end

