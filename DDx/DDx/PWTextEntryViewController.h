//
//  PWTextEntryViewController.h
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PWTextEntryViewControllerDelegate <NSObject>

- (void)textEntryDone:(NSString *)text;
- (void)textEntryCancel;

@end

@class PWApplicationState;

@interface PWTextEntryViewController : UIViewController 
{
    id <PWTextEntryViewControllerDelegate> __weak delegate;
    UITextField *colorTextField;
}

@property (nonatomic, weak) id <PWTextEntryViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITextField *colorTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
