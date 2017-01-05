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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        var appUrl: URL!
        var authenticationRequired = true;
        
        registerDefaultsFromSettingsBundle()
        
        if let url = launchOptions?[UIApplicationLaunchOptionsKey.url] as? URL {
            if var components = URLComponents(string: url.absoluteString) {
                let secureScheme = UserDefaults.standard.bool(forKey: "pureweb_collab_secure")
                
                components.scheme = "http";
                
                if secureScheme {
                    components.scheme = "https";
                }
                
                appUrl = components.url!;
                
                print("Launching App From Incoming URL")
                
                authenticationRequired = false;
            }
            
        } else
        if let urlString = UserDefaults.standard.string(forKey: "pureweb_url") {
            if let url = URL(string:urlString) {
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

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if PWFramework.sharedInstance().client().isConnected {
            PWFramework.sharedInstance().client().disconnectSynchronous()
        }

    }

    func registerDefaultsFromSettingsBundle()
    {
        if let settingsBundle = Bundle.main.path(forResource: "Settings", ofType: "bundle") {

            if let settings = NSDictionary(contentsOfFile: settingsBundle + "/Root.plist") {
                if let preferences = settings.object(forKey: "PreferenceSpecifiers") as? NSArray {
    
                    var defaultsToRegister = [String:AnyObject]()
                        
                        for value in preferences {
                            
                            if let prefSpecification = value as? NSDictionary {
                                
                                if let key = prefSpecification["Key"] as? String {
                                    let value = prefSpecification["DefaultValue"] as AnyObject
                                    defaultsToRegister[key] = value
                                }
                            }
                        }
                    
                    UserDefaults.standard.register(defaults: defaultsToRegister)
                }
            }
        }
    }
    
    
 }

