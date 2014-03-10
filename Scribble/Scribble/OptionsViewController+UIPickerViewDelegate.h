//  OptionsViewController+UIPickerViewDelegate.h
//
//  Created by Chris Burns on 2/10/14.
//  Copyright 2014 Calgary Scientific Inc. All rights reserved.

#import "OptionsViewController.h"

@interface OptionsViewController (UIPickerViewDelegate) <UIPickerViewDelegate>
- (NSInteger)indexOfMimeType:(NSString *)mimeType;
- (NSString *)mimeTypeAtIndex:(NSInteger)index;
@end
