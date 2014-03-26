//
//  UIAlertView+PWUtils.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import "UIAlertView+PWUtils.h"


@implementation UIAlertView (PWUtils)

+ (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
