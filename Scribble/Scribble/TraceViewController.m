//  TraceViewController.m
//
//  Created by Chris Burns on 2/10/14.
//  Copyright 2014 Calgary Scientific Inc. All rights reserved.

#import "TraceViewController.h"

#import <PureWeb/PureWeb.h>
#import <PureWeb/PWTraceLogger.h>

@interface TraceViewController ()

@property (strong, nonatomic) IBOutlet UITextView *traceTextView;

@end

@implementation TraceViewController

- (void)viewDidLoad
{
    //Read in all currently existing messages and add them to the text view
    PWTraceLogger *logger = [PWTraceLogger sharedInstance];
    
    NSArray *messages = [logger getMessages];
    for (NSString *message in messages)
    {
        [self logMessage:message];
    }
    
    //Subscribe to new messages provided by the logger
    [[logger messageLogged] addSubscriber:self action:@selector(logMessage:)];
    
    [super viewDidLoad];
}

- (void)logMessage:(NSString *) message
{
    self.traceTextView.text = [self.traceTextView.text stringByAppendingFormat:@"%@\n", message];
    [self.traceTextView scrollRangeToVisible:NSMakeRange([self.traceTextView.text length], 0)];
}

- (void)dealloc
{
    [[[PWTraceLogger sharedInstance] messageLogged] removeSubscribersForTarget:self];
}

@end
