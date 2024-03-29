//
//  AppDelegate.swift
//  Rippal
//
//  Created by Tao Wang on 1/23/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import CoreLocation
import UIKit
import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Determine whether to go to login screen or home screen
        let initialViewController:UIViewController
        // TODO: check session and session expire in TabBarController
        if UserHelper.sharedInstance.isLoggedIn() {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
        } else {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "EntryVC")
        }
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        FacebookCore.SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // TODO: check for location permission
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if UIApplication.shared.isIgnoringInteractionEvents && (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
            // Restart all functionalities if location permission given
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if LISDKCallbackHandler.shouldHandle(url) {
            return LISDKCallbackHandler.application(app, open: url, sourceApplication: nil, annotation: nil)
        }
        let handled:Bool = FacebookCore.SDKApplicationDelegate.shared.application(app, open: url, options: options)
        if handled {
            return handled
        }
        return false
    }

}

