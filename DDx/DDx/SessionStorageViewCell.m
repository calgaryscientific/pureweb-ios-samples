//
//  SessionStorageViewCell.m
//  DDx
//
//  Created by Jonathan Neitz on 2016-02-01.
//  Copyright © 2016 Calgary Scientific Inc. All rights reserved.
//

#import "SessionStorageViewCell.h"
#import <PureWeb/PureWeb.h>

@implementation SessionStorageViewCell

- (IBAction)serviceListener:(id)sender {
    
     PWSessionStorage* storage = [[PWFramework sharedInstance].client getSessionStorage];
    
    if( self.serviceListenerSwitch.on ) {
        [storage addValueChangedHandler:self.keyLabel.text target:self.sessionStorageController action:@selector(valueChanged:)];
        [self.sessionStorageController.changeHandlers setObject: [NSNumber numberWithBool:YES] forKey:self.keyLabel.text];
    } else {
        [storage removeValueChangedHandler:self.keyLabel.text target:self.sessionStorageController action:@selector(valueChanged:)];
        [self.sessionStorageController.changeHandlers setObject: [NSNumber numberWithBool:NO] forKey:self.keyLabel.text];
    }
}


- (IBAction)deleteKey:(id)sender {

    PWSessionStorage* storage = [[PWFramework sharedInstance].client getSessionStorage];
    
    [storage removeValue:self.keyLabel.text];
    
    [storage removeValueChangedHandler:self.keyLabel.text target:self.sessionStorageController action:@selector(valueChanged:)];
    [self.sessionStorageController.changeHandlers setObject: [NSNumber numberWithBool:NO] forKey:self.keyLabel.text];
    
    [[PWFramework sharedInstance].client queueCommand:@"DetachStorageListener" withParameters:@{@"key": self.keyLabel.text}];
}

- (IBAction)getValue:(id)sender {
     PWSessionStorage* storage = [[PWFramework sharedInstance].client getSessionStorage];
    
    NSString* value = [storage getValue:self.keyLabel.text];
    
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Local value in Session Storage"
                                                       message:[NSString stringWithFormat:@"\n\n%@",value]
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [theAlert show];
    return;

    
}


- (void)awakeFromNib {
    // Initialization code
    self.serviceListenerSwitch.on = NO;
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
