//
//  PWTraceView.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PWTraceView.h"
#import <PureWeb/PWTraceLogger.h>

@implementation PWTraceView

- (id)init 
{
    if ((self = [super init])) 
    {    
        [self initialize];
        [self setEditable:false];
        self.contentInset = UIEdgeInsetsMake(8,0,8,0);
    }
    return self;
}

- (void)dealloc
{
    [[[PWTraceLogger sharedInstance] messageLogged] removeSubscribersForTarget:self];
}

- (void)initialize
{
    PWTraceLogger *logger = [PWTraceLogger sharedInstance];
    
    NSArray *messages = [logger getMessages];
    NSMutableString *formattedMessages = [[NSMutableString alloc] init];
    for (NSString *message in messages)
    {
        [formattedMessages appendFormat:@"%@\n", message];
    }
                   
    self.text = formattedMessages;

    [[logger messageLogged] addSubscriber:self action:@selector(messageLogged:)];
}

- (void)messageLogged:(NSObject *)object
{
    NSString *message = (NSString *)object;
    self.text = [self.text stringByAppendingFormat:@"%@\n", message];
    [self scrollRangeToVisible:NSMakeRange([self.text length], 0)];
}

@end
