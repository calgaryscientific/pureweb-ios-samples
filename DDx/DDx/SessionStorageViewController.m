//
//  SessionStorageViewController.m
//  DDx
//
//  Created by Jonathan Neitz on 2016-02-01.
//  Copyright © 2016 Calgary Scientific Inc. All rights reserved.
//

#import "SessionStorageViewController.h"
#import <PureWeb/PureWeb.h>
#import "SessionStorageViewCell.h"
#import "SessionStorageViewHeader.h"

@interface SessionStorageViewController ()

@property(nonatomic,strong) PWSessionStorage* storage;
@property(nonatomic,strong) UINib* sessionStorageViewCell;
@property(nonatomic,strong) UINib* sessionStorageViewHeader;

@end

@implementation SessionStorageViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

        self.sessionStorageViewCell = [UINib nibWithNibName:@"SessionStorageViewCell" bundle: nil];
        [self.tableView registerNib:self.sessionStorageViewCell forCellReuseIdentifier:@"SessionStorageViewCell"];
        
        self.sessionStorageViewHeader = [UINib nibWithNibName:@"SessionStorageViewHeader" bundle: nil];
        [self.tableView registerNib:self.sessionStorageViewHeader forCellReuseIdentifier:@"SessionStorageViewHeader"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.changeHandlers = [NSMutableDictionary new];
    self.tableView.allowsSelection = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 30;
    self.storage = [[PWFramework sharedInstance].client getSessionStorage];
    [self.tableView reloadData];
    
    
}

-(void)sessionStorageKeyAdded:(PWSessionStorageChangedEventArgs *)args {
    
    [self.storage addValueChangedHandler:[args getKey] target:self action:@selector(sessionStorageHandler:)];
    [self.tableView reloadData];
}

-(void)sessionStorageHandler:(PWSessionStorageChangedEventArgs*) args {
    
    if( [args getChangeType] == SessionStorageMessageRemove ) {
        [self.storage removeValueChangedHandler:[args getKey] target:self action:@selector(sessionStorageHandler:)];
    }
    
    [self.tableView reloadData];
}

- (void) valueChanged:(PWSessionStorageChangedEventArgs*)args {
    PWSessionStorage* storage = [[PWFramework sharedInstance].client getSessionStorage];
    
    
    if( [args getChangeType] == SessionStorageMessageSet ) {
        NSString* valueStr = [args getNewValue];
        NSMutableString* reverseStr = [NSMutableString new];
        
        for( NSInteger i = valueStr.length - 1 ; i >= 0; --i ) {
            [reverseStr appendString: [valueStr substringWithRange: NSMakeRange(i,1)]];
        }
        
        [storage setKey:[NSString stringWithFormat:@"R-%@", [args getKey]]
                toValue: reverseStr];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if( section == 0) {
        return 1;
    }
    
    return [self.storage getKeys].count;
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
        header.text = @" Set a new key:value";
    else if (section == 1)
        header.text = @" Session Storage contents";
    
    return header;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SessionStorageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SessionStorageViewCell"];
    
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
        {
            SessionStorageViewHeader *cell = [tableView dequeueReusableCellWithIdentifier:@"SessionStorageViewHeader"];
            
            return cell;
        }
        case 1:
        {
            NSArray* keys = [self.storage getKeys];
    
            if( keys == nil ) return cell;
    
            NSString* key = keys[indexPath.row];
            NSString* value = [self.storage getValue:key];
    
            cell.sessionStorageController = self;
            cell.keyLabel.text = key;
            cell.valueLabel.text = value;
            
            BOOL hasServiceListener = [self.changeHandlers[key] boolValue];
            cell.serviceListenerSwitch.on = hasServiceListener;
        }
    }
    
    return cell;
}

@end
