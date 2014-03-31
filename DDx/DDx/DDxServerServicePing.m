#import "DDxServerServicePing.h"

#import <PureWeb/PureWeb.h>

@interface DDxServerServicePing ()

@property NSInteger totalPings;
@property NSMutableArray *pingResults;

@property (nonatomic, copy) DDxPingCompletion completion;

@end


@implementation DDxServerServicePing


/* a service server ping measures the ping between the service and the server which can be located on different machines. for */
- (void) ping:(DDxPingCompletion) completion {
    
    self.completion = completion;
    
    [self start];
    
    [self triggerPing];
}

- (void) start
{
    self.totalPings = 10;
    
    self.pingResults = [NSMutableArray array];
    
    //listen to app state for a change to the number of remaining pings
    [[PWFramework sharedInstance].state.stateManager addValueChangedHandler:@"DDxServiceServerPingResponseCount"
                                                                     target:self
                                                                     action:@selector(didReceivePingResponse:)];
}

- (void) finish
{
    //remove the listener on app state
    [[PWFramework sharedInstance].state.stateManager removeValueChangedHandler:@"DDxServiceServerPingResponseCount" target:self action:@selector(didReceivePingResponse:)];
    
    //invoke the completion block with the required values
    __block NSNumber *pingSum = 0;
    [self.pingResults enumerateObjectsUsingBlock:^(NSNumber *result, NSUInteger idx, BOOL *stop) {
        
        pingSum = @([pingSum floatValue] + [result floatValue]);
    }];
    
    float pingAverage = [pingSum floatValue] / (float) self.totalPings;
    
    self.completion(self.totalPings, pingAverage, self.pingResults);

}

- (void) triggerPing
{
    [[PWFramework sharedInstance].client queueCommand:@"DDxServiceServerPing"
                                       withParameters:nil
                                    isDeferredCommand:NO
                                           onComplete:^(PWCommandResponseEventArgs *args) {
                                               
                                           }];
}


- (void) didReceivePingResponse: (PWValueChangedEventArgs *) args {
    
    //capture the results
    float result = [[[PWFramework sharedInstance].state.stateManager getValue:@"DDxServiceServerPingResponse"] floatValue];
    [self.pingResults addObject:@(result)];
    
    //determine if the ping process should continue
    NSInteger completedPings = [args.newValue integerValue];
    
    if (completedPings < self.totalPings) {
        
        [self triggerPing];
    }
    else {
        
        [self finish];
    }
}

@end
