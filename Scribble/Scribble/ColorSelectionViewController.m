//  ColorSelectionViewController.m
//
//  Created by Chris Burns on 2/10/14.
//  Copyright 2014 Calgary Scientific Inc. All rights reserved.

#import "ColorSelectionViewController.h"
#import "UIColor+HighlightedColors.h"
#import <PureWeb/PureWeb.h>

@interface ColorSelectionViewController ()

@property BOOL trayExtended;

@property (strong, nonatomic) UIButton *currentlySelectedColorButton;
@property (strong, nonatomic) IBOutlet UIView *enclosingView;

@property (strong, nonatomic) NSArray *colorNames;
@property (strong, nonatomic) NSDictionary *colorMap;
@property (strong, nonatomic) NSDictionary *reverseColorMap;

@end

@implementation ColorSelectionViewController


- (void) traySelected //(TODO) rename this to selectTray
{
    //Compute the Appropriate Offset to Hide or Show
    CGRect colorTrayFrame = self.view.superview.frame;
    CGFloat colorTrayHeight = self.view.superview.frame.size.height;
    
    CGFloat navigationBarHeight = 44;
    CGFloat offset = colorTrayHeight + navigationBarHeight;
    
    //If the tray is already extended, we want to move in the opposite direction
    if(self.trayExtended){
        offset = offset * -1;
    }
    
    //Animation the hiding or showing animation
    [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{

        CGRect destinationFrame = CGRectMake(colorTrayFrame.origin.x, (colorTrayFrame.origin.y - offset), colorTrayFrame.size.width, colorTrayFrame.size.height);
        self.view.superview.frame = destinationFrame;

    } completion:^(BOOL finished) {
        
    }];
    
    //Reverse whether tray has been extended
    self.trayExtended = !self.trayExtended;
}

#pragma mark View Lifecycle
- (void) viewDidAppear:(BOOL)animated {
    
    
    
}
- (void)viewDidLoad
{
    //listen for changes in app state
    [[PWFramework sharedInstance].state.stateManager addValueChangedHandler:@"/ScribbleColor"
                                                                     target:self
                                                                     action:@selector(colorDidChange:)];
    
    //setup the mapping between color names and colors
    self.colorNames = @[@"White", @"Black",@"Blue", @"Red", @"Green", @"Purple",@"Orange", @"Yellow"];
    NSArray *colorValues = @[[UIColor whiteColor], [UIColor blackColor],[UIColor blueColor],[UIColor redColor],[UIColor greenColor], [UIColor purpleColor],[UIColor orangeColor],[UIColor yellowColor]];
    self.colorMap = [NSDictionary dictionaryWithObjects:colorValues forKeys:self.colorNames];
    self.reverseColorMap = [NSDictionary dictionaryWithObjects:self.colorNames forKeys:colorValues];
    
    [self setupColorButtons];
    
    [super viewDidLoad];

}

- (void) viewWillLayoutSubviews {
    
    
    self.trayExtended = NO; //whenever the view does a layout we need to restore the extended to no, since the container will return to the autolayout proportions
    
}
- (void)setupColorButtons
{
    [self.enclosingView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        
        if ([subview isKindOfClass:[UIButton class]]) {
            
            //determine the color based on the map
            NSString *colorName = [self.colorNames objectAtIndex:idx];
            UIColor *color = self.colorMap[colorName];
            
            UIButton *button = (UIButton*) subview;
            button.backgroundColor = color;
            
            button.layer.cornerRadius = 10.0f;
        }
    }];

    //determine the initial selected button based on the value in app state
    NSString *defaultColorName = [[PWFramework sharedInstance].state getValueWithAppStatePath:@"/ScribbleColor"];
    UIColor *defaultColor = self.colorMap[defaultColorName];
    UIButton *defaultButton = [self buttonForColor:defaultColor];
    
    [self selectButton:defaultButton];
    
    self.currentlySelectedColorButton = defaultButton;
}

#pragma mark Button Selection Code
- (IBAction)colorButtonSelected:(UIButton *)button
{
    //Update Pureweb AppState with the Chosen Color
    [self updateAppStateWithColor:button.backgroundColor];
}

- (void) selectButton:(UIButton *) button
{
    button.layer.borderColor = [[button.backgroundColor highlightColor] CGColor];
    button.layer.borderWidth  = 5.0f;
}

- (void) unselectButton:(UIButton *) button
{
    button.layer.borderWidth = 0.0f;
    
}

- (UIButton *) buttonForColor:(UIColor *) color {
    
    __block UIButton *chosenButton;
    
    //find the button associated with the color
    [self.enclosingView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        
        if ([subview isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton*) subview;
            
            if([button.backgroundColor isEqual:color]) {
                chosenButton = button;
                *stop = YES;
            }
        }
    }];
    
    return chosenButton;
}

#pragma mark PureWeb Methods
- (void)updateAppStateWithColor:(UIColor *) chosenColor
{
    //find the uicolor associated with the string
    NSString *colorName = self.reverseColorMap[chosenColor];
    [[PWFramework sharedInstance].state setAppStatePathWithValue:@"/ScribbleColor" value:colorName];
}

//color did change will fire not only when the color is changed by us but also when its changed by a collaborator
- (void)colorDidChange:(PWValueChangedEventArgs *)args {
    
    //determine the update color and find the matching UIColor
    NSString *colorName = args.newValue;
    UIColor *chosenColor = self.colorMap[colorName];
    
    //regardless of whether the color corresponds, unselect the currently selected color
    [self unselectButton:self.currentlySelectedColorButton];
    
    //if a button corresponding to the updated color exists then select it
    UIButton *chosenButton = [self buttonForColor:chosenColor];
    if(chosenButton) {
        
        [self selectButton:chosenButton];
        self.currentlySelectedColorButton = chosenButton;
    }
}

@end
