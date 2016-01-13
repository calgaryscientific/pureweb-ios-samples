//  AppStateViewController.m
//
//  Created by Chris Burns on 2/10/14.
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.


#import "AppStateViewController.h"

#import <PureWeb/PureWeb.h>

@interface AppStateViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *appStateWebView;

@end

@implementation AppStateViewController

- (void)viewDidLoad
{
    NSString *xml = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" ?>%@",
                     [[[PWFramework sharedInstance].state.stateManager getTree:@"/"] description]];
    
    
    [self.appStateWebView loadData:[xml dataUsingEncoding:NSUTF8StringEncoding]
                          MIMEType:@"text/plain"
                  textEncodingName:@"utf-8"
                           baseURL:[NSURL URLWithString:@"http://"]];
    
    
    [super viewDidLoad];
}



@end
