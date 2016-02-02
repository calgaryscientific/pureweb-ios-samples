//
//  SessionStorageViewHeader.m
//  DDx
//
//  Created by Jonathan Neitz on 2016-02-01.
//  Copyright © 2016 Calgary Scientific Inc. All rights reserved.
//

#import "SessionStorageViewHeader.h"
#import <PureWeb/PureWeb.h>

@implementation SessionStorageViewHeader

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)setKeyValue:(id)sender {

    PWSessionStorage* storage = [[PWFramework sharedInstance].client getSessionStorage];
    
    if( isEmpty(self.keyTextField.text) || isEmpty(self.valueTextField.text) ) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"DDx"
                                                             message:@"Key or Value cannot be empty!"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [theAlert show];
        return;
    }
    
    [storage setKey:self.keyTextField.text toValue:self.valueTextField.text];
}

@end
