//
//  DDxView.h
//  DDxSample
//
//  Created by Chris Garrett on 12-04-12.
//  Copyright (c) 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PWView.h"

@interface DDxView : PWView
{
    UILabel *_textLabel;
    CGPoint _lastInputPosition;
}

@property (nonatomic, assign) BOOL showImageDetails;


- (void)updateLabel:(PWValueChangedEventArgs *)args;

- (void)mouseEnter:(CGPoint)point;
- (void)mouseLeave;
- (void)mouseMove:(CGPoint)point;

@end
