//
//  PWTiming.h
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PWTimingDelegate <NSObject>

- (void)timerNetworkUpdated;
- (void)frameRateUpdated;

@end


@interface PWTiming : NSObject {
    float _imageSize;
    float _serverTime;
    float _latency;
    float _parsing;
    float _framerate;
    int   _hops;
    
    int _sentCount;
    float _sentBytes;
    int _recvCount;
    float _recvBytes;
    
    NSTimeInterval _startTime; // start of request->response loop
    NSTimeInterval _totalTime;  // total round trip time for last request->response
    NSDate *_timerNetwork; // @TODO: Rename this variable?
    id <PWTimingDelegate> __weak _delegate;
    
    
    // Timing members:
//    PerformanceArray *_reads;
//    PerformanceArray *_writes;
//    PerformanceArray *_tiles;
//    PerformanceArray *_mime; // mimeparsing
//    PerformanceArray *_extra;

//    FreakProfiler *__writes;
//    ElapsedTimeProfiler *_reads;
//    ElapsedTimeProfiler *_images;
}

//@property (nonatomic, readonly, retain) FreakProfiler *writes;
//@property (nonatomic, readonly, retain) ElapsedTimeProfiler *reads;
//@property (nonatomic, readonly, retain) ElapsedTimeProfiler *images;

//@property (nonatomic, readwrite, retain) PerformanceArray *extra;

//@property (nonatomic, readwrite, assign) float ImageSize;
//@property (nonatomic, readwrite, assign) float ServerTime;
//@property (nonatomic, readwrite, assign) float Latency;
//@property (nonatomic, readwrite, assign) float Parsing;
@property (nonatomic, readwrite, assign) float FrameRate;
//@property (nonatomic, readwrite, assign) int Hops;
@property (nonatomic, strong) NSDate *TimerNetwork;
@property (nonatomic, weak) id <PWTimingDelegate> delegate;

//@property (nonatomic, readwrite, assign) int sentCount;
//@property (nonatomic, readwrite, assign) float sentBytes;
//@property (nonatomic, readwrite, assign) int recvCount;
//@property (nonatomic, readwrite, assign) float recvBytes;
//@property (nonatomic, readwrite, assign) double totalTime;
//
//@property (nonatomic, readwrite, assign) double readingStart;
//@property (nonatomic, readwrite, assign) double readingTotal;
//@property (nonatomic, readwrite, assign) double writingStart;
//@property (nonatomic, readwrite, assign) double writingTotal;


+ (PWTiming *)sharedInstance;

- (NSString *)stringForImageSize;

- (NSString *)stringForServerTime;

- (NSString *)stringForFps;

- (NSString *)stringForLatency;

- (NSString *)stringForParsing;

- (NSString *)stringForHops;

- (NSString *)stringForSentCount;
- (NSString *)stringForSentBytes;
- (NSString *)stringForRecvCount;
- (NSString *)stringForRecvBytes;
- (NSString *)stringForTotalTime;
- (NSString *)stringForPerf;

//- (void)start;
//
//- (void)finish;

- (void)reset;

- (void)update;



//- (void)readingStarted;
//- (double)readingFinished;
//- (void)writingStarted;
//- (double)writingFinished;
//- (double)getAverageReadingTime;
//- (double)getAverageWritingTime;
//
//- (void)tileStarted;
//- (double)tileFinished;
//- (double)getAverageTileTime;
//
//- (void)mimeStarted;
//- (double)mimeFinished;
//- (double)getAverageMimeTime;
//
//- (void)sequenceStarted:(unsigned long)sequence value:(double)value;
//- (void)sequenceFinished:(unsigned long)sequence value:(double)value;
//- (double)sequenceAverage;

@end
