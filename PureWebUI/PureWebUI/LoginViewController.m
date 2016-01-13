//  LoginViewController.m
//
//  Created by Chris Burns on 2/10/14.
//  Copyright 2014 Calgary Scientific Inc. All rights reserved.

#import "LoginViewController.h"

#import <PureWeb/PureWeb.h>

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) IBOutlet UILabel *loginErrorLabel;
@property (strong, nonatomic) IBOutlet UIButton *connectButton;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [self loadCredentials];
    
    //setup delegates
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    [super viewDidLoad];
}


- (void)loadCredentials {
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //load the username and password from the settings
    self.usernameField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"pureweb_username"];
    self.passwordField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"pureweb_password"];
    
    [self loadCollaborationCredentials];
    
    //check if the settings should enable the button
    if(self.usernameField.text.length > 0 && self.passwordField.text.length > 0) {
        self.connectButton.enabled = YES;
    }
    else {
        
        self.connectButton.enabled = NO;
    }
}

- (void)loadCollaborationCredentials {
    //load the display name and email as well
    NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:@"pureweb_collab_name"];
    NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:@"pureweb_collab_email"];
    
    //only register these names with the collaboration manage if they are valid
    if (![name isEqualToString:@""]) {
        
        [[PWFramework sharedInstance].collaborationManager updateUserInfo:@"Name" value:name];
    }
    
    if (![email isEqualToString:@""]) {
        
        [[PWFramework sharedInstance].collaborationManager updateUserInfo:@"Email" value:email];
        
    }
}



- (void) loginFailed
{
    self.loginErrorLabel.text = [NSString stringWithFormat:@"Login Failed"];
    
}
- (IBAction)connectButtonPressed {

    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    self.loginCredentialsReceived(username, password);
}

- (IBAction)editingDidStart:(UITextField *)sender {
    
    self.loginErrorLabel.text = @"";
}
- (IBAction)editingChanged:(UITextField *)sender {
    
    if(self.usernameField.text.length > 0 && self.passwordField.text.length > 0) {
        self.connectButton.enabled = YES;
    }
    else {
        
        self.connectButton.enabled = NO;
    }
}

#pragma Text Field Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    
    return NO;
}



@end
