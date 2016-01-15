//
//  PWAppStateView.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PWAppStateView.h"
#import <PureWeb/PWFramework.h>

@implementation PWAppStateView

- (void)didMoveToWindow
{
    NSString *xml = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" ?>%@", 
                                               [[[PWFramework sharedInstance].state.stateManager getTree:@"/"] description]];
    [self loadData:[xml dataUsingEncoding:NSUTF8StringEncoding]
              MIMEType:@"text/plain" 
      textEncodingName:@"utf-8" 
               baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

@end
