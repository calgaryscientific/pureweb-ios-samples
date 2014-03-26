//
//  PWTraceViewController.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//


#import "PWTraceViewController.h"

@implementation PWTraceViewController

- (void)loadView {    
    PWTraceView *traceView = [[PWTraceView alloc] init];    
    [traceView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [traceView setMultipleTouchEnabled:YES];
    self.view = traceView;
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
