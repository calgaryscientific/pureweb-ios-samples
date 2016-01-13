//
//  DDxRoundtripPing.h
//  DDx
//
//  Created by Chris Burns on 3/31/14.
//  Copyright (c) 2014 Calgary Scientific Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DDxPingCompletion)(NSInteger numPings, double average, NSArray *times);

@interface DDxRoundtripPing : NSObject

- (void) ping:(DDxPingCompletion) completion;

@end