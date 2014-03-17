//  LoginViewController.h
//
//  Created by Chris Burns on 2/10/14.
//  Copyright 2014 Calgary Scientific Inc. All rights reserved.

#import <UIKit/UIKit.h>

typedef void(^PWUsernameAndPasswordCaptured)(NSString *username, NSString *password);

@interface LoginViewController : UIViewController

- (void) loginFailed;

@property (strong) PWUsernameAndPasswordCaptured loginCredentialsReceived;

@end
