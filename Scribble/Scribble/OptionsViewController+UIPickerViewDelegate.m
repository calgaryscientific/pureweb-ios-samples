//  OptionsViewController+UIPickerViewDelegate.m
//
//  Created by Chris Burns on 2/10/14.
//  Copyright 2014 Calgary Scientific Inc. All rights reserved.

#import "OptionsViewController+UIPickerViewDelegate.h"
#import "PWEncoderFormat.h"

@implementation OptionsViewController (UIPickerViewDelegate)


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
