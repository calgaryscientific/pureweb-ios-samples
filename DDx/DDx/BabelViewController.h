//
//  BabelViewController.h
//  DDxSample
//
//  Created by Sam Leitch on 12-06-08.
//  Copyright (c) 2012 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWNavigationController.h"
#import "OptionsPanelDelegate.h"

@interface BabelViewController : UITableViewController
{
    NSArray *_localeData;
    UINib *_cellLoader;
    UINib *_controlCellLoader;
    UINib *_headerLoader;
}

@end
