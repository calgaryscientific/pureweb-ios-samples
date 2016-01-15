//
//  PWOptionViewController.h
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PureWeb/PWMutableEncoderConfiguration.h>

@class PWApplicationState;

@interface PWOptionViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic, readonly) PWMutableEncoderConfiguration *encoderConfiguration;

@property (strong, nonatomic) IBOutlet UISwitch *clientSideFilteringSwitch;
- (IBAction)clientSideFilteringSwitchDidValueChanged:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *interactiveMimeTypeLabel;
@property (strong, nonatomic) IBOutlet UISlider *interactiveQualitySlider;

- (IBAction)interactiveMimeTypeButtonDidTouchUpInside:(id)sender;
- (IBAction)interactiveQualitySliderDidValueChanged:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *fullMimeTypeLabel;
@property (strong, nonatomic) IBOutlet UISlider *fullQualitySlider;

- (IBAction)fullMimeTypeDidTouchUpInside:(id)sender;
- (IBAction)fullQualitySliderDidValueChanged:(id)sender;

@end
