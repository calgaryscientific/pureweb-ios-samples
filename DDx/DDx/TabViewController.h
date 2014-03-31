//
//  TabViewController.h
//  DDxSample
//
//  Created by Chris Garrett on 4/11/12.
//  Copyright (c) 2012 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWNavigationController.h"
#import "MessageUI/MessageUI.h"

@interface TabViewController : UITabBarController <UITabBarControllerDelegate, 
                                                    PWNavigationControllerDelegate,
                                                    MFMailComposeViewControllerDelegate>
{
    NSString *_sharedURL;
    UIButton *_optionsButton;
    UIButton *_shareButton;
    UIAlertView *_sendingPingsView;
}

@property (nonatomic, strong) NSString *sharedURL;
@property (nonatomic, strong) UIButton *optionsButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIAlertView *sendingPingsView;

@end
