//  OptionsViewController.m
//
//  Created by Chris Burns on 2/10/14.
//  Copyright 2014 Calgary Scientific Inc. All rights reserved.

#import "OptionsViewController.h"

#import <PureWeb/PureWeb.h>

#import "DiagnosticViewDelegate.h"
@interface OptionsViewController ()

@property (strong, nonatomic) IBOutlet UISlider *interactiveQualitySlider;
@property (strong, nonatomic) IBOutlet UISlider *fullQualitySlider;


@end

@implementation OptionsViewController

- (PWMutableEncoderConfiguration *)encoderConfiguration
{
    return [DiagnosticViewDelegate sharedInstance].encoderConfiguration;
}


- (void)viewDidLoad
{
    [self setup];
    [super viewDidLoad];
}

- (void)setup {
    
    [self setupPickerView:self.interactiveMimeTypePickerView];
    [self setupPickerView:self.fullQualityMimeTypePickerView];
    
    //Setup the Default Options Using the Configuration
    self.interactiveQualitySlider.value = [self encoderConfiguration].interactiveQuality.quality;
    self.fullQualitySlider.value = [self encoderConfiguration].fullQuality.quality;
    
    NSInteger interactiveRow = [self indexOfMimeType:[self encoderConfiguration].interactiveQuality.mimeType];
    [self.interactiveMimeTypePickerView selectRow:interactiveRow inComponent:0 animated:NO];

    NSInteger fullQualityRow = [self indexOfMimeType:[self encoderConfiguration].fullQuality.mimeType];
    [self.fullQualityMimeTypePickerView selectRow:fullQualityRow inComponent:0 animated:NO];
    
    //Setup PureWeb Event Listeners to Listen for Service Side Updates
    [self.encoderConfiguration.interactiveQuality.changed addSubscriber:self action:@selector(interactiveQualityDidChange:)];
    [self.encoderConfiguration.fullQuality.changed addSubscriber:self action:@selector(fullQualityDidChange:)];
}

- (void)setupPickerView:(UIPickerView *) pickerView {
    
    pickerView.dataSource = self;
    pickerView.delegate = self;
}

- (IBAction)interactiveQualitySliderValueChanged:(UISlider *)sender {
    
    self.encoderConfiguration.interactiveQuality.quality = (NSInteger) sender.value;
    
}

- (IBAction)fullQualitySliderValueChanged:(UISlider *)sender {
    
    self.encoderConfiguration.fullQuality.quality = (NSInteger) sender.value;
}

- (void)interactiveMimeTypeValueChanged:(NSString *) updatedMimeType
{
    self.encoderConfiguration.interactiveQuality.mimeType = updatedMimeType;

}

- (void)fullQualityMimeTypeValueChanged:(NSString *) updatedMimeType
{
    self.encoderConfiguration.fullQuality.mimeType = updatedMimeType;
}

#pragma mark PW Delegates

- (void)interactiveQualityDidChange:(NSObject *)object
{
    NSInteger interactiveRow = [self indexOfMimeType:[self encoderConfiguration].interactiveQuality.mimeType];
    [self.interactiveMimeTypePickerView selectRow:interactiveRow inComponent:0 animated:NO];
    
    self.interactiveQualitySlider.value = self.encoderConfiguration.interactiveQuality.quality;
}
- (void)fullQualityDidChange:(NSObject *)object
{
    NSInteger fullQualityRow = [self indexOfMimeType:[self encoderConfiguration].fullQuality.mimeType];
    [self.fullQualityMimeTypePickerView selectRow:fullQualityRow inComponent:0 animated:NO];
    
    self.fullQualitySlider.value = self.encoderConfiguration.fullQuality.quality;
}


#pragma mark Picker View Data Source Delegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

#pragma mark Picker View Delegate
- (NSArray *)mimeTypes
{
    static NSArray *mimeTypes;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mimeTypes = @[kSupportedEncoderMimeTypeTiles, kSupportedEncoderMimeTypeJpeg, kSupportedEncoderMimeTypePng];
    });
    
    return mimeTypes;
}

- (NSString *)mimeTypeAtIndex:(NSInteger)index
{
    return [self.mimeTypes objectAtIndex:index];
}

- (NSInteger)indexOfMimeType:(NSString *)mimeType
{
    return [self.mimeTypes indexOfObject:mimeType];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self mimeTypeAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([pickerView isEqual:self.interactiveMimeTypePickerView]) {
        
        [self interactiveMimeTypeValueChanged:[self mimeTypeAtIndex:row]];
    }
    else {
        [self fullQualityMimeTypeValueChanged:[self mimeTypeAtIndex:row]];
    }
    
}


@end
