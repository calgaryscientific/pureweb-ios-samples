//
//  PWCollaboratorCell.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PWCollaboratorCell.h"

@implementation PWCollaboratorCell

@synthesize delegate = _delegate;
@synthesize sessionId = _sessionId;
@synthesize colorLabel = _colorLabel;
@synthesize name = _name;
@synthesize enabled = _enabled;
@synthesize clearButton = _clearButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)enabledDidChange:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(enabledDidChange:)])
        [_delegate enabledDidChange:self.sessionId];
}

- (IBAction)clearWasPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(clearWasPressed:)])
        [_delegate clearWasPressed:self.sessionId];
}

@end
