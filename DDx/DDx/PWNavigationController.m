//
//  PWNavigationController.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PWNavigationController.h"


@implementation PWNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    if ((self = [super initWithRootViewController:rootViewController]))
    {
        if ([rootViewController respondsToSelector:@selector(viewWasPushed)])
            [(UIViewController<PWNavigationControllerDelegate> *)rootViewController viewWasPushed];
    }
    return self;
}



- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    if ([self.viewControllers count] > 1 && self.topViewController.presentedViewController)
    {
        [self.topViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
    NSArray *poppedViewControllers = [super popToRootViewControllerAnimated:animated];
    
    for (UIViewController *viewController in poppedViewControllers)
    {
        if ([viewController respondsToSelector:@selector(viewWasPopped)])
            [(UIViewController<PWNavigationControllerDelegate> *)viewController viewWasPopped];            
    }
    return poppedViewControllers;
}



- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.topViewController != viewController && self.topViewController.presentedViewController)
        [self.topViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    
    NSArray *poppedViewControllers = [super popToRootViewControllerAnimated:animated];
    
    for (UIViewController *viewController in poppedViewControllers)
    {
        if ([viewController respondsToSelector:@selector(viewWasPopped)])
            [(UIViewController<PWNavigationControllerDelegate> *)viewController viewWasPopped];
    }
    return poppedViewControllers;
}



- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (self.topViewController.presentedViewController)
        [self.topViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    
    if ([viewController respondsToSelector:@selector(viewWasPopped)])
        [(UIViewController<PWNavigationControllerDelegate> *)viewController viewWasPopped];

    return viewController;
}



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    if ([viewController respondsToSelector:@selector(viewWasPopped)])
        [(UIViewController<PWNavigationControllerDelegate> *)viewController viewWasPushed];
}

@end
