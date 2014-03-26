//
//  PWTimingView.h
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWTiming.h"

#define kTimingViewHeight 15

@interface PWTimingView : UIView <PWTimingDelegate>
{
    UILabel *_imageSizeLabel;
    UILabel *_serverLabel;
    UILabel *_latencyLabel;
    UILabel *_parsingLabel;
    UILabel *_fpsLabel;
    UILabel *_hopsLabel;
    
    UILabel *_requestAverageDurationLabel;
    UILabel *_requestsPerSecondLabel;
    UILabel *_requestCountLabel;
    UILabel *_requestBytesLabel;

    UILabel *_responseAverageDurationLabel;
    UILabel *_responsesPerSecondLabel;
    UILabel *_responseCountLabel;
    UILabel *_responseBytesLabel;
    
    UILabel *_tilingTimeLabel;
    UILabel *_mimeTimeLabel;
    PWTiming *_timing;
    
    BOOL _showStatistics;
}

@property (nonatomic, readwrite, assign) BOOL showStatistics;

- (UILabel *)addTextLabel:(CGFloat)x y:(CGFloat)y;
- (UILabel *)addTextLabel:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

@end
