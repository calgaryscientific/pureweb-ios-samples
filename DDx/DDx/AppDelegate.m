//
//  AppDelegate.m
//  DDxSample
//
//  Created by Chris Garrett on 4/11/12.
//  Copyright (c) 2012 Calgary Scientific Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "PWLoginViewController.h"
#import "UIAlertView+PWUtils.h"
#import "TabViewController.h"
#import "DDxViewController.h"
#import "PGViewController.h"
#import "PWCollaborationViewController.h"
#import "AspectRatioViewController.h"
#import "BabelViewController.h"
#import "NSURL+URLHelpers.h"
#import "SessionStorageViewController.h"


@interface AppDelegate()

@property(nonatomic,strong) SessionStorageViewController* sessionStorageController;

@end

@implementation AppDelegate



#pragma mark -
#pragma mark Properties

@synthesize url = _url;
@synthesize window;
@synthesize viewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
//    BOOL wait = YES;
//    while (wait)
//    {
//        [NSThread sleepForTimeInterval:1.0]; // Set breakpoint here for debugging
//        // In the debugger, change "wait" to NO once the debugger is attached
//    }

    //[PWLog setLogLevel:PWLogLevelNetwork];
    
    [PWUtility registerDefaultsFromSettingsBundle];

    [PWFramework sharedInstance].delegate = self;
    [PWFramework sharedInstance].client.delegate = self;
    
    self.url = [launchOptions objectForKey:@"UIApplicationLaunchOptionsURLKey"];
    
    // If we are launching normally self.url should be nil. If its not we were launched from a URL
    if (!self.url)
    {
        NSString *server_url = [[NSUserDefaults standardUserDefaults] stringForKey:@"pureweb_url"];
        
        // load the url from settings if we weren't passed one
        self.url = [NSURL URLWithString:server_url];
        
        if (!self.url)
        {
            PWLogError(@"Failed to get server URL!!");
            return NO;
        }
    } 
    

    PWLoginViewController *loginViewController = [[PWLoginViewController alloc] initWithHref:[self.url absoluteString]];
    PWNavigationController *navigationController = [[PWNavigationController alloc] initWithRootViewController:loginViewController];
    
    self.viewController = navigationController;
    self.viewController.navigationBar.barStyle = UIBarStyleDefault;
   

    window.rootViewController = self.viewController;
    [window makeKeyAndVisible];    
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
    if ([PWFramework sharedInstance].client.isConnected)
        [[PWFramework sharedInstance].client disconnectSynchronous];
}

- (void)applicationWillResignActive:(UIApplication *)application 
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application 
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


#pragma mark -
#pragma mark PWFramework Delegates

-(void)sessionIdChanged
{
}

-(void)stateInitialized
{
    PWLogVerbose(@"Initial State:\n%@", [[PWFramework sharedInstance].state.stateManager getTree:@"/"]);
}

#pragma mark -
#pragma mark PWWebClient Delegates

- (void)connectedChanged
{
    BOOL connected = [PWFramework sharedInstance].client.isConnected;
    
    if(!connected) {
        // Notify users that the session has been disconnected
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = @"Session has lost connection to service.\n Reopen the application to begin a new connection.";
            UIAlertController *alerts = [UIAlertController alertControllerWithTitle:@"Session Disconnected" message:message preferredStyle:UIAlertControllerStyleAlert];
            [self.viewController presentViewController:alerts animated:YES completion:nil];
        });
    }
}

- (void)stalledChanged
{
}

- (void)requestInProgressChanged
{
}

- (void)sessionStateChanged
{
    switch ([PWFramework sharedInstance].client.sessionState)
    {
        case PWSessionStateActive:
        {
            TabViewController *tabViewController = [[TabViewController alloc] init];

            DDxViewController *ddxViewController = [[DDxViewController alloc] init];
            ddxViewController.framework = [PWFramework sharedInstance];
            [ddxViewController.tabBarItem setTitle:@"DDx View"];
            [ddxViewController.tabBarItem setImage:[UIImage imageNamed:@"103-map.png"]];

            PGViewController *pgViewController = [[PGViewController alloc] init];
            [pgViewController.tabBarItem setTitle:@"PG View"];
            [pgViewController.tabBarItem setImage:[UIImage imageNamed:@"46-movie-2.png"]];
            
            PWCollaborationViewController *collaborationViewController = [[PWCollaborationViewController alloc] init];
            collaborationViewController.collaborationManager = [PWFramework sharedInstance].collaborationManager;
            [collaborationViewController.tabBarItem setTitle:@"Collaboration"];
            [collaborationViewController.tabBarItem setImage:[UIImage imageNamed:@"111-user.png"]];
            
            AspectRatioViewController *aspectViewController = [[AspectRatioViewController alloc] init];
            [aspectViewController.tabBarItem setTitle:@"Aspect Ratio"];
            [aspectViewController.tabBarItem setImage:[UIImage imageNamed:@"186-ruler.png"]];
            
            BabelViewController *babelViewController = [[BabelViewController alloc] init];
            [babelViewController.tabBarItem setTitle:@"Babel"];
            [babelViewController.tabBarItem setImage:[UIImage imageNamed:@"08-chat.png"]];
            
            self.sessionStorageController = [[SessionStorageViewController alloc] init];
            [self.sessionStorageController.tabBarItem setTitle:@"Session Storage"];
            [self.sessionStorageController.tabBarItem setImage:[UIImage imageNamed:@"103-map.png"]];
            
            [tabViewController setViewControllers:[NSArray arrayWithObjects:ddxViewController,
                                                                            pgViewController, 
                                                                            collaborationViewController,
                                                                            aspectViewController,
                                                                            babelViewController,
                                                                            self.sessionStorageController,
                                                                            nil]];

            
            [self.viewController pushViewController:tabViewController animated:YES];
            
        } break;
        case PWSessionStateFailed:
        case PWSessionStateUnknown:            
        case PWSessionStateDisconnected:
        case PWSessionStateConnecting:
        case PWSessionStateStalled:
        case PWSessionStateTerminated:
            break;
    }    
}


- (void)minimumRequestIntervalChanged
{
}

-(void)sessionStorageKeyAdded:(PWSessionStorageChangedEventArgs *)args {
    
    [self.sessionStorageController sessionStorageKeyAdded:args];
    [self.sessionStorageController.tableView reloadData];
}

@end


