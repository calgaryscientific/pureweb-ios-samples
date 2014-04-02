//
//  DDxRoundtripPing.m
//  DDx
//
//  Created by Chris Burns on 3/31/14.
//  Copyright (c) 2014 Calgary Scientific Inc. All rights reserved.
//

#import "DDxRoundtripPing.h"

#import <PureWeb/PureWeb.h>

@interface DDxRoundtripPing ()

@property NSInteger totalPings;
@property NSInteger pingsCompleted;

@property NSMutableArray *pingResults;

@property (nonatomic, copy) DDxPingCompletion completion;

@end


@implementation DDxRoundtripPing

- (void) ping:(DDxPingCompletion) completion {
    
    self.completion = completion;
    
    [self start];
    
}

- (void) start
{
    self.totalPings = 10;
    self.pingsCompleted = 0;
    self.pingResults = [NSMutableArray array];
    
    [self sendPing];

}


- (void) finish
{
    //invoke the completion block with the required values
    __block float pingSum = 0;
    [self.pingResults enumerateObjectsUsingBlock:^(NSNumber *result, NSUInteger idx, BOOL *stop) {
        
        pingSum += [result floatValue];
    }];
    
    float pingAverage = pingSum/ (float) self.totalPings;
    
    self.completion(self.totalPings, pingAverage, self.pingResults);
}


- (void)sendPing
{

    NSDate *pingStart = [NSDate date];
    
    //(???) how are we able to edit self.pingsCompleted if its not marked as being inside a __block property
    [[PWFramework sharedInstance].client queueCommand:@"DDxRoundtripPing"
                                       withParameters:nil
                                    isDeferredCommand:NO
                                           onComplete:^(PWCommandResponseEventArgs *args) {
                                               
                                               self.pingsCompleted++;
                                               
                                               //store the result from the ping
                                               float result = ([pingStart timeIntervalSinceNow] * -1000.0); //convert to positive milliseconds
                                               [self.pingResults addObject:@(result)];

                                               //determine if additional pings are required
                                               if (self.pingsCompleted < self.totalPings) {
                                                   
                                                   [self sendPing];
                                               }
                                               else {
                                                   
                                                   [self finish];
                                               }
                                           }];
}
@end
