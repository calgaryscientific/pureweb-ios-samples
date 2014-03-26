//
//  PWLoginViewController.h
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWFramework;

@interface PWLoginViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UILabel            *usernameLabel;
    IBOutlet UITextField        *usernameTextField;
    IBOutlet UILabel            *passwordLabel;
    IBOutlet UITextField        *passwordTextField;
    IBOutlet UIToolbar          *keyboardToolbar;
    IBOutlet UIImageView        *logoImage;
    IBOutlet UIScrollView       *scrollView;
    IBOutlet UIButton           *connectButton;
    NSString                    *serverHref;
    __weak PWFramework          *_framework;
}

@property (nonatomic, strong) UILabel               *usernameLabel;
@property (nonatomic, strong) UITextField           *usernameTextField;
@property (nonatomic, strong) UILabel               *passwordLabel;
@property (nonatomic, strong) UITextField           *passwordTextField;
@property (nonatomic, strong) UIToolbar             *keyboardToolbar;
@property (nonatomic, strong) UIImageView           *logoImage;
@property (nonatomic, strong) UIScrollView          *scrollView;
@property (nonatomic, strong) UIButton              *connectButton;
@property (nonatomic, strong) NSString              *serverHref;

- (IBAction)doneButtonePushed:(id)sender;
- (IBAction)connectButtonPushed:(id)sender;

- (void)layoutView:(UIInterfaceOrientation)orientation;
- (id)initWithHref:(NSString *)href;
- (id)initWithHref:(NSString *)href framework:(PWFramework *)framework;

@end
