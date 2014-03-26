//
//  PWTouchButtonView.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PWTouchButtonView.h"

@implementation PWTouchButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);

    CGColorRef outerCircle = [UIColor whiteColor].CGColor;
    CGColorRef innerCircle = [UIColor yellowColor].CGColor;

    CGContextSetStrokeColorWithColor(context, outerCircle);
    CGContextAddEllipseInRect(context, CGRectMake(self.frame.origin.x-1, self.frame.origin.y-1, self.frame.size.width+2, self.frame.size.height+2));
    CGContextStrokePath(context);

    CGContextSetStrokeColorWithColor(context, innerCircle);
    CGContextSetFillColorWithColor(context, innerCircle);
    CGContextAddEllipseInRect(context, self.frame);
    CGContextFillPath(context);
}

@end
