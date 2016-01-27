//
//  PWCollaborationViewController.m
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PWCollaborationViewController.h"
#import "PWCollaboratorCell.h"
#import "PWParticipantInfo.h"
#import <PureWeb/PureWeb.h>
#import <PureWeb/PWLog.h>

static NSString * const kPWCollaboratorCell = @"PWCollaboratorCell";
static NSString * const kPWCollaboratorName = @"Name";
static NSString * const kPWCollaboratorEmail = @"Email";

@interface PWCollaborationViewController ()

@property (nonatomic, strong) PWParticipantInfo *hostParticipant;

- (void)sessionsDidChange;
- (void)ownerDidChange;

@end

@implementation PWCollaborationViewController

@synthesize hostParticipant = _hostParticipant;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _collaborators = [NSMutableArray new];
        _cellLoader = [UINib nibWithNibName:kPWCollaboratorCell bundle:[NSBundle mainBundle]];
        
        NSString *defaultName = [[NSUserDefaults standardUserDefaults] stringForKey:@"pureweb_collab_name"];
        NSString *defaultEmail = [[NSUserDefaults standardUserDefaults] stringForKey:@"pureweb_collab_email"];
        _hostParticipant = [[PWParticipantInfo alloc] initWithName:defaultName email:defaultEmail sessionId:nil];
        self.tableView.allowsSelection = NO;
    }
    return self;
}

- (void)dealloc
{
    [_collaborationManager.isInitializedChanged removeSubscribersForTarget:self];
    [_collaborationManager.ownerSessionChanged removeSubscribersForTarget:self];
    [_collaborationManager.sessionsChanged removeSubscribersForTarget:self];
    
    _cellLoader = nil;
    _collaborators = nil;
}

#pragma mark - CollaboratorCellDelegate

@synthesize collaborationManager = _collaborationManager;

- (void)setCollaborationManager:(PWCollaborationManager *)collaborationManager
{
    if (_collaborationManager == collaborationManager) return;
    
    if(_collaborationManager)
    {
        [_collaborationManager.isInitializedChanged removeSubscribersForTarget:self];
        [_collaborationManager.ownerSessionChanged removeSubscribersForTarget:self];
        [_collaborationManager.sessionsChanged removeSubscribersForTarget:self];
    }
    
    _collaborationManager = collaborationManager;
    
    if(_collaborationManager)
    {
        [_collaborationManager.sessionsChanged addSubscriber:self action:@selector(sessionsDidChange)];
        [_collaborationManager.ownerSessionChanged addSubscriber:self action:@selector(ownerDidChange)];
        [_collaborationManager.isInitializedChanged addSubscriber:self action:@selector(isInitializedDidChange)];
    }
    
    [self isInitializedDidChange];
}

#pragma mark - ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSAssert(_collaborationManager, @"collaborationManager not set on PWCollaborationViewController. Unable to continue!");
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void) viewDidLayoutSubviews
{
    
    CGFloat navBarOffset = self.navigationController.navigationBar.frame.origin.y;
    CGFloat topOffset = self.topLayoutGuide.length;
    self.tableView.contentInset = UIEdgeInsetsMake(topOffset + navBarOffset + 20, 0, 0, 0);
}

#ifdef __IPHONE_6_0

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
#endif

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 1;
    
    @synchronized(self)
    {
        return _collaborators.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *header = [[UILabel alloc] init];
    header.backgroundColor = [UIColor lightGrayColor];
    header.textColor = [UIColor whiteColor];
    
    if (section == 0)
        header.text = @" Host";
    else if (section == 1)
        header.text = @" Participants";
        
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PWCollaboratorCell *cell = (PWCollaboratorCell *)[tableView dequeueReusableCellWithIdentifier:kPWCollaboratorCell];
    if (!cell)
        cell = [[_cellLoader instantiateWithOwner:self options:nil] objectAtIndex:0];

    cell.delegate = self;
    
    @synchronized(self)
    {
        if(self.collaborationManager != nil && self.collaborationManager.isInitialized) {
            PWParticipantInfo *p = indexPath.section == 0 ? _hostParticipant : [_collaborators objectAtIndex:indexPath.row];
            PWLogInfo(@"cell: %@ | %@ | %@", p.sessionId, p.name, p.email);
            cell.sessionId = p.sessionId;
            cell.name.text = [NSString stringWithFormat:@"%@ (%@)", p.name, p.email];

        
            UIColor *color = [_collaborationManager getSessionDefaultColor:p.sessionId].uiColor;
            cell.colorLabel.backgroundColor = color;
            cell.enabled.on = [_collaborationManager getMarkupVisible:p.sessionId];
        }
    }

    return cell;
}

#pragma mark - CollaboratorCellDelegate

- (void)enabledDidChange:(PWGuid *)sessionId
{
    [_collaborationManager setMarkupVisible:sessionId markupVisible:![_collaborationManager getMarkupVisible:sessionId]];
}

- (void)clearWasPressed:(PWGuid *)sessionId
{
    [_collaborationManager removeAcetateMarkupWithSessionId:sessionId];
}

#pragma mark - PWCollaborationManager

- (void)isInitializedDidChange
{
    if(!self.collaborationManager.isInitialized) return;
    
    PWLogInfo(@"Initializing host: %@", _hostParticipant);
    [_collaborationManager updateUserInfo:kPWCollaboratorName value:self.hostParticipant.name];
    [_collaborationManager updateUserInfo:kPWCollaboratorEmail value:self.hostParticipant.email];
    self.hostParticipant.sessionId = _collaborationManager.sessionId;
}

- (void)ownerDidChange
{
}

- (void)sessionsDidChange
{
    @synchronized(self)
    {
        [_collaborators removeAllObjects];
        for (PWGuid *sessionId in [_collaborationManager activeSessions])
        {
            PWXmlElement *userInfo = [_collaborationManager getSessionUserInfo:sessionId];
            PWLogVerbose(@"Userinfo for session %@: %@", sessionId, userInfo); 
            if (!userInfo) 
                continue;
            
            NSString *name = [userInfo getText:kPWCollaboratorName];
            NSString *email = [userInfo getText:kPWCollaboratorEmail];
            PWParticipantInfo *part = [PWParticipantInfo parciticipantWithName:name email:email sessionId:sessionId];
            if (part.name == nil)
                continue;
            
            PWLogVerbose(@"session: %@ | %@ | %@", part.sessionId, part.name, part.email);
            if ([sessionId isEqual:_collaborationManager.sessionId])
                self.hostParticipant = part;
            else
                [_collaborators addObject:part];
        }
    }
    
    [self.tableView reloadData];
}

@end
