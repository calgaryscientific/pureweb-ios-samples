//
//  PWSegmentsController.h
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWSegmentsController : NSObject {
    NSArray                * viewControllers;
    UINavigationController * navigationController;
}

@property (nonatomic, strong, readonly) NSArray                * viewControllers;
@property (nonatomic, strong, readonly) UINavigationController * navigationController;

- (id)initWithNavigationController:(UINavigationController *)aNavigationController
                   viewControllers:(NSArray *)viewControllers;

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)aSegmentedControl;

@end
