//  AppDelegate.m
//
//  Created by Chris Burns on 2/10/14.
//  Copyright 2014 Calgary Scientific Inc. All rights reserved.

#import "AppDelegate.h"
#import "MasterViewController.h"
#import <PureWeb/PureWeb.h>
#import <PureWeb/PWLog.h>
#import <PureWeb/PureWeb.h>

#import "NSURL+URLHelpers.h"

#pragma mark -
@implementation AppDelegate

#pragma mark Lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //debug wait loop, this is useful if you want to attach and debug the application without launching it
    [self debugWaitLoop];
    
    //setup pureweb logging
    [PWLog setLogLevel:PWLogLevelVerbose];
    
    //determine how to start the the pureweb session, this determines the url for connecting and whether authentication is needed
    NSURL *appURL;
    BOOL authenticationRequired;
    
    //app was launched via incoming url, this is likely a collaboration url and so we join without username/password authentication
    if ([self wasLaunchedFromURL:launchOptions]) {
        
        appURL = [launchOptions objectForKey:@"UIApplicationLaunchOptionsURLKey"];
        appURL = [appURL URLByReplacingScheme]; //it is necessary to remove the scheme which allows the link to be opened in ios
        
        authenticationRequired = NO;
        
        PWLogInfo(@"Launching App From Incoming URL");
    }
    
    //app was launched via settings url, this is provided by the user via the settings bundle and authentication is needed
//    else if ([self wasLaunchedFromSettingsUrl]) {
//        
//        NSString *appURLString = [[NSUserDefaults standardUserDefaults] stringForKey:@"pureweb_url"];
//        
//        appURL = [NSURL URLWithString:appURLString];
//        authenticationRequired = YES; 
//        
//        PWLogInfo(@"Launching App From Settings URL");
//    }
    
    //app was launched via fallback url, this is typically useful for default choices or as a development fallback
    else {
        
        appURL = [NSURL URLWithString:@"http://winterfell:8080/pureweb/app?name=ScribbleAppJava"];
        authenticationRequired = YES;
        
        PWLogInfo(@"Launching App From Fallback URL");
    }
    
    //pass the authentication and app url
    MasterViewController *masterViewController = (MasterViewController*) self.window.rootViewController;
    [masterViewController setupWithAppURL:appURL withRequiredAuthentication:authenticationRequired];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    MasterViewController *masterViewController = (MasterViewController*) self.window.rootViewController;
    [masterViewController stop];
}

#pragma mark Utility Methods
//debug waiting loop
- (void)debugWaitLoop {
    
    BOOL wait = YES;
    while (wait)
    {
        [NSThread sleepForTimeInterval:1.0];
        //break and set using lldb expr wait = NO
    }
    
}
//some apps are launched via an incoming URL. The key for this URL is stored in the launch options and if the key is present
//we should immediately connect to the session described by that URL.
- (BOOL) wasLaunchedFromURL:(NSDictionary *) launchDictionary
{
    return ([launchDictionary objectForKey:@"UIApplicationLaunchOptionsURLKey"] != nil);
    
}
//some apps connect to a url defined in the settings bundle. If the key pureweb_url is defined in the settings bundle then
//launch using that URL.
- (BOOL) wasLaunchedFromSettingsUrl
{
    [PWUtility registerDefaultsFromSettingsBundle];
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"pureweb_url"] != nil;
    
}
@end
