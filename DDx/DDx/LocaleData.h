//
//  LocaleData.h
//  DDxSample
//
//  Created by Sam Leitch on 12-07-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocaleData : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *commandResponse;
@property (nonatomic, copy) NSString *appState;

- (id)initWithKey:(NSString *)key type:(NSString *)type content:(NSString *)content;
+ (LocaleData *)localeDataWithKey:(NSString *)key type:(NSString *)type content:(NSString *)content;

@end
