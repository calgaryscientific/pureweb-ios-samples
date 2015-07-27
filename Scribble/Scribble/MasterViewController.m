//  MasterViewController.m
//
//  Created by Chris Burns on 2/10/14.
//  Copyright 2014 Calgary Scientific Inc. All rights reserved.

#import "MasterViewController.h"

#import "LoginViewController.h"
#import "ScribbleViewController.h"

#import <PureWeb/PWLog.h>

@interface MasterViewController ()

@property (strong) NSURL *appURL;

@property () BOOL authenticationRequired;
@property () BOOL authenticationCompleted;

@property (strong) LoginViewController *loginViewController;

@end

@implementation MasterViewController

- (void) setupWithAppURL: (NSURL *) appURL withRequiredAuthentication:(BOOL) authenticationRequired
{
    //setup delegates for webclient and framework (these listen for changes in the pureweb session)
    PWFramework *framework = [PWFramework sharedInstance];
    framework.client.delegate = self;
    
    self.appURL = appURL;
    self.authenticationRequired = authenticationRequired;
    self.authenticationCompleted = NO;
}

- (void)stop {
    
    PWFramework *framework = [PWFramework sharedInstance];
    [framework.client disconnectSynchronous];
}

#pragma mark View Methods
- (void)viewDidAppear:(BOOL)animated
{
    //if authentication is required, then display the login view
    if (self.authenticationRequired && !self.authenticationCompleted) {
        
        //segue to login view
        [self performSegueWithIdentifier:@"PresentLoginView" sender:self];
    }
    
    //otherwise connect to pureweb immediately
    else if(!self.authenticationRequired) {
        
        PWFramework *framework = [PWFramework sharedInstance];
        if (!framework.client.isConnected){
            [framework.client connect:[self.appURL absoluteString]];
        }
        
        //segue directly to the scribble view
        [self performSegueWithIdentifier:@"PresentScribbleView" sender:self];
    }
    
    [super viewDidAppear:YES];
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[LoginViewController class]])
    {
        LoginViewController *incomingViewController = (LoginViewController *) segue.destinationViewController;
        
        incomingViewController.loginCredentialsReceived = ^(NSString *username, NSString *password) {
            
            PWFramework *framework = [PWFramework sharedInstance];
            
            PWBasicAuthorizationInfo  *authInfo = [PWBasicAuthorizationInfo basicAuthorizationWithName:username password:password];
            framework.client.authorizationInfo = authInfo;
            
            [framework.client connect:[self.appURL absoluteString]];
        };
        
        self.loginViewController = incomingViewController;
    }
}
#pragma mark PWWebClientDelegate Methods
- (void)connectedChanged {
    
    BOOL connected = [PWFramework sharedInstance].client.isConnected;
    
    if(connected) {
        PWLogInfo(@"Connected Successfully");
        self.authenticationCompleted = YES;
        
        //connection to pureweb succeeded, dismiss the login view and then transition to the scribble view
        [self dismissViewControllerAnimated:YES completion:^{
            
            self.loginViewController = nil;
            [self performSegueWithIdentifier:@"PresentScribbleView" sender:self];
        }];
    }
}

- (void)sessionStateChanged {

    switch ([PWFramework sharedInstance].client.sessionState)
    {
        case PWSessionStateFailed:
        {
            //the attempted session failed, this likely means the supplied credentials were invalid or the connection was lost
            NSString *message = [[PWFramework sharedInstance].client.acquireException description];
            PWLogError(@"Connection Failed With Error %@", message);
            
            //if the login view controller is currently presented then pass on the failure message
            if(self.loginViewController) {
                [self.loginViewController loginFailed];
            }
        }
            break;
        case PWSessionStateActive:
        case PWSessionStateUnknown:
        case PWSessionStateDisconnected:
        {
            
        }
        case PWSessionStateConnecting:
        case PWSessionStateStalled:
        case PWSessionStateTerminated:
        {
            
        }
            break;
    }
    
}

@end
