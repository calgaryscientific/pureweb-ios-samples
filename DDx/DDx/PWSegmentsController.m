//
//  PWSegmentsController.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PWSegmentsController.h"

@interface PWSegmentsController ()
@property (nonatomic, strong, readwrite) NSArray                * viewControllers;
@property (nonatomic, strong, readwrite) UINavigationController * navigationController;
@end

@implementation PWSegmentsController

@synthesize viewControllers, navigationController;

- (id)initWithNavigationController:(UINavigationController *)aNavigationController
                   viewControllers:(NSArray *)theViewControllers {
    if (self = [super init]) {
        self.navigationController   = aNavigationController;
        self.viewControllers = theViewControllers;
    }
    return self;
}

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)aSegmentedControl {
    NSUInteger index = aSegmentedControl.selectedSegmentIndex;
    UIViewController * incomingViewController = [self.viewControllers objectAtIndex:index];
    
    NSArray * theViewControllers = [NSArray arrayWithObject:incomingViewController];
    [self.navigationController setViewControllers:theViewControllers animated:NO];
    
    incomingViewController.navigationItem.titleView = aSegmentedControl;
}


@end
