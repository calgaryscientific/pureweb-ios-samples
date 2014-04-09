//
//  PWDiagnosticsViewController.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PWDiagnosticViewController.h"
#import <PureWeb/PureWeb.h>

@implementation PWDiagnosticViewController

- (void)viewDidLoad 
{   
    [super viewDidLoad];
    
    PWTraceViewController *trace = [[PWTraceViewController alloc] init];
    [trace.tabBarItem setTitle:@"Trace"];
    [trace.tabBarItem setImage:[UIImage imageNamed:@"diagnosticsTrace.png"]];
 	
    PWOptionViewController *option = [[PWOptionViewController alloc] initWithNibName:@"PWOptionView" bundle:nil];
    [option.tabBarItem setTitle:@"Options"];
    [option.tabBarItem setImage:[UIImage imageNamed:@"diagnosticsOptions.png"]];
 	
    PWAppStateViewController *appState = [[PWAppStateViewController alloc] init];
    [appState.tabBarItem setTitle:@"App State"];
    [appState.tabBarItem setImage:[UIImage imageNamed:@"diagnosticsAppState.png"]];
    
    [self setViewControllers:[NSArray arrayWithObjects:trace, option, appState, nil]];
}


- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
