//  DiagnosticsViewController.m
//
//  Created by Chris Burns on 2/10/14.
//  Copyright 2014 Calgary Scientific Inc. All rights reserved.

#import "DiagnosticViewDelegate.h"

@implementation DiagnosticViewDelegate

- (id)init
{
    self = [super init];
    
    if(self)
    {
        _encoderConfiguration = [PWMutableEncoderConfiguration configurationWithInteractiveQuality:[PWMutableEncoderFormat formatWithMimeType:kSupportedEncoderMimeTypeTiles quality:30] fullQuality:[PWMutableEncoderFormat formatWithMimeType:kSupportedEncoderMimeTypeJpeg quality:70]];
        
    }
    
    return self;
}

+ (DiagnosticViewDelegate *)sharedInstance
{
    static DiagnosticViewDelegate *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DiagnosticViewDelegate alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark -
#pragma mark PWViewDelegate

- (PWEncoderConfiguration *)preferredEncoderConfigurationForView:(PWView *)view
{
    return self.encoderConfiguration;
}

@end
