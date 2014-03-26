//
//  PWParticipantInfo.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PWParticipantInfo.h"

@implementation PWParticipantInfo

@synthesize name = _name, email = _email, sessionId = _sessionId;

- (id)initWithName:(NSString *)name email:(NSString *)email sessionId:(PWGuid *)sessionId
{
    if ((self = [super init]))
    {
        _name = name;
        _email = email;
        _sessionId = sessionId;
    }
    return self;    
}


+ (PWParticipantInfo *)parciticipantWithName:(NSString *)name email:(NSString *)email sessionId:(PWGuid *)sessionId
{
    return [[PWParticipantInfo alloc] initWithName:name email:email sessionId:sessionId];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<PWParticipantInfo:%p> Name: %@ Email: %@ SessionId: %@", self, _name, _email, _sessionId];
}

@end
