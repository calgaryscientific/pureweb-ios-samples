//
//  DDxView.m
//  DDxSample
//
//  Created by Chris Garrett on 12-04-12.
//  Copyright (c) 2012 Calgary Scientific Inc. All rights reserved.
//

#import "DDxView.h"

@interface DDxView ()
{
    NSString *_quality;
}

- (void)loadView;

@property (nonatomic, strong) NSNumber* imageCounter;
@property (nonatomic, strong) NSNumberFormatter* numberFormatter;

@end

@implementation DDxView

double timeLastUpdate = -1;
NSMutableArray *interUpdateTimes;
double cumInterUpdateTimes = 0;
double fps = 0;
double bandwidth;
double latency;

@synthesize showImageDetails = _showImageDetails;

- (id)initWithFramework:(PWFramework *)framework frame:(CGRect)frame
{
    if ((self = [super initWithFramework:framework frame:frame]))
    {
        [self loadView];
    }
    return self;
}


- (void)dealloc
{
    self.acetateToolset = nil;
}

- (void)loadView
{
    _quality = @"";
    
    _imageCounter = [NSNumber numberWithInt:0];
    _numberFormatter = [NSNumberFormatter new];
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 150, 200)];
    _textLabel.font = [UIFont systemFontOfSize:14.0];
    _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.numberOfLines = 0;
    _textLabel.userInteractionEnabled = NO;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.text = @"";
    [self addSubview:_textLabel];
    
    [self.viewUpdated addSubscriber:self action:@selector(viewWasUpdated:)];
    
    //add network stats
    [self.framework.client.latency.completedEvent  addSubscriber:self action:@selector(updateNetworkInformation)];
    [self setupFPSCounter];
}

- (void)viewWasUpdated:(PWViewUpdatedEventArgs *)args
{
    _quality = [args.encodingParameters objectForKey:@"EncodingQuality"];
    NSString* imgCounter = [args.encodingParameters objectForKey:@"imagecounter"];
    
    if (imgCounter)
    {
        NSNumber* count = [self.numberFormatter numberFromString:imgCounter];
        if (count.longLongValue < self.imageCounter.longLongValue)
        {
            NSString* reason = [NSString stringWithFormat:@"I need an adult! Images are coming in out of order! last img: %@ current img: %@", self.imageCounter, count];
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:reason
                                         userInfo:nil];
        }
        self.imageCounter = count;
    }
}

- (void)updateNetworkInformation {
    latency = self.framework.client.latency.duration;
    bandwidth = self.framework.client.mbps.rate;
}

- (void)setupFPSCounter {
    interUpdateTimes = [NSMutableArray array];
    [self.viewUpdated addSubscriber:self action:@selector(updateViewInformation)];
}

- (void)updateViewInformation {
    double now = [[NSDate date] timeIntervalSince1970]*1000;
    
    if (timeLastUpdate > 0) {
        double interUpdateTime = now - timeLastUpdate;
        timeLastUpdate = now;
        double numInterUpdateTimes = interUpdateTimes.count;
        
        if (numInterUpdateTimes == 100) {
            cumInterUpdateTimes = cumInterUpdateTimes - [interUpdateTimes[0] doubleValue];
            [interUpdateTimes removeObjectAtIndex:0];
        }
        
        cumInterUpdateTimes += interUpdateTime;
        NSNumber *tempNumber = [[NSNumber alloc] initWithDouble:interUpdateTime];
        [interUpdateTimes addObject:tempNumber];
        fps = 1000.0 / (cumInterUpdateTimes / numInterUpdateTimes);
    }
    
    timeLastUpdate = now;
}

- (NSString *)getTextWithDefault:(PWXmlElement *)element path:(NSString *)path defaultValue:(id)defaultValue
{
    id value = [element getText:path];
    if (value)
        return value;
    else 
        return defaultValue;
}

- (void)updateLabel:(PWValueChangedEventArgs *)args
{
    PWXmlElement *element = [[PWFramework sharedInstance].state.stateManager getTree:[NSString stringWithFormat:@"/DDx/%@/MouseEvent", self.viewName]];
    dispatch_async(dispatch_get_main_queue(), ^ {
        
        if (self.showImageDetails)
        {
            _textLabel.text = [NSString stringWithFormat:@"Type: %@\nChangedButton: %@\nButtons: %@\nModifiers: %@\nX: %@ Y:%@\nEncoding: %@\nQuality: %@\nMbps: %@\nPing: %@\nFps: %.3f",
                               [self getTextWithDefault:element path:@"Type" defaultValue:@""],
                               [self getTextWithDefault:element path:@"ChangedButton" defaultValue:@""],
                               [self getTextWithDefault:element path:@"Buttons" defaultValue:@""],
                               [self getTextWithDefault:element path:@"Modifiers" defaultValue:@""],
                               [self getTextWithDefault:element path:@"X" defaultValue:@""],
                               [self getTextWithDefault:element path:@"Y" defaultValue:@""],
                               self.encodingType ? self.encodingType.value : @"",
                               _quality,
                               bandwidth == 0 ? @"" : [NSString stringWithFormat:@"%.3f", bandwidth],
                               latency == 0 ? @"" : [NSString stringWithFormat:@"%.3f", latency],
                               fps];
        }
        else
        {
            _textLabel.text = [NSString stringWithFormat:@"Type: %@\nChangedButton: %@\nButtons: %@\nModifiers: %@\nX: %@ Y:%@",
                               [self getTextWithDefault:element path:@"Type" defaultValue:@""],
                               [self getTextWithDefault:element path:@"ChangedButton" defaultValue:@""],
                               [self getTextWithDefault:element path:@"Buttons" defaultValue:@""],
                               [self getTextWithDefault:element path:@"Modifiers" defaultValue:@""],
                               [self getTextWithDefault:element path:@"X" defaultValue:@""],
                               [self getTextWithDefault:element path:@"Y" defaultValue:@""]];
        }
    });
}

- (void)mouseEnter:(CGPoint)point
{
    self.acetateToolset.activeView = self;
    _lastInputPosition = point;
    [self queueMouseMove:0 modifiers:0 x:point.x y:point.y];
    [self queueMouseEnter:point.x y:point.y];
    [self queueMouseDown:PWMouseButtonsLeft modifiers:0 x:point.x y:point.y];
}

- (void)mouseLeave
{
    [self queueMouseUp:PWMouseButtonsLeft modifiers:0 x:_lastInputPosition.x y:_lastInputPosition.y];
    [self queueMouseLeave:_lastInputPosition.x y:_lastInputPosition.y];
}

- (void)mouseMove:(CGPoint)point
{
    _lastInputPosition = point;    
    [self queueMouseMove:PWMouseButtonsLeft modifiers:0 x:point.x y:point.y];
}

@end
