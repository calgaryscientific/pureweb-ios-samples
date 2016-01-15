//
//  PWTextEntryViewController.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PWTextEntryViewController.h"
#import <PureWeb/PWFramework.h>


@implementation PWTextEntryViewController

@synthesize delegate;
@synthesize colorTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
    }
    return self;                
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    // Configure the navigation bar    
    self.navigationItem.title = @"Enter Color";
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    
    // Set the text to the color that is currently stored in the app state.
    colorTextField.text = [[PWFramework sharedInstance].state getValueWithAppStatePath:@"/ScribbleColor"];
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;    
    
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];    
    self.navigationItem.rightBarButtonItem = doneButtonItem;    
        
    [colorTextField becomeFirstResponder];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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



#pragma mark -
#pragma mark === Navigation Button selectors  ===
#pragma mark

- (void)done 
{
    [self.delegate textEntryDone:colorTextField.text];
}

-(void)cancel
{
    [self.delegate textEntryCancel];
}

@end
