//
//  PWProfilerView.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PWProfilerView.h"
#import <QuartzCore/QuartzCore.h>



float const kLabelOffset = 5;
float const kLabelHeight = 30;
float const kLabelWidth = 110;



@interface PWProfilerView ()

- (UILabel *)addLabel;
- (NSString *)paddedLabel:(NSString *)title value:(NSString *)value;

- (void)onConnectedChanged;
- (void)onMbpsChanged:(PWValueChangedEventArgs *)args;
- (void)onRequestsChanged:(PWValueChangedEventArgs *)args;
- (void)onResponsesChanged:(PWValueChangedEventArgs *)args;
- (void)onHandlersChanged:(PWValueChangedEventArgs *)args;
- (void)onFpsChanged:(PWValueChangedEventArgs *)args;

@end



@implementation PWProfilerView

#pragma mark -
#pragma mark === Ctor/Dtor ===
#pragma mark

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFramework:nil frame:frame view:nil];
}

- (id)initWithFramework:(PWFramework *)framework view:(PWView *)view
{
    return [self initWithFramework:framework frame:CGRectZero view:view];
}


- (id)initWithFramework:(PWFramework *)framework frame:(CGRect)frame view:(PWView *)view
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        if (framework == nil)
            _framework = [PWFramework sharedInstance];
        else
            _framework = framework;        
        _view = view;
        
//        self.layer.borderColor = [UIColor yellowColor].CGColor;
//        self.layer.borderWidth = 1;
        _mbps = [self addLabel];
        _requestFreq = [self addLabel];
        _responseFreq = [self addLabel];
        _handlersFreq = [self addLabel];
        _viewFps = [self addLabel];
        
        [_framework.client.isConnectedChanged addSubscriber:self action:@selector(onConnectedChanged)];
        [self onConnectedChanged];
    }
    return self;
}

- (void)dealloc
{
    [_framework.client.isConnectedChanged removeSubscriber:self action:@selector(onConnectedChanged)];    
}

#pragma mark -
#pragma mark === Privates ===
#pragma mark

- (UILabel *)addLabel
{
    float y = self.subviews.count*kLabelHeight;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, kLabelWidth+kLabelOffset, (self.subviews.count+1)*kLabelHeight);
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(kLabelOffset, y, kLabelWidth-kLabelOffset, kLabelHeight)];
    lbl.backgroundColor = [UIColor blackColor];
    lbl.textColor = [UIColor whiteColor];
//    lbl.layer.borderWidth = 1;
//    lbl.layer.borderColor = [UIColor redColor].CGColor;
//    lbl.layer.backgroundColor = [UIColor grayColor].CGColor;
//    lbl.layer.opacity = 0.5;
    [self addSubview:lbl];
    
    return lbl;
}

- (NSString *)paddedLabel:(NSString *)title value:(NSString *)value
{
    return [NSString stringWithFormat:@"%10@: %@", title, value];
}

#pragma mark -
#pragma mark === Handlers ===
#pragma mark

- (NSString *)profilerPath:(NSString *)path
{
    NSString *pathPrefix = [NSString stringWithFormat:@"/PureWeb/Profiler/Session-%@", _framework.client.sessionId];
    return [NSString stringWithFormat:@"%@%@", pathPrefix, path];
}

- (void)onConnectedChanged
{
    if (_framework.client.isConnected)
    {
        if (_view) 
            [_framework.state.stateManager addValueChangedHandler:[self profilerPath:[NSString stringWithFormat:@"/View-%@/FPS", _view.viewName]] target:self action:@selector(onFpsChanged:)];
        [_framework.state.stateManager addValueChangedHandler:[self profilerPath:@"/WebClient/Mbps"] target:self action:@selector(onMbpsChanged:)];
        [_framework.state.stateManager addValueChangedHandler:[self profilerPath:@"/WebClient/RequestBuilding/Frequency"] target:self action:@selector(onRequestsChanged:)];
        [_framework.state.stateManager addValueChangedHandler:[self profilerPath:@"/WebClient/ResponseParsing/Frequency"] target:self action:@selector(onResponsesChanged:)];
        [_framework.state.stateManager addValueChangedHandler:[self profilerPath:@"/WebClient/ResponseHandlers/Frequency"] target:self action:@selector(onHandlersChanged:)];
    }
    else
    {
        if (_view) 
            [_framework.state.stateManager removeValueChangedHandler:[self profilerPath:[NSString stringWithFormat:@"/View-%@/FPS", _view.viewName]] target:self action:@selector(onFpsChanged:)];
        [_framework.state.stateManager removeValueChangedHandler:[self profilerPath:@"/WebClient/Mbps"] target:self action:@selector(onMbpsChanged:)];        
        [_framework.state.stateManager removeValueChangedHandler:[self profilerPath:@"/WebClient/RequestBuilding/Frequency"] target:self action:@selector(onRequestsChanged:)];        
        [_framework.state.stateManager removeValueChangedHandler:[self profilerPath:@"/WebClient/ResponseParsing/Frequency"] target:self action:@selector(onResponsesChanged:)];
        [_framework.state.stateManager removeValueChangedHandler:[self profilerPath:@"/WebClient/ResponseHandlers/Frequency"] target:self action:@selector(onHandlersChanged:)];
    }
}

- (void)onMbpsChanged:(PWValueChangedEventArgs *)args
{
    _mbps.text = [self paddedLabel:@"Mbps" value:args.newValue];
}

- (void)onRequestsChanged:(PWValueChangedEventArgs *)args
{
    _requestFreq.text = [self paddedLabel:@"Tx/s" value:args.newValue];
}

- (void)onResponsesChanged:(PWValueChangedEventArgs *)args
{
    _responseFreq.text = [self paddedLabel:@"RxP/s" value:args.newValue];
}

- (void)onHandlersChanged:(PWValueChangedEventArgs *)args
{
    _handlersFreq.text = [self paddedLabel:@"RxH/s" value:args.newValue];
}

- (void)onFpsChanged:(PWValueChangedEventArgs *)args
{
    _viewFps.text = [self paddedLabel:@"Fps" value:args.newValue];
}

@end
