//  OptionsViewController.h
//
//  Created by Chris Burns on 2/10/14.
//  Copyright 2014 Calgary Scientific Inc. All rights reserved.

#import <UIKit/UIKit.h>

@interface OptionsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIPickerView *interactiveMimeTypePickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *fullQualityMimeTypePickerView;


- (void)interactiveMimeTypeValueChanged:(NSString *) updatedMimeType;
- (void)fullQualityMimeTypeValueChanged:(NSString *) updatedMimeType;

@end
