//
//  PWAppStateViewController.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PWAppStateViewController.h"
#import "PWAppStateView.h"

@implementation PWAppStateViewController

- (void)loadView { 
    PWAppStateView *appStView = [[PWAppStateView alloc] init];    
    [appStView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [appStView setMultipleTouchEnabled:YES];
    self.view = appStView;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
