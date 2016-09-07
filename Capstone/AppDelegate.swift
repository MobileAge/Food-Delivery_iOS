//
//  AppDelegate.swift
//  Capstone
//
//  Created by MobileAge Team on 9/25/15.
//  Copyright © 2015 MobileAge Team. All rights reserved.
//

import UIKit
import Parse
import ParseTwitterUtils
import ParseFacebookUtilsV4
import MMDrawerController
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var centerContainer: MMDrawerController?
    var count: Int?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId("zvhXcEZ8w8FRpjCV4Kpsgo8LK1NbXgc1BxuOsbtV",
            clientKey: "Zjp5wewW8WW5HqqVlkzTlohJq7WvCKkcvdERGfpm")
        
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
                
        PFTwitterUtils.initializeWithConsumerKey("A9XzEBtc52Oc89GBnvI31EqB3", consumerSecret: "UObkkdmsvnP7xMsUrqVDdtjjYMlyxscS0RXvR31u5YVbNVW190")
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        GMSServices.provideAPIKey("AIzaSyD6A3UC612PRvsyUIk_t5odUkVZveXjO0w")

        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if PFUser.currentUser() == nil {
            mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController")
        } else {
            loadMainView()
        }
        
        
        self.count = 0

        return true
    }
    
    func loadMainView() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let centerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        let leftViewController = mainStoryboard.instantiateViewControllerWithIdentifier("DrawerTableViewController") as! DrawerTableViewController
        
        let leftSideNav = UINavigationController(rootViewController: leftViewController)
        let centerNav = UINavigationController(rootViewController: centerViewController)
        
        centerContainer = MMDrawerController(centerViewController: centerNav, leftDrawerViewController: leftSideNav)
        centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView;
        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView;
        
        window!.rootViewController = centerContainer
        window!.makeKeyAndVisible()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
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
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func incrementNetworkActivity() {
        self.count!++
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func decrementNetworkActivity() {
        if self.count! > 0 {
            self.count!--
        }
        if self.count! == 0 {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func resetNetworkActivity() {
        self.count! = 0
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }


}

