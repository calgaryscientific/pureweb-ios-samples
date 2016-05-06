//
//  NSURL+URLHelpers.h
//  Scribble
//
//  Created by Chris Burns on 3/21/14.
//  Copyright (c) 2014 Calgary Scientific Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (URLHelpers)

- (NSURL *) URLByReplacingScheme:(BOOL) secureScheme;

@end
