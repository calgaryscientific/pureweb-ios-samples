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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)setKeyValue:(id)sender {

    PWSessionStorage* storage = [[PWFramework sharedInstance].client getSessionStorage];
    
    // We don't allow whitespace before or after key and values. So make sure it's trimmed away
    NSString* key = [self.keyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* value = [self.valueTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if( isEmpty(key) || isEmpty(value) ) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"DDx"
                                                             message:@"Key or Value cannot be empty!"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [theAlert show];
        return;
    }
    
    [storage setKey: key toValue: value];
}

@end
