//
//  PWTiming.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PWTiming.h"
#import "PWUtility.h"

#import <QuartzCore/QuartzCore.h>

@interface PWTiming ()

//@property (nonatomic, readwrite, retain) FreakProfiler *writes;
//@property (nonatomic, readwrite, retain) ElapsedTimeProfiler *reads;
//@property (nonatomic, readwrite, retain) ElapsedTimeProfiler *images;

@end

@implementation PWTiming
//@synthesize reads = _reads;
////@synthesize writes = __writes;
//@synthesize images = _images;

//@synthesize extra = _extra;
//@synthesize ImageSize = _imageSize;
//@synthesize ServerTime = _serverTime;
//@synthesize Latency = _latency;
//@synthesize Parsing = _parsing;
//@synthesize Hops = _hops;
@synthesize TimerNetwork = _timerNetwork;
@synthesize delegate = _delegate;

//@synthesize sentCount = _sentCount;
//@synthesize sentBytes = _sentBytes;
//@synthesize recvCount = _recvCount;
//@synthesize recvBytes = _recvBytes;
//@synthesize totalTime = _totalTime;

//@synthesize readingStart = _readingStart;
//@synthesize readingTotal = _readingTotal;
//@synthesize writingStart = _writingStart;
//@synthesize writingTotal = _writingTotal;

@dynamic FrameRate;

static PWTiming *sharedTimingInstance = nil;
//const static int kFloatingAverageSize = 10;

+ (PWTiming *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedTimingInstance==nil)
        {
            sharedTimingInstance = [[super allocWithZone:NULL] init];
        }
        return sharedTimingInstance;
    }
}

+ (id)allocWithZone:(NSZone *)zone 
{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone 
{
    return self;
}

- (id)init
{
    if ( self = [super init] )
    {
        [self reset];   
    }
    
    return self;
}

- (void)dealloc
{
//    [_images release];
//    [_reads release];
//    [__writes release];

    
//    [_extra release];
//    [_mime release];
//    [_tiles release];
//    [_reads release];
//    [_writes release];
    sharedTimingInstance = nil;
}

- (void)reset
{
    if (_timerNetwork != nil)
    {
        _timerNetwork = nil;
    }
    
    _imageSize = 0;
    _serverTime = 0;
    _latency = 0;
    _parsing = 0;
    _framerate = 30;
    _hops = -1;    
    _sentBytes = 0.0f;
    _sentCount = 0;
    _recvBytes = 0.0f;
    _recvCount = 0;
    _startTime = 0.0f;
    
//    [_reads release];
//    _reads = [[PerformanceArray alloc] initWithCapacity:kFloatingAverageSize];
//    [_writes release];
//    _writes = [[PerformanceArray alloc] initWithCapacity:kFloatingAverageSize];
//    [_tiles release];
//    _tiles = [[PerformanceArray alloc] initWithCapacity:kFloatingAverageSize];
//    [_mime release];
//    _mime = [[PerformanceArray alloc] initWithCapacity:kFloatingAverageSize];    
//    [_extra release];
//    _extra = [[PerformanceArray alloc] initWithCapacity:kFloatingAverageSize];  
    

//    self.reads = [[[ElapsedTimeProfiler alloc] init] autorelease];
//    self.images = [[[ElapsedTimeProfiler alloc] init] autorelease];
    

//    [_reads release];
//    _reads = [[ElapsedTimeProfiler alloc] init];
//    [_images release];
//    _images = [[ElapsedTimeProfiler alloc] init];
    
//    self.writes = [[FreakProfiler alloc] init];
}

- (float)FrameRate
{
    return _framerate;
}

- (void)setFrameRate:(float)framerate
{   
    _framerate = framerate;
    
    if (self.delegate != nil)
        [self.delegate frameRateUpdated];           
}

#pragma mark -
#pragma mark === Public Methods ===
#pragma mark

- (NSString *)stringForImageSize
{
    NSString *ret;
    if ( _imageSize == 0 )   
        ret = [[NSString alloc] initWithFormat:@"Net:-"];
    else                
        ret = [[NSString alloc] initWithFormat:@"Size:%0.1f KB", (float)(_imageSize / 1024.0)];

    return ret;
}

- (NSString *)stringForServerTime
{
    NSString *ret;
    if ( _serverTime == 0 )    
        ret = [[NSString alloc] initWithFormat:@"Server:-"];
    else
        ret = [[NSString alloc] initWithFormat:@"Server:%d ms", (int)(_serverTime * 1000.0)];
    
    return ret;
}

- (NSString *)stringForLatency
{
    NSString *ret;
    if ( _latency == 0 )
        ret = [[NSString alloc] initWithFormat:@"Latency:-"];
    else
        ret = [[NSString alloc] initWithFormat:@"Latency:%d ms", (int)(_latency * 1000.0)];
    
    return ret;
}

- (NSString *)stringForParsing
{
    NSString *ret;
    if ( _parsing == 0 )    
        ret = [[NSString alloc] initWithFormat:@"Parse:-"];
    else
        ret = [[NSString alloc] initWithFormat:@"Parse:%d ms", (int)(_parsing * 1000.0)];
    
    return ret;
}

- (NSString *)stringForFps
{
    NSString *ret;
    if ( _framerate == 0 ) 
        ret = [[NSString alloc] initWithFormat:@"Fps:-"];
    else
        ret = [[NSString alloc] initWithFormat:@"Fps:%d", (int)_framerate];
    
    return ret;
}

- (NSString *)stringForHops
{
    NSString *ret;
    if ( _hops == -1 )
    {
        ret = [[NSString alloc] initWithFormat:@"Hops:Firewalled"];     
    }
    else
    {
        ret = [[NSString alloc] initWithFormat:@"Hops:%d", _hops];
    }
    
    return ret;
}

//- (void)start
//{
//    if (_timerNetwork != nil)
//    {
//        [_timerNetwork release];
//        _timerNetwork = nil;
//    }
//
//    _timerNetwork = [[NSDate date] retain];
//    _startTime = CACurrentMediaTime();
//}

//- (void)finish
//{
//    NSTimeInterval timedNetwork = -[_timerNetwork timeIntervalSinceNow];
//
//    _totalTime=CACurrentMediaTime()-_startTime;
//    [self addRoundTripTime:_totalTime];
//    
//    _latency = (float)(timedNetwork - _serverTime);
//    LOG(@"Network(inc server):%0.3lfs(%0.2fKB)  Server:%0.3lfs  Latency:%0.3lfs  Parsing:%0.3lfs", 
//                                timedNetwork, (double)_imageSize/(double)1024.0, _serverTime, _latency, _parsing);
//             
//    [_timerNetwork release];
//    _timerNetwork = nil;
//    
//    if (self.delegate != nil)    
//        [self.delegate TimerNetworkUpdated];
//}

- (NSString *)stringForPerf
{
    return @"";
//    return [[[NSString alloc] initWithFormat:@"RW(%.0f/%.0f)\rCnt(%i/%i) Bytes(%.0f/%.0f)", 
//                                             ceil([_reads average]*1000.0f),ceil([_writes average]*1000.0f), 
//                                             _recvCount,_sentCount,
//                                             _recvBytes,_sentBytes] autorelease];
}

- (NSString *)stringForSentCount
{
    return [[NSString alloc] initWithFormat:@"Sent:%i", _sentCount];
}

- (NSString *)stringForSentBytes
{
    return [[NSString alloc] initWithFormat:@"SentBytes:%.0f", _sentBytes];
}

- (NSString *)stringForRecvCount
{
    return [[NSString alloc] initWithFormat:@"Recv:%i", _recvCount];
}

- (NSString *)stringForRecvBytes
{
    return [[NSString alloc] initWithFormat:@"RecvBytes:%.0f", _recvBytes];
}

- (NSString *)stringForTotalTime
{
    return [[NSString alloc] initWithFormat:@"RndTime:%.3f", _totalTime];
}

//- (void)readingStarted
//{
//    [_readsStarted addObject:[NSNumber numberWithDouble:[TimeStamp timestamp]]];
//}
//
//- (double)readingFinished
//{
//    [_readsFinished addObject:[NSNumber numberWithDouble:[TimeStamp timestamp]]];    
//    
//    double finished = 0.0f;
//    
//    if ([_readsFinished count] > 0 )
//    {
//        int index = [_readsFinished count]-1;    
//        finished = [_readsFinished objectAtIndex:index] - [_readsStarted objectAtIndex:index];
//    }
//    
//    if (self.delegate != nil)    
//        [self.delegate TimerNetworkUpdated];
//    
//    return finished;    
//    
//}
//
//- (void)writingStarted
//{
//    [_writesStarted addObject:[NSNumber numberWithDouble:[TimeStamp timestamp]]];
//}
//
//- (double)writingFinished
//{
//    [_writesFinished addObject:[NSNumber numberWithDouble:[TimeStamp timestamp]]];    
//    
//    double finished = 0.0f;
//    
//    if ([_writesFinished count] > 0 )
//    {
//        int index = [_writesFinished count]-1;    
//        finished = [_writesFinished objectAtIndex:index] - [_writesStarted objectAtIndex:index];
//    }
//    
//    if (self.delegate != nil)    
//        [self.delegate TimerNetworkUpdated];
//    
//    return finished;
//}
//
//- (double)getAverageReadingTime
//{
//    double sum = 0.0f;
//    
//    for (int i = 0; i < [_readsFinished count]; i++)
//        sum += [_readsFinished objectAtIndex:i] - [_readsStarted objectAtIndex:i];
//    
//    if (sum == 0.0f || [_readsFinished count] == 0)
//        return 0.0f;
//    
//    return ceil((sum / (double)[_readsFinished count])*1000.0f);  
//}
//
//- (double)getAverageWritingTime
//{
//    double sum = 0.0f;
//    
//    for (int i = 0; i < [_writesFinished count]; i++)
//        sum += [_writesFinished objectAtIndex:i] - [_writesStarted objectAtIndex:i];
//
//    if (sum == 0.0f || [_writesFinished count] == 0)
//        return 0.0f;
//    
//    return ceil((sum / (double)[_writesFinished count])*1000.0f);   
//}

//- (void)tileStarted
//{
//    [_tiles start];
//}
//
//- (double)tileFinished
//{
//    return [_tiles finish];
//}
//
//- (double)getAverageTileTime
//{
//    return [_tiles average];
//}

//- (void)mimeStarted
//{
//    [_mime start];
//}
//
//- (double)mimeFinished
//{
//    return [_mime finish];
//}
//
//- (double)getAverageMimeTime
//{
//    return [_mime average];
//}
//

//- (void)sequenceStarted:(unsigned long)sequence value:(double)value
//{
////    [_sequenceTimes setObject:[NSNumber numberWithDouble:[TimeStamp timestamp]] forKey:[NSNumber numberWithUnsignedInt:sequence]];
//}
//
//- (void)sequenceFinished:(unsigned long)sequence value:(double)value
//{
////    NSNumber *startTime = [_sequenceTimes objectForKey:[NSNumber numberWithUnsignedInt:sequence-1]];
////    if (startTime)
////    {
////        double diff = [TimeStamp timestamp]-[startTime floatValue];
////        [_sequences addValue:diff];
////        
////        // after some number of seq we should remove
////        // older ones from the dict
////    }
//}
//
//- (double)sequenceAverage
//{
//    return 0.0f; //[_sequences average];
//}

- (void)update
{
    if (self.delegate != nil)    
        [self.delegate timerNetworkUpdated];   
}

@end
