//
//  PWOptionViewController.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PWOptionViewController.h"
#import "PWDiagnosticViewDelegate.h"
#import <PureWeb/PWFramework.h>

@interface PWOptionViewController ()
@property (weak, nonatomic) PWMutableEncoderFormat *activeEncoderFormat;
@end

@implementation PWOptionViewController

- (PWMutableEncoderConfiguration *)encoderConfiguration
{
    return [PWDiagnosticViewDelegate sharedInstance].encoderConfiguration;
}

- (void)viewDidLoad
{
    [self.encoderConfiguration.interactiveQuality.changed addSubscriber:self action:@selector(interactiveQualityDidChange:)];
    [self.encoderConfiguration.fullQuality.changed addSubscriber:self action:@selector(fullQualityDidChange:)];
    PWEncoderConfiguration *config = [PWDiagnosticViewDelegate sharedInstance].encoderConfiguration;
    self.interactiveMimeTypeLabel.text = config.interactiveQuality.mimeType;
    self.interactiveQualitySlider.value = config.interactiveQuality.quality;
    self.fullMimeTypeLabel.text = config.fullQuality.mimeType;
    self.fullQualitySlider.value = config.fullQuality.quality;
} 

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setClientSideFilteringSwitch:nil];
    [self setInteractiveMimeTypeLabel:nil];
    [self setInteractiveQualitySlider:nil];
    [self setFullMimeTypeLabel:nil];
    [self setFullQualitySlider:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (IBAction)clientSideFilteringSwitchDidValueChanged:(id)sender
{
    BOOL enabled = self.clientSideFilteringSwitch.isOn;
    [[PWFramework sharedInstance].state.stateManager setAppStatePathWithValue:@"/PureWeb/ClientCommandFiltering" value:enabled?@"True":@"False"];
}

- (void)presentMimeTypePicker
{
    CGSize viewSize = self.view.bounds.size;
    UIPickerView *mimeTypePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, viewSize.height, 0, 0)];
    CGFloat width = viewSize.width;
    CGFloat height = mimeTypePicker.frame.size.height;
    CGFloat y = viewSize.height - height;
    
    mimeTypePicker.showsSelectionIndicator = TRUE;
    mimeTypePicker.delegate = self;
    mimeTypePicker.dataSource = self;
    [mimeTypePicker selectRow:[self indexOfMimeType:self.activeEncoderFormat.mimeType] inComponent:0 animated:NO];
    [self.view addSubview:mimeTypePicker];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    mimeTypePicker.frame = CGRectMake(0, y, width, height);
    [UIView commitAnimations];
}

- (void)removeMimeTypePicker:(UIPickerView *)mimeTypePicker
{
    CGSize viewSize = self.view.bounds.size;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    mimeTypePicker.frame = CGRectMake(0, viewSize.height, viewSize.width, 0);
    [UIView commitAnimations];
}

- (IBAction)interactiveMimeTypeButtonDidTouchUpInside:(id)sender
{
    self.activeEncoderFormat = self.encoderConfiguration.interactiveQuality;
    [self presentMimeTypePicker];
}

- (IBAction)interactiveQualitySliderDidValueChanged:(id)sender
{
    self.encoderConfiguration.interactiveQuality.quality = (NSInteger)self.interactiveQualitySlider.value;
}

- (void)interactiveQualityDidChange:(NSObject *)object
{
    self.interactiveMimeTypeLabel.text = self.encoderConfiguration.interactiveQuality.mimeType;
    self.interactiveQualitySlider.value = self.encoderConfiguration.interactiveQuality.quality;
}

- (IBAction)fullMimeTypeDidTouchUpInside:(id)sender
{
    self.activeEncoderFormat = self.encoderConfiguration.fullQuality;
    [self presentMimeTypePicker];
}

- (IBAction)fullQualitySliderDidValueChanged:(id)sender
{
    self.encoderConfiguration.fullQuality.quality = (NSInteger)self.fullQualitySlider.value;
}

- (void)fullQualityDidChange:(NSObject *)object
{
    self.fullMimeTypeLabel.text = self.encoderConfiguration.fullQuality.mimeType;
    self.fullQualitySlider.value = self.encoderConfiguration.fullQuality.quality;
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

#pragma mark -
#pragma mark UIPickerViewDelegate

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
    return [[self mimeTypes] objectAtIndex:index];
}

- (NSInteger)indexOfMimeType:(NSString *)mimeType
{
    return [[self mimeTypes] indexOfObject:mimeType];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self mimeTypeAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *mimeType = [self mimeTypeAtIndex:row];
    self.activeEncoderFormat.mimeType = mimeType;
    [self removeMimeTypePicker:pickerView];
}

@end
