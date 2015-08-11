//
//  PWLoginViewController.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PWLoginViewController.h"
#import "UIAlertView+PWUtils.h"
#import "NSString+PWUtils.h"
#import <PureWeb/PureWeb.h>

#define kSCROLL_FACTOR                  50
#define kSCROLL_FACTOR_IPAD             110

CGPoint offset;
CGRect scrollframe;

@interface PWLoginViewController ()

- (BOOL)isCollabSessionUrl:(NSURL *)url;
- (NSURL *)httpSchemeURL:(NSURL *)url;

@end

@implementation PWLoginViewController

#pragma mark -
#pragma mark Properties

@synthesize usernameLabel;
@synthesize usernameTextField;
@synthesize passwordLabel;
@synthesize passwordTextField;
@synthesize keyboardToolbar;
@synthesize logoImage;
@synthesize connectButton;
@synthesize scrollView;
@synthesize serverHref;

#pragma mark -
#pragma mark NSObject

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"-[%@ %@] not supported. Use initWithFramework:url", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    return nil;
}

- (id)initWithHref:(NSString *)href
{
    return [self initWithHref:href framework:nil];
}

- (id)initWithHref:(NSString *)href framework:(PWFramework *)framework
{
    if ((self = [super init]))
    {
        serverHref = href;
        _framework = framework ? framework : [PWFramework sharedInstance];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"PWLoginViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark UIView

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:self.view.window];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification 
                                                  object:nil];     
    
    self.connectButton = nil;
    self.logoImage = nil;
    self.usernameLabel = nil;
    self.usernameTextField = nil;
    self.passwordLabel = nil;
    self.passwordTextField = nil;
}

- (void) viewWillAppear:(BOOL)animated 
{    
    [super viewWillAppear:animated];

    self.title = @"Login";
    if (_framework.client.isConnected)
        [_framework.client disconnect];
    
    [self layoutView:self.interfaceOrientation];
    
    if ([self isCollabSessionUrl:[NSURL URLWithString:self.serverHref]])
    {
        self.usernameLabel.hidden = YES;
        self.usernameTextField.hidden = YES;
        self.passwordTextField.text = @"";
    }
    
    if ([self isAppSessionUrl:[NSURL URLWithString:self.serverHref]])
    {
        self.usernameLabel.hidden = YES;
        self.usernameTextField.hidden = YES;
        self.passwordLabel.hidden = YES;
        self.passwordTextField.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.title = @"Disconnect";
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];    
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark UIViewController

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#ifdef __IPHONE_6_0
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
#endif

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{
    [self layoutView:toInterfaceOrientation];
}

#pragma mark -
#pragma mark Layout

- (void)layoutView:(UIInterfaceOrientation)orientation
{
    // late initialization
    self.navigationItem.title = @"Login";
    
    usernameTextField.placeholder = @"Username";
    passwordTextField.placeholder = @"Password";
    
    usernameTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"pureweb_username"];
    passwordTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"pureweb_password"];  
    
    [self.connectButton removeFromSuperview];
    self.connectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.connectButton addTarget:self action:@selector(connectButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
    
    [self.view addSubview:self.connectButton];

        
    // Size and Position views here: 
    CGSize size = [PWUtility screenSize:orientation];
    
    self.scrollView.contentSize = CGSizeMake(size.width, 460);
    self.scrollView.frame       = CGRectMake(   0,   0, size.width, size.height);
    
    // using top left of the image as an offset for the rest of the controls
    CGPoint origin = CGPointMake((size.width-320)*.5, 0); 
    
    logoImage.frame             = CGRectMake(origin.x+  30, origin.y+  8, 256, 71);
    usernameLabel.frame         = CGRectMake(origin.x+ 76, origin.y+213, 126,  21);
    usernameTextField.frame     = CGRectMake(origin.x+ 76, origin.y+238, 167,  31);
    passwordLabel.frame         = CGRectMake(origin.x+ 76, origin.y+278, 126,  21);
    passwordTextField.frame     = CGRectMake(origin.x+ 76, origin.y+303, 167,  31);
    connectButton.frame         = CGRectMake(origin.x+119, origin.y+353,  81,  33);
}

#pragma mark -
#pragma mark Text / Keyboard

// There are two ways to connect to a collaboration session.
// Normally a share url is generated like so
// http://10.1.10.29/pureweb/share/72fb17ed-c43e-491a-9cad-86710ed50bc7
// When you click this link. The Pureweb server will redirect this url to a webpage where you can
// select between mobile and html5 as well as enter the share password.
// This will then redirect your mobile client and connect to your collaboration session via
// the connect api.
//
// To test using the joinSession api you can take the normal share url and replace the scheme
// with the name of the service like so
// ddx://10.1.10.29/pureweb/share/72fb17ed-c43e-491a-9cad-86710ed50bc7
// Paste this url into safari on your iOS device and it will switch to your app
// and connect to your collaboration session via the joinSession api

- (IBAction)connectButtonPushed:(id)sender
{
    NSString *username = [NSString trim:usernameTextField.text];
    NSString *password = [NSString trim:passwordTextField.text];

    NSURL* launchUrl = [NSURL URLWithString:self.serverHref];
    
    if ([self isCollabSessionUrl:launchUrl])
    {
        if ([password length] == 0)
        {
            [UIAlertView showAlert:@"Password field cannot be empty" message:@"Please enter a password"];
            return;
        }
        
        NSURL *newUrl = [self httpSchemeURL:[NSURL URLWithString:self.serverHref]];
        [_framework.client joinSession:[newUrl absoluteString] sharePassword:password];
    }
    else if ([self isAppSessionUrl:launchUrl])
    {
        [_framework.client connect:self.serverHref];            
    }
    else 
    {
        if ([username length] == 0)
        {
            [UIAlertView showAlert:@"Username field cannot be empty" message:@"Please enter a username"];
            return;
        }
        
        if ([password length] == 0)
        {
            [UIAlertView showAlert:@"Password field cannot be empty" message:@"Please enter a password"];
            return;
        }
        
        PWBasicAuthorizationInfo  *authInfo = [PWBasicAuthorizationInfo basicAuthorizationWithName:username password:password];
        _framework.client.authorizationInfo = authInfo;
        [_framework.client connect:self.serverHref];            
    }

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (IBAction)doneButtonePushed:(id)sender
{
    if ([usernameTextField isFirstResponder])
        [usernameTextField resignFirstResponder];
    else if ([passwordTextField isFirstResponder])
        [passwordTextField resignFirstResponder];
}

- (CGRect)detectResponder 
{
    CGRect frame = CGRectZero;
    if ([self.usernameTextField isFirstResponder]) 
        frame = self.usernameTextField.frame;
    if ([self.passwordTextField isFirstResponder]) 
        frame = self.passwordTextField.frame;
    return frame;
}    

- (void)keyboardWillShow:(NSNotification *)notification 
{    
    NSDictionary* info = [notification userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        keyboardSize = CGSizeMake(keyboardSize.height, keyboardSize.width);
    }
    
    offset = scrollView.contentOffset;
    scrollframe = scrollView.frame;
        
    // Get the duration of the animation.
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect viewFrame = scrollView.frame;
    viewFrame.size.height -= keyboardSize.height;
    scrollView.frame = viewFrame;
        
    CGRect textFieldRect = [self detectResponder];
    [scrollView scrollRectToVisible:textFieldRect animated:YES];

    [UIView commitAnimations];    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    scrollView.contentOffset = offset;
    scrollView.frame = scrollframe;
    
    [UIView commitAnimations];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!textField.inputAccessoryView)
    {
        textField.inputAccessoryView = keyboardToolbar;
    }
    
    return YES;
}

- (BOOL)isCollabSessionUrl:(NSURL *)url
{
    if([url.path rangeOfString:@"share"].location == NSNotFound)
        return NO;
    
    for (NSString *scheme in [PWUtility urlSchemes])
        if ([url.scheme isEqualToString:scheme])
            return YES;
    
    return NO;
}

- (BOOL)isAppSessionUrl:(NSURL *)url
{
    if([url.path rangeOfString:@"app"].location == NSNotFound)
        return NO;
    
    for (NSString *scheme in [PWUtility urlSchemes])
        if ([url.scheme isEqualToString:scheme])
            return YES;
    
    return NO;
}

- (NSURL *)httpSchemeURL:(NSURL *)url
{
    for (NSString *scheme in [PWUtility urlSchemes])
    {
        if ([url.scheme isEqualToString:scheme])
        {            
            NSString *path = [[url absoluteString] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://",scheme] 
                                                                             withString:@"http://"];
            return [NSURL URLWithString:path];
        }
    }

    return nil;
}

@end



