//
//  SessionStorageViewCell.h
//  DDx
//
//  Created by Jonathan Neitz on 2016-02-01.
//  Copyright © 2016 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionStorageViewController.h"

@interface SessionStorageViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UISwitch *serviceListenerSwitch;
@property (weak, nonatomic) SessionStorageViewController *sessionStorageController;
@end
