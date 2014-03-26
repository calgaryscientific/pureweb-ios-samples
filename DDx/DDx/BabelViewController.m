//
//  BabelViewController.m
//  DDxSample
//
//  Created by Sam Leitch on 12-06-08.
//  Copyright (c) 2012 Calgary Scientific Inc. All rights reserved.
//

#import "BabelViewController.h"
#import "LocaleData.h"
#import "PWFramework.h"

static NSString * const kBabelControlCell = @"BabelControlCell";
static NSInteger const kBabelControlCellRunTag = 5;
static NSInteger const kBabelControlCellResetTag = 6;

static NSString * const kBabelViewCell = @"BabelViewCell";
static NSInteger const kBabelViewCellLanguageTag = 1;
static NSInteger const kBabelViewCellPhraseTag = 2;
static NSInteger const kBabelViewCellCommandResponseTag = 3;
static NSInteger const kBabelViewCellAppStateTag = 4;

static NSString * const kGoodImageName = @"Good.png";
static NSString * const kBadImageName = @"Bad.png";

static NSString * const kDDxEchoPath = @"/DDx/Echo/";

@interface BabelViewController ()

@end

@implementation BabelViewController

#pragma mark UIViewController
#pragma mark -

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _localeData = [NSArray arrayWithObjects:
                       [LocaleData localeDataWithKey:@"de-DE" type:@"Text" content:@"Kennwortänderung fehlgeschlagen."],
                       [LocaleData localeDataWithKey:@"en-US" type:@"Text" content:@"Password change failed!"],
                       [LocaleData localeDataWithKey:@"es-ES" type:@"Text" content:@"Error al cambiar la contraseña."],
                       [LocaleData localeDataWithKey:@"fr-FR" type:@"Text" content:@"Le changement de mot de passe a échoué."],
                       [LocaleData localeDataWithKey:@"it-IT" type:@"Text" content:@"Modifica password non riuscita."],
                       [LocaleData localeDataWithKey:@"jp-JP" type:@"Text" content:@"パスワードの変更に失敗しました!"],
                       [LocaleData localeDataWithKey:@"ko-KR" type:@"Text" content:@"암호 다시 설정 실패"],
                       [LocaleData localeDataWithKey:@"zh-CN" type:@"Text" content:@"密码更改失败!"],
                       [LocaleData localeDataWithKey:@"zh-TW" type:@"Text" content:@"變更密碼失敗！"],
                       [LocaleData localeDataWithKey:@"unicode-escape" type:@"Text" content:@"\u0ca0_\u0ca0"],
                         nil];
        
        self.tableView.allowsSelection = NO;

        _cellLoader = [UINib nibWithNibName:kBabelViewCell bundle:[NSBundle mainBundle]];
        _controlCellLoader = [UINib nibWithNibName:kBabelControlCell bundle:[NSBundle mainBundle]];
        _headerLoader = [UINib nibWithNibName:@"BabelViewHeader" bundle:[NSBundle mainBundle]];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    for (LocaleData *phrase in _localeData)
    {
        NSString *path = [NSString stringWithFormat:@"%@%@", kDDxEchoPath, phrase.key];
        [[PWFramework sharedInstance].state.stateManager addValueChangedHandler:path target:self action:@selector(echoStateHasChanged:)];
    }

    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    for (LocaleData *phrase in _localeData)
    {
        NSString *path = [NSString stringWithFormat:@"%@%@", kDDxEchoPath, phrase.key];
        [[PWFramework sharedInstance].state.stateManager removeValueChangedHandler:path target:self action:@selector(echoStateHasChanged:)];
    }
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

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
#endif

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Private Methods
#pragma mark -

- (void)loadStatusImageforView:(UIImageView *)view phrase:(NSString *)phrase response:(NSString *)response
{
    BOOL valid = ![response isEqualToString:@""];
    BOOL same = [phrase isEqualToString:response];
    UIImage *image = same ? [UIImage imageNamed:kGoodImageName] : [UIImage imageNamed:kBadImageName];
    view.image = image;
    view.hidden = !valid;
}

- (void)echoStateHasChanged:(PWValueChangedEventArgs *)args
 {
     NSString *key = [args.path substringFromIndex:[kDDxEchoPath length]];
     NSString *appPhrase = args.newValue;
     
     for(LocaleData *phrase in _localeData)
     {
         if(![phrase.key isEqualToString:key]) continue;
         
         phrase.appState = appPhrase;
     }
     
     [self.tableView reloadData];
 }

- (void)echoDidRespond:(PWCommandResponseEventArgs *)args
{
    NSString *key = [args.response getText:@"Key"];
    //NSString *type = [args.response getText:@"Type"]; //TODO: Add type handling
    NSString *content = [args.response getText:@"Content"];
    
    for(LocaleData *phrase in _localeData)
    {
        if(![phrase.key isEqualToString:key]) continue;
        
        phrase.commandResponse = content;
    }
    
    [self.tableView reloadData];
}

#pragma mark UITableViewController
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 1 ? [_localeData count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    switch (section) {
        case 0:
            return [self tableView:tableView babelControlCellForRowAtIndexPath:indexPath];
        case 1:
            return [self tableView:tableView babelViewCellForRowAtIndexPath:indexPath];
        default:
            break;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView babelViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBabelViewCell];
    
    if(!cell)
    {
        cell = [[_cellLoader instantiateWithOwner:nil options:nil] objectAtIndex:0];
    }
    
    LocaleData *phrase = [_localeData objectAtIndex:indexPath.row];
    UILabel *languageLabel = (UILabel *)[cell viewWithTag:kBabelViewCellLanguageTag];
    UILabel *phraseLabel = (UILabel *)[cell viewWithTag:kBabelViewCellPhraseTag];
    UIImageView *commandResponseImage = (UIImageView *)[cell viewWithTag:kBabelViewCellCommandResponseTag];
    UIImageView *appStateImage = (UIImageView *)[cell viewWithTag:kBabelViewCellAppStateTag];
    
    languageLabel.text = phrase.key;
    phraseLabel.text = phrase.content;
    [self loadStatusImageforView:commandResponseImage phrase:phrase.content response:phrase.commandResponse];
    [self loadStatusImageforView:appStateImage phrase:phrase.content response:phrase.appState];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView babelControlCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBabelControlCell];
    
    if(!cell)
    {
        cell = [[_controlCellLoader instantiateWithOwner:nil options:nil] objectAtIndex:0];
        
        UIButton *runButton = (UIButton *)[cell viewWithTag:kBabelControlCellRunTag];
        UIButton *resetButton = (UIButton *)[cell viewWithTag:kBabelControlCellResetTag];
        
        [runButton addTarget:self action:@selector(runTestWasPushed) forControlEvents:UIControlEventTouchUpInside];
        [resetButton addTarget:self action:@selector(resetResultsWasPushed) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 1 ? 22 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0) return nil;
    
    UIView *header = [[_headerLoader instantiateWithOwner:nil options:nil] objectAtIndex:0];
    header.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sectionheaderbackground.png"]];
    
    return header;
}

#pragma mark - BabelSettingsViewControllerDelegate
#pragma mark -

- (void)resetResultsWasPushed
{
    for(LocaleData *phrase in _localeData)
    {
        NSString *path = [NSString stringWithFormat:@"%@%@", kDDxEchoPath, phrase.key];
        [[PWFramework sharedInstance].state.stateManager setValue:path value:@""];
        phrase.appState = @"";
        phrase.commandResponse = @"";
    }
    
    [self.tableView reloadData];
}

- (void) runTestWasPushed
{
    for(LocaleData *phrase in _localeData)
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                phrase.key, @"Key",
                                phrase.type, @"Type",
                                phrase.content, @"Content",
                                nil];
        
        [[PWFramework sharedInstance].client queueCommand:@"Echo" withParameters:params onComplete:^(PWCommandResponseEventArgs *args) 
        { 
            [self echoDidRespond:args];
        }];
    }
}

@end
