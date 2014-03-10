//  UIColor+HighlightedColors.h
//
//  Created by Chris Burns on 2/10/14.
//  Copyright 2014 Calgary Scientific Inc. All rights reserved.

#import "UIColor+HighlightedColors.h"

@implementation UIColor (HighlightedColors)


- (UIColor*) highlightColor
{
    
    NSArray *specialColors = @[[UIColor colorWithRed:0.93333334 green:0.50980395 blue:0.93333334 alpha:1],
                               [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1] ,
                               [UIColor yellowColor],
                               [UIColor whiteColor]];

    
    
    if([specialColors containsObject:self]) {
        return [UIColor blackColor];
    }
    
    return [UIColor whiteColor];
}

@end
