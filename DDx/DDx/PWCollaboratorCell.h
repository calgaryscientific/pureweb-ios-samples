//
//  PWCollaboratorCell.h
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWGuid;

@protocol PWCollaboratorCellDelegate <NSObject>

- (void)enabledDidChange:(PWGuid *)sessionId;
- (void)clearWasPressed:(PWGuid *)sessionId;

@end

@interface PWCollaboratorCell : UITableViewCell
{
}

@property (nonatomic, weak) id<PWCollaboratorCellDelegate> delegate;
@property (nonatomic, strong) PWGuid *sessionId;

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UISwitch *enabled;
@property (nonatomic, weak) IBOutlet UIButton *clearButton;
@property (nonatomic, weak) IBOutlet UILabel *colorLabel;

- (IBAction)enabledDidChange:(id)sender;
- (IBAction)clearWasPressed:(id)sender;

@end
