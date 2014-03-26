//
//  PGSettingsViewController.h
//  DDxSample
//
//  Created by Chris Garrett on 5/1/12.
//  Copyright (c) 2012 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWMutableEncoderConfiguration.h"
#import "PWViewDelegate.h"

@protocol PGSettingsViewControllerDelegate <NSObject>

- (void)doneWasPushed;
- (void)asyncImageGenerationDidChange:(BOOL)enabled;
- (void)useDeferredRenderingDidChange:(BOOL)enabled;
- (void)useClientSizeDidChange:(BOOL)enabled;
- (void)showMousePositionDidChange:(BOOL)enabled;
- (void)screenshotButtonTouchUpInside;
- (void)mimeTypeDidChange:(NSString *)mimeType;

@end

@interface PGSettingsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) id<PGSettingsViewControllerDelegate> delegate;
@property (nonatomic, strong) UISwitch *asyncImageGeneration;
@property (nonatomic, strong) UISwitch *useDeferredRendering;
@property (nonatomic, strong) UISwitch *useClientSize;
@property (nonatomic, strong) UISwitch *showMousePosition;
@property (nonatomic, strong) UIButton *screenshotButton;

@property (nonatomic, strong) NSString *selectedMimeType;

@end
