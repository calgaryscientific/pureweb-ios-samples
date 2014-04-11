//
//  DirectionControlView.m
//  Asteroids
//
//  Created by Chris Burns on 4/10/14.
//  Copyright (c) 2014 Calgary Scientific Inc. All rights reserved.
//

#import "DirectionControlView.h"

#import <PureWeb/PureWeb.h>

typedef NS_ENUM(NSInteger, ActionMode) {
    ActionStarted,
    ActionEnded
};

enum KeyCode
{
    KeyCodeLeft = 37,
    KeyCodeRight = 39,
    KeyCodeUp = 38,
    KeyCodeDown = 40,
    KeyCodeSpace = 32,
    KeyCodeS = 83,
};


@implementation DirectionControlView


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        
        [self processTouch:touch withMode:ActionStarted];
    }
    
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        
        [self processTouch:touch withMode:ActionEnded];
    }
    
}

- (void) processTouch:(UITouch *) touch withMode:(ActionMode) mode{
    
    CGPoint location = [touch locationInView:self];
    //left or top
    if (location.y > location.x) {
        
        //top
        if(location.y > (self.frame.size.height - location.x)) {
            [self bottomWithMode:mode];
        }
        //left
        else {
            [self leftWithMode:mode];
        }
        
    }
    //right or bottom
    else {
        
        //bottom
        if(location.y > (self.frame.size.height - location.x)) {
            
            [self rightWithMode:mode];
            
        }
        else {
            
            [self topWithMode:mode];
        }
        
    }
}



/* directional values */
- (void)leftWithMode:(ActionMode) mode {
    
    if(mode == ActionStarted) {
        
        [self queueKeyPress:@"KeyDown" keycode:KeyCodeLeft modifiers:0];
        
    }
    else {
        
        [self queueKeyPress:@"KeyUp" keycode:KeyCodeLeft modifiers:0];
    }
}

- (void)rightWithMode:(ActionMode) mode {
    
    if(mode == ActionStarted) {
        
        [self queueKeyPress:@"KeyDown" keycode:KeyCodeRight modifiers:0];
        
    }
    else {
        
        [self queueKeyPress:@"KeyUp" keycode:KeyCodeRight modifiers:0];
    }
    
}

- (void)topWithMode:(ActionMode) mode {
    
    if(mode == ActionStarted) {
        
        [self queueKeyPress:@"KeyDown" keycode:KeyCodeUp modifiers:0];
        
    }
    else {
        
        [self queueKeyPress:@"KeyUp" keycode:KeyCodeUp modifiers:0];
    }
    
}

- (void)bottomWithMode:(ActionMode) mode {
    
    if(mode == ActionStarted) {
        
        [self queueKeyPress:@"KeyDown" keycode:KeyCodeDown modifiers:0];
        
    }
    else {
        
        [self queueKeyPress:@"KeyUp" keycode:KeyCodeDown modifiers:0];
    }
    
}

- (void)queueKeyPress:(NSString *)eventType keycode:(long)keycode modifiers:(long)modifiers
{
    NSDictionary *cmdParams = [NSDictionary dictionaryWithObjectsAndKeys:
                               eventType, @"EventType",
                               @"AsteroidsView", @"Path",
                               [NSString stringWithFormat:@"%ld", keycode], @"KeyCode",
                               [NSString stringWithFormat:@"%ld", modifiers], @"Modifiers",
                               nil];
    
    [[PWFramework sharedInstance].client queueCommand:@"InputEvent" withParameters:cmdParams];
}

@end
