//
//  PWNavigationButtonCollectionView.h
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWNavigationButtonCollectionView : UIView
{
    CGFloat _buttonWidth;
    CGFloat _marginWidth;
}

@property (nonatomic, readwrite, assign) CGFloat buttonWidth;
@property (nonatomic, readwrite, assign) CGFloat marginWidth;

- (UISegmentedControl *)addButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (UIButton *)addButtonWithImage:(UIImage *)image target:(id)target action:(SEL)action;
- (void)addSpacer;

- (void) inspect; 

@end
