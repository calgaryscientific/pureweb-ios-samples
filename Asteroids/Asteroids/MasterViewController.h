//
//  MasterViewController.h
//  Asteroids
//
//  Created by Chris Burns on 3/17/14.
//  Copyright (c) 2014 Calgary Scientific Inc. All rights reserved.
//

#import <PureWeb/PureWeb.h>

@interface MasterViewController : UIViewController <PWWebClientDelegate>

- (void)setupWithAppURL:(NSURL *) appURL withRequiredAuthentication:(BOOL) authenticationRequired;
- (void)stop;

@end
