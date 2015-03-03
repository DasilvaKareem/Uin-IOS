//
//  AppDelegate.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 12/24/14.
//  Copyright (c) 2014 Kareem Dasilva. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)        // changes text color in tab bar
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.lightGrayColor()], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 83.0/255.0, green: 155.0/255.0, blue: 204.0/255.0, alpha: 1.0)], forState:.Selected)
        
        // changes tabBarItem color in tab bar
        UITabBar.appearance().selectedImageTintColor = UIColor(red: 83.0/255.0, green: 155.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        
        //changes tabBarController background image
        UITabBar.appearance().backgroundImage = UIImage (named:"tabBarBackground.png")
        //changes color of tabBar
        //UITabBar.appearance().barTintColor = UIColor(red: 52.0/255.0, green: 126.0/255.0, blue: 187.0/255.0, alpha: 1.0)
        
        
        Mixpanel.sharedInstanceWithToken("fcf630f4f509d2ddeb0eef355102b65a")
        
             ParseCrashReporting.enable()
    
         Parse.setApplicationId("xEk0BIl2EyPBYEcWEz8SIHykycv4Yh0CfoYM2OOv", clientKey: "9p0BTN0Fm2mSr1LwEBPk7pJ21NGv2PfM58WJcmmy")
   
    
        
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: {
            (success:Bool!, error:NSError!) -> Void in
            
            if error == nil {
                
                println("Success")
            }
            
            
        })
       
        let userNotificationTypes = (UIUserNotificationType.Alert |
            UIUserNotificationType.Badge |
            UIUserNotificationType.Sound);
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    
        
    PFFacebookUtils.initializeFacebook()
        // Override point for customization after application launch.
        return true
    }
    func application( application: UIApplication!, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData! ) {
        
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.save()

        println("Success")
    
        
        
    }
    
    func application( application: UIApplication!, didFailToRegisterForRemoteNotificationsWithError error: NSError! ) {
        
        println("Fail!")
        let data = [
            "alert" : "The Mets scored! The game is now tied 1-1!",
            "badge" : "Increment",
            "sounds" : "cheering.caf"
        ]
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
       FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
        let install = PFInstallation.currentInstallation()
        if install.badge != 0 {
            
            install.badge = 0
            install.save()
            
        }
        
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(application: UIApplication, openURL url: NSURL,
        sourceApplication: NSString, annotation: AnyObject) -> Bool {
            return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication,
                withSession:PFFacebookUtils.session())
    }
    
   


}

