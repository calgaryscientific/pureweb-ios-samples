//
//  PWNavigationButtonCollectionView.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PWNavigationButtonCollectionView.h"
#import <QuartzCore/QuartzCore.h>
#import "PWUtility.h"

CGFloat const kPadding = 12;
CGFloat const kIncrement = 55;
CGFloat const kWidth = 50;
CGFloat const kHeight = 30;


@interface PWNavigationButtonCollectionView ()

@end
@implementation PWNavigationButtonCollectionView

@synthesize buttonWidth = _buttonWidth;
@synthesize marginWidth = _marginWidth;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        _buttonWidth = kWidth;
        _marginWidth = kPadding;
        //        self.layer.borderColor = [UIColor whiteColor].CGColor;
        //        self.layer.borderWidth = 1;
    }
    return self;
}

- (void) inspect
{
    
    
    
}

- (void) willMoveToSuperview:(UIView *)newSuperview
{
    
    
    
}

- (void) didMoveToSuperview {
    
    
    
}
- (void)layoutSubviews
{
    
    CGFloat width = kPadding;
    CGFloat navbarHeight = [PWUtility navigationbarHeight:[[UIApplication sharedApplication] statusBarOrientation]/*[[UIDevice currentDevice] orientation]*/];

    int i = 0;
    for (UIView *child in self.subviews)
    {
        child.frame = CGRectMake((width + kPadding), 5, child.frame.size.width, kHeight);
        width += (child.frame.size.width + kPadding);
        i++;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, navbarHeight);
}

- (UISegmentedControl *)addButton:(id)object target:(NSObject *)target action:(SEL)action
{
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:object,nil]];
    
    if (target && action)
        [seg addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    
    //seg.frame = CGRectMake([self.subviews count]*kIncrement+kPadding, kPadding, kWidth, kHeight);
    seg.momentary = YES;
    seg.tintColor = [UIColor blueColor];

    [self addSubview:seg];    
    
    return seg;
}

- (UISegmentedControl *)addButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    return [self addButton:title target:target action:action];
}

- (UIButton *)addButtonWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (target && action)
        [imageButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //setup background images
    [imageButton setBackgroundImage:image forState:UIControlStateNormal];
    
    [imageButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    imageButton.frame = CGRectMake(0, 0, 30, 30);
    
    [self addSubview:imageButton];

    return imageButton;

}

- (void)addSpacer
{
    //    UIView *spacer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    //    [self addSubview:spacer];
    //    [spacer release];
}

- (void)setMarginWidth:(CGFloat)spacingWidth
{
    if (_marginWidth == spacingWidth)
        return;
    
    _marginWidth = spacingWidth;
}

- (void)setButtonWidth:(CGFloat)buttonWidth
{
    if (_buttonWidth == buttonWidth)
        return;
    
    _buttonWidth = buttonWidth;
}

@end
