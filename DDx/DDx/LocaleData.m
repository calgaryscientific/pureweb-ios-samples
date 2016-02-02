//
//  LocaleData.m
//  DDxSample
//
//  Created by Sam Leitch on 12-07-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocaleData.h"

@implementation LocaleData

@synthesize key = _key;
@synthesize type = _type;
@synthesize content = _content;
@synthesize appState = _appState;
@synthesize commandResponse = _commandResponse;

-(id)initWithKey:(NSString *)key type:(NSString *)type content:(NSString *)content
{
    if(self = [super init])
    {
        _key = key;
        _type = type;
        _content = content;
        _commandResponse = @"";
        _appState = @"";
        _sessionStorage = @"";
    }
    
    return self;
}

+ (LocaleData *)localeDataWithKey:(NSString *)key type:(NSString *)type content:(NSString *)content
{
    return [[LocaleData alloc] initWithKey:key type:type content:content];
}

@end
