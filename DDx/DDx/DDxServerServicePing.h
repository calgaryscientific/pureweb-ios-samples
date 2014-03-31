//
//  DDxServerServicePing.h
//  DDx
//
//  Created by Chris Burns on 3/31/14.
//  Copyright (c) 2014 Calgary Scientific Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DDxPingCompletion)(int numPings, double average, NSArray *times);

@interface DDxServerServicePing : NSObject

- (void) ping:(DDxPingCompletion) completion;

@end
