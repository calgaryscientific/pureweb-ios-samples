//
//  PWCollaborationViewController.h
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWCollaboratorCell.h"

@class PWCollaborationManager;
@class PWParticipantInfo;

@interface PWCollaborationViewController : UITableViewController <PWCollaboratorCellDelegate>
{
    NSMutableArray *_collaborators;
    UINib *_cellLoader;
    PWCollaborationManager *__weak _collaborationManager;
    PWParticipantInfo *_hostParticipant;
}

@property (nonatomic, weak) PWCollaborationManager *collaborationManager;

@end
