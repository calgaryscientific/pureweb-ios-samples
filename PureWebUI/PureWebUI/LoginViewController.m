//  LoginViewController.m
//
//  Created by Chris Burns on 2/10/14.
//  Copyright 2014 Calgary Scientific Inc. All rights reserved.

#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) IBOutlet UILabel *loginErrorLabel;
@property (strong, nonatomic) IBOutlet UIButton *connectButton;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    self.usernameField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"pureweb_username"];
    self.passwordField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"pureweb_password"];
    
    if(self.usernameField.text.length > 0 && self.passwordField.text.length > 0) {
        self.connectButton.enabled = YES;
    }
    else {
        
        self.connectButton.enabled = NO;
    }
    
    //setup delegates
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;

    
    [super viewDidLoad];
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

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    
    return NO;
}



@end
