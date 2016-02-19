//
//  AppDelegate.swift
//  Asteroids
//
//  Created by Jonathan Neitz on 2016-02-10.
//  Copyright © 2016 Calgary Scientific Inc. All rights reserved.
//

import UIKit
import PureWeb

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
       
        var appUrl = NSURL()
        var authenticationRequired = true;
        
        registerDefaultsFromSettingsBundle()
        
        if let url = launchOptions?["UIApplicationLaunchOptionsURLKey"] as? NSURL {
            if let components = NSURLComponents(string: url.absoluteString) {
                components.scheme = "http";
                appUrl = components.URL!;
                
                print("Launching App From Incoming URL")
            }
        } else
        if let urlString = NSUserDefaults.standardUserDefaults().stringForKey("pureweb_url") {
            if let url = NSURL(string:urlString) {
                appUrl = url
                authenticationRequired = true
                
                print("Launching App From Settings URL")
            }
        }
        
        //pass the authentication and app url
      
        if let masterViewController = self.window!.rootViewController as? ViewController {
            masterViewController.setupWithAppURL(appUrl, authenticationRequired: authenticationRequired);
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func registerDefaultsFromSettingsBundle()
    {
        if let settingsBundle = NSBundle.mainBundle().pathForResource("Settings", ofType: "bundle") {

            if let settings = NSDictionary(contentsOfFile: settingsBundle + "/Root.plist") {
                if let preferences = settings.objectForKey("PreferenceSpecifiers") as? NSArray {
    
                    var defaultsToRegister = [String:AnyObject]()
                        
                        for value in preferences {
                            
                            if let prefSpecification = value as? NSDictionary {
                                
                                if let key = prefSpecification["Key"] as? String {
                                    defaultsToRegister[key] = prefSpecification["DefaultValue"]
                                }
                            }
                        }
                    
                    NSUserDefaults.standardUserDefaults().registerDefaults(defaultsToRegister)
                }
            }
        }
    }
    
    
 }

