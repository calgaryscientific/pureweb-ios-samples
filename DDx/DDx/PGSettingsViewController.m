//
//  PGSettingsViewController.m
//  DDxSample
//
//  Created by Chris Garrett on 5/1/12.
//  Copyright (c) 2012 Calgary Scientific Inc. All rights reserved.
//

#import "PGSettingsViewController.h"
#import "PWLog.h"

@interface PGSettingsViewController ()
{
    NSArray *items;
}

@end

@implementation PGSettingsViewController

@synthesize delegate = _delegate;
@synthesize asyncImageGeneration = _asyncImageGeneration;
@synthesize useDeferredRendering = _useDeferredRendering;
@synthesize useClientSize = _useClientSize;
@synthesize showMousePosition = _showMousePosition;
@synthesize screenshotButton = _screenshotButton;

- (void)_init
{
    _asyncImageGeneration = [[UISwitch alloc] init];
    [_asyncImageGeneration addTarget:self action:@selector(asyncImageGenerationDidChange:) forControlEvents:UIControlEventValueChanged];
    _useDeferredRendering = [[UISwitch alloc] init];
    [_useDeferredRendering addTarget:self action:@selector(useDeferredRenderingDidChange:) forControlEvents:UIControlEventValueChanged];
    _useClientSize = [[UISwitch alloc] init];
    [_useClientSize addTarget:self action:@selector(useClientSizeDidChange:) forControlEvents:UIControlEventValueChanged];
    _showMousePosition = [[UISwitch alloc] init];
    [_showMousePosition addTarget:self action:@selector(showMousePositionDidChange:) forControlEvents:UIControlEventValueChanged];
    _screenshotButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _screenshotButton.frame = CGRectMake(0,0,79,27);
    [_screenshotButton setTitle:@"Capture" forState:UIControlStateNormal];
    [_screenshotButton addTarget:self action:@selector(screenshotButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
    items = @[
        @{ @"title" : @"General",
           @"selectable" : @(NO),
           @"items" : @[
            @{ @"title":@"Async Image Generation", @"accessory":_asyncImageGeneration },
            @{ @"title":@"Use Deferred Rendering", @"accessory":_useDeferredRendering },
            @{ @"title":@"Use Client Size", @"accessory":_useClientSize },
            @{ @"title":@"Show Mouse Position", @"accessory":_showMousePosition },
            @{ @"title":@"Capture Screenshot", @"accessory":_screenshotButton }
        ]},
        @{ @"title" : @"Remote Image Format",
           @"selectable" : @(YES),
           @"items" : @[
            @{ @"title":@"Tile" },
            @{ @"title":@"Jpeg" },
            @{ @"title":@"Png" }
        ]}
    ];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self _init];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneWasPushed:)];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationItem.rightBarButtonItem = done;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (void)doneWasPushed:(id)sender
{
    if (_delegate && [_delegate conformsToProtocol:@protocol(PGSettingsViewControllerDelegate)])
        [_delegate doneWasPushed];
}

- (void)asyncImageGenerationDidChange:(id)sender
{
    if (_delegate && [_delegate conformsToProtocol:@protocol(PGSettingsViewControllerDelegate)])
        [_delegate asyncImageGenerationDidChange:self.asyncImageGeneration.on];
}

- (void)useDeferredRenderingDidChange:(id)sender
{
    if (_delegate && [_delegate conformsToProtocol:@protocol(PGSettingsViewControllerDelegate)])
        [_delegate useDeferredRenderingDidChange:self.useDeferredRendering.on];
}

- (void)useClientSizeDidChange:(id)sender
{
    if (_delegate && [_delegate conformsToProtocol:@protocol(PGSettingsViewControllerDelegate)])
        [_delegate useClientSizeDidChange:self.useClientSize.on];
}

- (void)showMousePositionDidChange:(id)sender
{
    if (_delegate && [_delegate conformsToProtocol:@protocol(PGSettingsViewControllerDelegate)])
        [_delegate showMousePositionDidChange:self.showMousePosition.on];
}

- (void)screenshotButtonTouchUpInside:(id)sender
{
    if (_delegate && [_delegate conformsToProtocol:@protocol(PGSettingsViewControllerDelegate)])
        [_delegate screenshotButtonTouchUpInside];    
}

- (void)mimeTypeDidChange:(NSString *)mimeType
{
    self.selectedMimeType = mimeType;
    if (_delegate && [_delegate conformsToProtocol:@protocol(PGSettingsViewControllerDelegate)])
    {
        [_delegate mimeTypeDidChange:mimeType];
    }
}

#pragma mark - UITableViewDataSource
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[items objectAtIndex:section] objectForKey:@"title"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rows = [[items objectAtIndex:section] objectForKey:@"items"];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDxCell"];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DDxCell"];
    
    if (cell)
    {
        NSDictionary *item = [[[items objectAtIndex:indexPath.section] objectForKey:@"items"] objectAtIndex:indexPath.row];
        if (item)
        {
            cell.textLabel.text = [item objectForKey:@"title"];
            
            UIView *accessory = [item objectForKey:@"accessory"];
            if (accessory)
                cell.accessoryView = accessory;
        }
        else
        {
            PWLogError(@"Error getting cell!!");
        }
        
        // MimeType
        if (indexPath.section == 1)
        {
            if ( [[[self mimeTypes] objectAtIndex:indexPath.row] isEqual:self.selectedMimeType])
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate
#pragma mark -

- (NSArray *)mimeTypes
{
    static NSArray *mimeTypes;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mimeTypes = @[kSupportedEncoderMimeTypeTiles, kSupportedEncoderMimeTypeJpeg, kSupportedEncoderMimeTypePng];
    });
    
    return mimeTypes;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // RemoteImageFormat
    if (indexPath.section == 1)
        [self mimeTypeDidChange:[[self mimeTypes] objectAtIndex:indexPath.row]];
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL selectable = [[[items objectAtIndex:indexPath.section] objectForKey:@"selectable"] boolValue];
    
    if (!selectable)
        return nil;
    
    return indexPath;
}

@end
