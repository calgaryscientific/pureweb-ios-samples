//
//  TabViewController.m
//  DDxSample
//
//  Created by Chris Garrett on 4/11/12.
//  Copyright (c) 2012 Calgary Scientific Inc. All rights reserved.
//

#import "TabViewController.h"
#import "PWNavigationButtonCollectionView.h"
#import "PureWeb.h"
#import "UIAlertView+PWUtils.h"
#import "OptionsPanelDelegate.h"
#import "PWCommandResponseEventArgs.h"
#import "PWDiagnosticViewController.h"
#import "PWLog.h"
#import "DDxServerServicePing.h"
#import "DDxRoundtripPing.h"
#import "DiagnosticsViewController.h"

@interface TabViewController ()

@property (strong) PWNavigationButtonCollectionView *navigationCollection;
@property (strong) UISegmentedControl *serviceServerPingButton;
@property (strong) UISegmentedControl *roundtripPingButton;
@property (strong) UIButton *invalidateShareButton;

@property (strong) DDxServerServicePing *serviceServerPing;
@property (strong) DDxRoundtripPing *roundtripPing;
@end

@implementation TabViewController

@synthesize sharedURL = _sharedURL;
@synthesize optionsButton = _optionsButton;
@synthesize shareButton = _shareButton;
@synthesize sendingPingsView = _sendingPingsView; 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)dealloc {
    self.delegate = nil;
}

- (void) viewDidAppear:(BOOL)animated {
    
    [self.navigationCollection inspect];
    
}
- (void)viewDidLoad {
    
    // Navigation buttons (top right)
    self.navigationCollection = [[PWNavigationButtonCollectionView alloc] init];
    self.navigationCollection.buttonWidth = 100;
    self.invalidateShareButton = [self.navigationCollection addButtonWithImage:[UIImage imageNamed:@"invalidate-persons-small"] target:self action:@selector(invalidateButtonPressed:)];
    self.shareButton = [self.navigationCollection addButtonWithImage:[UIImage imageNamed:@"persons"] target:self action:@selector(shareButtonPushed:)];
    self.optionsButton = [self.navigationCollection addButtonWithImage:[UIImage imageNamed:@"gear"] target:self action:@selector(optionsButtonPushed:)];
    self.roundtripPingButton = [self.navigationCollection addButtonWithTitle:@"Roundtrip" target:self action:@selector(roundtripPingButtonPressed:)];
    self.serviceServerPingButton = [self.navigationCollection addButtonWithTitle:@"Service Server" target:self action:@selector(servicePingButtonPressed:)];
    [self.navigationCollection addButtonWithTitle:@"Diagnostics" target:self action:@selector(diagnosticsButtonPushed:)];
    

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navigationCollection];

    self.invalidateShareButton.hidden = YES;

    [super viewDidLoad];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)viewWasPopped {
    for (UIViewController *v in self.viewControllers)
        if ([v respondsToSelector:@selector(viewWasPopped)])
            [(id<PWNavigationControllerDelegate>)v viewWasPopped];
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    [super setViewControllers:viewControllers animated:animated];
    [self hideOptionsButtonForViewController:[self.viewControllers objectAtIndex:0]];
}

- (void)shareButtonPushed:(id)sender {
    //if the share is active (i.e. already got and not invalidated) then we simply show the mail window, otherwise we need to get the share url
    
    if (self.sharedURL) {
        
        [self presentMailControllerWithURL:self.sharedURL];
        
    }
    
    else {
        
        PWWebClient *client = [[PWFramework sharedInstance] client];
        
        [client getSessionShareUrlAsyncWithPassword:@"Scientific"
                                    shareDescriptor:@""
                                       shareTimeout:1800000
                                             target:self
                                             action:@selector(getSessionShareUrlAsyncDidFinish:)];
    }
}

- (void)getSessionShareUrlAsyncDidFinish:(PWServiceRequestCompletedEventArgs *)args {
    
    if (args.request.status == PWServiceRequestStatusSuccess) {
        PWAppShare *appShare = (PWAppShare *)args.request;        
        self.sharedURL = [appShare shareUrl];
        
        [self presentMailControllerWithURL:self.sharedURL];
        
        self.invalidateShareButton.hidden = NO;
    }
    else {
        [UIAlertView showAlert:@"There was an error while creating the application share" 
                       message:[args.request.error description]];
    }
}


- (void) presentMailControllerWithURL:(NSString *) sharedURL {
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    if (mailController != nil) {
        mailController.navigationBar.tintColor = [UIColor darkGrayColor];
        mailController.mailComposeDelegate = self;
        [mailController setSubject:@"Please join my shared PureWeb session."];
        [mailController setMessageBody:sharedURL isHTML:NO];
        
        [self presentViewController:mailController animated:YES completion:^{
            
        }];
    }
}

- (void) invalidateButtonPressed:(id) sender {
    
    
    PWWebClient *client = [[PWFramework sharedInstance] client];
    
    [client invalidateSessionShareUrlAsync:self.sharedURL
                                    target:self
                                    action:@selector(invalidateShareUrlDidFinish:)];
    
    
    
    
}

- (void)invalidateShareUrlDidFinish:(PWServiceRequestCompletedEventArgs *)args {
    
    if (args.request.status == PWServiceRequestStatusSuccess) {
        self.sharedURL = nil;
        self.invalidateShareButton.hidden = YES;

        
        [UIAlertView showAlert:@"Share Session Deleted" 
                       message:@"The share url has been successfully deleted"];
    }
    else {
        [UIAlertView showAlert:@"There was an error while invalidating the application share" 
                       message:[args.request.error description]];
    }
}

- (void)diagnosticsButtonPushed:(id)sender {
    
    NSString *diagnosticsStoryboardName;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        diagnosticsStoryboardName = @"Diagnostics_iPad";
        
    }
    else {
        
        diagnosticsStoryboardName = @"Diagnostics_iPhone";
        
    }
    
    //load the storyboard which contains the update diagnostics view (we have to do this because the old diagnostics panel is broke under iOS 7)
    UIStoryboard *diagnosticsBoard = [UIStoryboard storyboardWithName:diagnosticsStoryboardName bundle:nil];
    DiagnosticsViewController *dvc = [diagnosticsBoard instantiateViewControllerWithIdentifier:@"DiagnosticsViewController"];
    
    [self presentViewController:dvc animated:YES completion:^{
        
        NSLog(@"Diagnostics Loaded");
    }];
}

- (void)optionsButtonPushed:(id)sender {
    if ([self.selectedViewController conformsToProtocol:@protocol(OptionsPanelDelegate)]) {
        [(id<OptionsPanelDelegate>)self.selectedViewController didRequestOptionsPanel];
    }
}

#pragma mark - Ping Stuff
- (void) startPing {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.sendingPingsView = [[UIAlertView alloc] initWithTitle:@"Sending Pings" message:@"Please Wait..." delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    [self.sendingPingsView show];
    [self.sendingPingsView addSubview:spinner];
    spinner.center = CGPointMake(self.sendingPingsView.bounds.size.width / 2, self.sendingPingsView.bounds.size.height - 50);
    [spinner startAnimating];
    
}

- (void)roundtripPingButtonPressed:(id)sender {
    [self startPing];
    
    self.roundtripPing = [DDxRoundtripPing new];
    
    [self.roundtripPing ping:^(int numPings, double average, NSArray *times) {
        
        [self showPingResults:@"Roundtrip Ping" totalPings:numPings withAverageTime:average];
        self.roundtripPing = nil;
    }];
    
}

- (void)servicePingButtonPressed:(id) sender {
    [self startPing];
    
    self.serviceServerPing = [DDxServerServicePing new];
    
    [self.serviceServerPing ping:^(int numPings, double average, NSArray *times) {
        
        [self showPingResults:@"Service Server Ping" totalPings:numPings withAverageTime:average];
        self.serviceServerPing = nil;
    }];

}


- (void) showPingResults:(NSString *) pingType totalPings: (NSInteger) numPings withAverageTime: (double) pingAverage {
    
    [self.sendingPingsView dismissWithClickedButtonIndex:0 animated:NO];
    self.sendingPingsView = nil;
    
    NSString *message = [NSString stringWithFormat:@"%@\nTotal Pings: %d\nAverage: %.2fms",
                         pingType,
                         numPings,
                         pingAverage];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ping Results"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)hideOptionsButtonForViewController:(UIViewController *)viewController {
    self.optionsButton.hidden = ![viewController conformsToProtocol:@protocol(OptionsPanelDelegate)];
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error  {
    if (!result == MFMailComposeResultSent) {
        [UIAlertView showAlert:@"Failed to send email!" message:[error localizedDescription] ];

    }
    
    [self becomeFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -
#pragma mark UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self hideOptionsButtonForViewController:viewController];
}

@end
