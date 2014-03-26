//
//  PWDiagnosticViewDelegate.m
//  DDxSample
//
//  Created by Sam Leitch on 2013-05-03.
//
//

#import "PWDiagnosticViewDelegate.h"

@implementation PWDiagnosticViewDelegate

- (id)init
{
    self = [super init];
    
    if(self)
    {
        _encoderConfiguration = [PWMutableEncoderConfiguration configurationWithInteractiveQuality:[PWMutableEncoderFormat formatWithMimeType:kSupportedEncoderMimeTypeTiles quality:30] fullQuality:[PWMutableEncoderFormat formatWithMimeType:kSupportedEncoderMimeTypeJpeg quality:70]];
        
    }
    
    return self;
}

+ (PWDiagnosticViewDelegate *)sharedInstance
{
    static PWDiagnosticViewDelegate *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PWDiagnosticViewDelegate alloc] init];
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
