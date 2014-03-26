//
//  PWTimingView.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PWTimingView.h"

const double kSecond = 1000.0f;

@interface PWTimingView ()

- (void)UpdateLabels;


@end


@implementation PWTimingView

@dynamic showStatistics;

#define kWarningServer      0.100   //Milliseconds
#define kCriticalServer     0.150   //Milliseconds

#define kWarningLatency     0.200   //Milliseconds
#define kCriticalLatency    0.300   //Milliseconds

#define kWarningParsing     0.150   //Milliseconds
#define kCriticalParsing    0.250   //Milliseconds


#define kWarningOnScreenTime    4.0 //Seconds

#define kTopOffset 0


- (BOOL)showStatistics
{
    return _showStatistics;
}

- (void)setShowStatistics:(BOOL)value
{
    _showStatistics = value;
    
    _requestAverageDurationLabel.hidden = !_showStatistics;
    _requestsPerSecondLabel.hidden = !_showStatistics;
    _requestCountLabel.hidden = !_showStatistics;
    _requestBytesLabel.hidden = !_showStatistics;
    
    _responseAverageDurationLabel.hidden = !_showStatistics;
    _responsesPerSecondLabel.hidden = !_showStatistics;
    _responseCountLabel.hidden = !_showStatistics;
    _responseBytesLabel.hidden = !_showStatistics;
    
    _tilingTimeLabel.hidden = !_showStatistics; 
    _mimeTimeLabel.hidden = !_showStatistics;
    
    [self UpdateLabels];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // Initialization code
//        self.alpha = 0.99;
//        self.autoresizingMask = UIViewAutoresizingNone;
//        self.multipleTouchEnabled = YES;
//        self.hidden = YES;
        self.clearsContextBeforeDrawing = NO;
                
        [[PWTiming sharedInstance] reset];
        
//        _imageSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kTopOffset, 70, kTimingViewHeight)];
//        _imageSizeLabel.backgroundColor = [UIColor clearColor];
//        _imageSizeLabel.textColor = [UIColor whiteColor];
//        _imageSizeLabel.font = [UIFont fontWithName:@"Arial" size:11];
//        [self addSubview:_imageSizeLabel];
//        [_imageSizeLabel release];
//
//        _serverLabel    = [[UILabel alloc] initWithFrame:CGRectMake(80, kTopOffset, 70, kTimingViewHeight)];
//        _serverLabel.backgroundColor = [UIColor clearColor];
//        _serverLabel.textColor = [UIColor greenColor];
//        _serverLabel.font = [UIFont fontWithName:@"Arial" size:11];
//        [self addSubview:_serverLabel];
//        [_serverLabel release];
//
//        _latencyLabel   = [[UILabel alloc] initWithFrame:CGRectMake(150, kTopOffset, 80, kTimingViewHeight)];
//        _latencyLabel.backgroundColor = [UIColor clearColor];
//        _latencyLabel.textColor = [UIColor greenColor];
//        _latencyLabel.font = [UIFont fontWithName:@"Arial" size:11];
//        [self addSubview:_latencyLabel];
//        [_latencyLabel release];
//
//        _parsingLabel   = [[UILabel alloc] initWithFrame:CGRectMake(230, kTopOffset, 70, kTimingViewHeight)];
//        _parsingLabel.backgroundColor = [UIColor clearColor];
//        _parsingLabel.textColor = [UIColor greenColor];
//        _parsingLabel.font = [UIFont fontWithName:@"Arial" size:11];
//        [self addSubview:_parsingLabel];
//        [_parsingLabel release];
        
        _fpsLabel   = [[UILabel alloc] initWithFrame:CGRectMake(10, kTopOffset + kTimingViewHeight, 50, kTimingViewHeight)];
        _fpsLabel.backgroundColor = [UIColor clearColor];
        _fpsLabel.textColor = [UIColor whiteColor];
        _fpsLabel.font = [UIFont fontWithName:@"Arial" size:11];
        [self addSubview:_fpsLabel];
        
//        _hopsLabel  = [[UILabel alloc] initWithFrame:CGRectMake(60, kTopOffset + kTimingViewHeight, 100, kTimingViewHeight)];
//        _hopsLabel.backgroundColor = [UIColor clearColor];
//        _hopsLabel.textColor = [UIColor whiteColor];
//        _hopsLabel.font = [UIFont fontWithName:@"Arial" size:11];
//        [self addSubview:_hopsLabel];
//        [_hopsLabel release];
                
        // Performance labels:
        int offset = 2;
        _requestAverageDurationLabel = [self addTextLabel:10 y:kTopOffset + kTimingViewHeight * offset++];
        _requestsPerSecondLabel = [self addTextLabel:10 y:kTopOffset + kTimingViewHeight * offset++];
        _requestCountLabel = [self addTextLabel:10 y:kTopOffset + kTimingViewHeight * offset++];
        _requestBytesLabel = [self addTextLabel:10 y:kTopOffset + kTimingViewHeight * offset++];
        
        _responseAverageDurationLabel = [self addTextLabel:10 y:kTopOffset + kTimingViewHeight * offset++];
        _responsesPerSecondLabel = [self addTextLabel:10 y:kTopOffset + kTimingViewHeight * offset++];
        _responseCountLabel = [self addTextLabel:10 y:kTopOffset + kTimingViewHeight * offset++];
        _responseBytesLabel = [self addTextLabel:10 y:kTopOffset + kTimingViewHeight * offset++];        
        
        _tilingTimeLabel = [self addTextLabel:10 y:kTopOffset + kTimingViewHeight * offset++]; 
        _mimeTimeLabel = [self addTextLabel:10 y:kTopOffset + kTimingViewHeight * offset++];
        
        self.showStatistics = NO;
        
        _timing = [PWTiming sharedInstance];
        _timing.delegate = self;
    }
    return self;
}

- (UILabel *)addTextLabel:(CGFloat)x y:(CGFloat)y 
{
    return [self addTextLabel:x y:y width:150 height:kTimingViewHeight];
}

- (UILabel *)addTextLabel:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    lbl.backgroundColor = [UIColor blackColor];
    lbl.textColor = [UIColor greenColor];
    lbl.font = [UIFont fontWithName:@"Arial" size:11];
    [self addSubview:lbl];
    [self bringSubviewToFront:lbl];
    return lbl;
}

- (void)resetWarning:(UILabel *)label
{
    label.textColor = [UIColor greenColor];
}



- (void)warningCritical:(UILabel *)label
                  amount:(float)amount
        warningThreshold:(float)warningThreshold
       criticalThreshold:(float)criticalThreshold
              messageStr:(NSString *)messageStr
{
    if ( amount >= criticalThreshold )  
    {
        [[NSRunLoop currentRunLoop] cancelPerformSelector:@selector(resetWarning:) target:self argument:label];
        label.textColor = [UIColor redColor];
        label.text = messageStr;
        [self performSelector:@selector(resetWarning:) withObject:label afterDelay:kWarningOnScreenTime];
    }
    else if (( amount >= warningThreshold ) && ( label.textColor != [UIColor redColor] ))
    {
        [[NSRunLoop currentRunLoop] cancelPerformSelector:@selector(resetWarning:) target:self argument:label];
        label.textColor = [UIColor orangeColor];        
        label.text = messageStr;
        [self performSelector:@selector(resetWarning:) withObject:label afterDelay:kWarningOnScreenTime];
    }
    else if ( label.textColor == [UIColor greenColor] )
        label.text = messageStr;        
}


- (void)UpdateLabels
{
    if (!self.showStatistics) return;
    

    
//    _imageSizeLabel.text = [timing stringForImageSize];
//    _hopsLabel.text = [timing stringForHops];    
//    
//    _serverLabel.text = [timing stringForServerTime];
//    _latencyLabel.text = [timing stringForLatency];
//    _parsingLabel.text = [timing stringForParsing];     
    
    //_requestAverageDurationLabel.text = [NSString stringWithFormat:@"ReqAvgDur: %f", [_timing.writes average]];
//    _requestsPerSecondLabel.text = [NSString stringWithFormat:@"ReqPerSec: %.0f", 1000.0f/[timing getAverageWritingTime]];
//    _requestCountLabel.text = [NSString stringWithFormat:@"ReqCnt: %d", timing.sentCount];
//    _requestBytesLabel.text = [NSString stringWithFormat:@"ReqBytes: %.0f", timing.sentBytes];
//    
    
    //_responseAverageDurationLabel.text = [NSString stringWithFormat:@"ResAvgDur: %f", [_timing.reads average]*kSecond];
    
    //NSLog(@"%@", timing.reads);
    
//    _responsesPerSecondLabel.text = [NSString stringWithFormat:@"ResPerSec: %.0f", 1000.0f/[timing getAverageReadingTime]];
//    _responseCountLabel.text = [NSString stringWithFormat:@"ResCnt: %d", timing.recvCount];
//    _responseBytesLabel.text = [NSString stringWithFormat:@"ResBytes: %.0f", timing.recvBytes];       
//    
    //_tilingTimeLabel.text = [NSString stringWithFormat:@"Tile: %f", [_timing.images average]];
//    _mimeTimeLabel.text = [NSString stringWithFormat:@"Mime: %f", [timing sequenceAverage]];

    //@TODO: Removed the use of the warnCritical as this was causing some issues with the view.
    // We may want to revisit this view to polish up how the timing information is displayed
    
}

- (void)timerNetworkUpdated
{
    // We need to update the labels on the main UI thread
    [self UpdateLabels];
}


- (void)frameRateUpdated
{
    _fpsLabel.text = [_timing stringForFps];
}


- (void)dealloc {
    [_imageSizeLabel removeFromSuperview];
    [_serverLabel removeFromSuperview];
    [_latencyLabel removeFromSuperview];
    [_parsingLabel removeFromSuperview];
    [_fpsLabel removeFromSuperview];
    [_hopsLabel removeFromSuperview];
}

@end
