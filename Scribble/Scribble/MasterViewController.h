//  MasterViewController.h
//
//  Created by Chris Burns on 2/10/14.
//  Copyright 2014 Calgary Scientific Inc. All rights reserved.

#import <UIKit/UIKit.h>

#import <PureWeb/PureWeb.h>

@interface MasterViewController : UIViewController <PWWebClientDelegate>

- (void)setupWithAppURL:(NSURL *) appURL withRequiredAuthentication:(BOOL) authenticationRequired;
- (void)stop;

@end
