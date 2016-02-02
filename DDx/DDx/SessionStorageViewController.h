//
//  SessionStorageViewController.h
//  DDx
//
//  Created by Jonathan Neitz on 2016-02-01.
//  Copyright © 2016 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PureWeb/PureWeb.h>

@interface SessionStorageViewController : UITableViewController

@property(nonatomic,strong) NSMutableDictionary* changeHandlers;


- (void)sessionStorageKeyAdded:(PWSessionStorageChangedEventArgs *)args;
- (void)valueChanged:(PWSessionStorageChangedEventArgs*)args;

@end
