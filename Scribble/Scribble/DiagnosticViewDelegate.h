//  DiagnosticsViewController.h
//
//  Created by Chris Burns on 2/10/14.
//  Copyright 2014 Calgary Scientific Inc. All rights reserved.

#import <Foundation/Foundation.h>
#import "PWMutableEncoderConfiguration.h"
#import "PWViewDelegate.h"

@interface DiagnosticViewDelegate : NSObject <PWViewDelegate>

@property (strong, nonatomic, readonly) PWMutableEncoderConfiguration *encoderConfiguration;

+ (DiagnosticViewDelegate *)sharedInstance;

@end
