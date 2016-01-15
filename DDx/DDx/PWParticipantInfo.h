//
//  PWParticipantInfo.h
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PureWeb/PWGuid.h>

@class PWGuid;

@interface PWParticipantInfo : NSObject
{
    NSString *_name;
    NSString *_email;
    PWGuid *_sessionId;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) PWGuid *sessionId;

- (id)initWithName:(NSString *)name email:(NSString *)email sessionId:(PWGuid *)sessionId;
+ (PWParticipantInfo *)parciticipantWithName:(NSString *)name email:(NSString *)email sessionId:(PWGuid *)sessionId;

@end
