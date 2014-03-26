//
//  DDxSettingsViewController.m
//  DDxSample
//
//  Created by Chris Garrett on 5/1/12.
//  Copyright (c) 2012 Calgary Scientific Inc. All rights reserved.
//

#import "DDxSettingsViewController.h"
#import "PWLog.h"

@interface DDxSettingsViewController ()
{
    NSArray *items;
}

@end

@implementation DDxSettingsViewController

@synthesize delegate = _delegate;
@synthesize gridSize = _gridSize;
@synthesize inputTransmission = _inputTransmission;
@synthesize enabled = _enabled;
@synthesize doneButton = _doneButton;

- (void)_init
{
    _enabled = [[UISwitch alloc] init];
    [_enabled addTarget:self action:@selector(gridEnabledDidChange:) forControlEvents:UIControlEventValueChanged];
    
    _gridSize = [[UISlider alloc] init];
    _gridSize.minimumValue = 50.0f;
    _gridSize.maximumValue = 200.0f;
    _gridSize.value = 100.0f;
    [_gridSize addTarget:self action:@selector(gridSizeDidChange:) forControlEvents:UIControlEventValueChanged];
    
    _inputTransmission = [[UISwitch alloc] init];
    [_inputTransmission addTarget:self action:@selector(inputTransmissionDidChange:) forControlEvents:UIControlEventValueChanged];
    

    items = @[
        @{ @"title" : @"General",
           @"selectable" : @(NO),
           @"items" : @[
                @{ @"title":@"Grid enabled", @"accessory":_enabled },
                @{ @"title":@"Grid size", @"accessory":_gridSize },
                @{ @"title":@"Input transmission", @"accessory":_inputTransmission }
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
    self = [super initWithNibName:@"DDxSettingsViewController" bundle:nibBundleOrNil];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneWasPushed:)];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationItem.rightBarButtonItem = _doneButton;
}

- (void)viewDidUnload
{
    [self setInputTransmission:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#ifdef __IPHONE_6_0

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
#endif

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)gridEnabledDidChange:(id)sender
{
    if (_delegate && [_delegate conformsToProtocol:@protocol(DDxSettingsViewControllerDelegate)])
        [_delegate gridEnabledDidChange:self.enabled.on];
}

- (void)gridSizeDidChange:(id)sender
{
    if (_delegate && [_delegate conformsToProtocol:@protocol(DDxSettingsViewControllerDelegate)])
        [_delegate gridSizeDidChange:self.gridSize.value];
}

- (void)doneWasPushed:(id)sender
{
    if (_delegate && [_delegate conformsToProtocol:@protocol(DDxSettingsViewControllerDelegate)])
        [_delegate doneWasPushed];
}

- (void)clearWasPushed:(id)sender
{
    if (_delegate && [_delegate conformsToProtocol:@protocol(DDxSettingsViewControllerDelegate)])
        [_delegate clearWasPushed];
}

- (void)inputTransmissionDidChange:(id)sender
{
    if (_delegate && [_delegate conformsToProtocol:@protocol(DDxSettingsViewControllerDelegate)])
        [_delegate inputTransmissionDidChange:self.inputTransmission.on];
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
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL selectable = [[[items objectAtIndex:indexPath.section] objectForKey:@"selectable"] boolValue];
    
    if (!selectable)
        return nil;
    
    return indexPath;
}

@end
