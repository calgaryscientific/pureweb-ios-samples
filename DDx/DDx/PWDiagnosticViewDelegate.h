//
//  PWDiagnosticViewDelegate.h
//  DDxSample
//
//  Created by Sam Leitch on 2013-05-03.
//
//

#import <Foundation/Foundation.h>
#import "PWMutableEncoderConfiguration.h"
#import "PWViewDelegate.h"

@interface PWDiagnosticViewDelegate : NSObject <PWViewDelegate>

@property (strong, nonatomic, readonly) PWMutableEncoderConfiguration *encoderConfiguration;

+ (PWDiagnosticViewDelegate *)sharedInstance;

@end
