//
//  AppDelegate.swift
//  SalesGame_swift
//
//  Created by Akuma on 9/11/15.
//  Copyright (c) 2015 Akuma. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigation : UINavigationController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.enableLocalDatastore()
        Parse.setApplicationId("mg1qP8MFKOVjykmN3Aha6Q47L6XtuNQLIyVKFutU", clientKey:"mgY2o0pSQNhL5u7PWIj84ZzzPMXXRRsqeeuhnlma")
        var storyboard : UIStoryboard!
        if IS_iPad {
            storyboard = UIStoryboard(name: "Main_ipad", bundle: nil)
        } else {
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        }

        navigation = storyboard.instantiateViewControllerWithIdentifier("MainNavigation") as! UINavigationController
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.makeKeyAndVisible()
        navigation.view.frame = window!.bounds
        self.window!.rootViewController = navigation
        
        if (NSUserDefaults.standardUserDefaults().valueForKey(kTimer) == nil) {
            NSUserDefaults.standardUserDefaults().setValue("YES" , forKey: kTimer)
        }
        if (NSUserDefaults.standardUserDefaults().valueForKey(kSound) == nil) {
            NSUserDefaults.standardUserDefaults().setValue("YES" , forKey: kSound)
        }
        if (NSUserDefaults.standardUserDefaults().valueForKey(kVibrate) == nil) {
            NSUserDefaults.standardUserDefaults().setValue("YES" , forKey: kVibrate)
        }
        
        
        if (NSUserDefaults.standardUserDefaults().valueForKey(kFiftyFiftyCount) == nil) {
            NSUserDefaults.standardUserDefaults().setValue("5" as String, forKey: kFiftyFiftyCount)
        }
        
        if (NSUserDefaults.standardUserDefaults().valueForKey(kSkipCount) == nil) {
            NSUserDefaults.standardUserDefaults().setValue("5" as String, forKey: kSkipCount)
        }
        
        if (NSUserDefaults.standardUserDefaults().valueForKey(kTimerCount) == nil) {
            NSUserDefaults.standardUserDefaults().setValue("5" as String, forKey: kTimerCount)
        }


        // Override point for customization after application launch.
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


}

