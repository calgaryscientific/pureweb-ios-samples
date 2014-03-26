//
//  DDxSettingsViewController.h
//  DDxSample
//
//  Created by Chris Garrett on 5/1/12.
//  Copyright (c) 2012 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDxSettingsViewControllerDelegate <NSObject>

- (void)gridEnabledDidChange:(BOOL)enabled;
- (void)gridSizeDidChange:(CGFloat)size;
- (void)inputTransmissionDidChange:(BOOL)enabled;
- (void)clearWasPushed;
- (void)doneWasPushed;

@end

@interface DDxSettingsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISwitch *enabled;
@property (nonatomic, strong) UISlider *gridSize;
@property (nonatomic, strong) UISwitch *inputTransmission;
@property (nonatomic, assign) id<DDxSettingsViewControllerDelegate> delegate;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

@end
