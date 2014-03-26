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

@end

@implementation DDxView

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
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 150, 150)];
    _textLabel.font = [UIFont systemFontOfSize:14.0];
    _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.numberOfLines = 0;
    _textLabel.userInteractionEnabled = NO;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.text = @"";
    [self addSubview:_textLabel];
    
    [self.viewUpdated addSubscriber:self action:@selector(viewWasUpdated:)];
}

- (void)viewWasUpdated:(PWViewUpdatedEventArgs *)args
{
    _quality = [args.encodingParameters objectForKey:@"EncodingQuality"];
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
            _textLabel.text = [NSString stringWithFormat:@"Type: %@\nChangedButton: %@\nButtons: %@\nModifiers: %@\nX: %@ Y:%@\nEncoding: %@\nQuality: %@",
                               [self getTextWithDefault:element path:@"Type" defaultValue:@""],
                               [self getTextWithDefault:element path:@"ChangedButton" defaultValue:@""],
                               [self getTextWithDefault:element path:@"Buttons" defaultValue:@""],
                               [self getTextWithDefault:element path:@"Modifiers" defaultValue:@""],
                               [self getTextWithDefault:element path:@"X" defaultValue:@""],
                               [self getTextWithDefault:element path:@"Y" defaultValue:@""],
                               self.encodingType ? self.encodingType.value : @"",
                               _quality];
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
