//
//  NSURL+URLHelpers.m
//  Scribble
//
//  Created by Chris Burns on 3/21/14.
//  Copyright (c) 2014 Calgary Scientific Inc. All rights reserved.
//

#import "NSURL+URLHelpers.h"

@implementation NSURL (URLHelpers)


#pragma Utility Methods
- (NSArray *)urlSchemes
{
    NSMutableArray *schemes = [NSMutableArray array];
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    
    NSArray *urlTypes = [infoPlist objectForKey:@"CFBundleURLTypes"];
    for (NSDictionary *type in urlTypes)
    {
        NSArray *schemesForType = [type objectForKey:@"CFBundleURLSchemes"];
        for (NSString *scheme in schemesForType)
        {
            [schemes addObject:scheme];
        }
    }
    
    return [schemes copy];
}


//(???) will 'schemeFree' be returned properly? does it need to be copied onto the 
- (NSURL *) URLByReplacingScheme: (BOOL) secureScheme {
 

    __block NSURL *schemeFree;
    
    [[self urlSchemes] enumerateObjectsUsingBlock:^(NSString *scheme, NSUInteger idx, BOOL *stop) {
        
        if ([self.scheme isEqualToString:scheme]) {
            
            NSString* httpScheme = @"http://";
            
            if( secureScheme ) {
                    httpScheme = @"https://";
            }
            
            NSString *path = [[self absoluteString] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://",scheme]                                                                  withString:httpScheme];
            
            schemeFree = [NSURL URLWithString:path];
        }
    }];
    
    return schemeFree;
}
@end
