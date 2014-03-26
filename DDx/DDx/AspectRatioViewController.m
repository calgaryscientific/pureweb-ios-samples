//
//  AspectRatioViewController.m
//  DDxSample
//
//  Created by Chris Garrett on 4/11/12.
//  Copyright (c) 2012 Calgary Scientific Inc. All rights reserved.
//

#import "AspectRatioViewController.h"
#import "PureWeb.h"

@interface AspectRatioViewController ()

@end

@implementation AspectRatioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIView *mainView = [UIView new];
    mainView.backgroundColor = [UIColor lightGrayColor];
    _aspectView = [[PWView alloc] initWithFramework:[PWFramework sharedInstance] frame:CGRectZero];
    _aspectView.viewName = @"DDx_OwnershipView";
    [mainView addSubview:_aspectView];
    self.view = _aspectView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWasPopped
{
    [_aspectView detachView];
}

#ifdef __IPHONE_6_0

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
#endif

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
