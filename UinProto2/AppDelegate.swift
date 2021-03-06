//
//  AppDelegate.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 12/24/14.
//  Copyright (c) 2014 Kareem Dasilva. All rights reserved.
//

import UIKit
import MapKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)        // changes text color in tab bar
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.lightGrayColor()], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 83.0/255.0, green: 155.0/255.0, blue: 204.0/255.0, alpha: 1.0)], forState:.Selected)
        
        // changes tabBarItem color in tab bar
        UITabBar.appearance().tintColor = UIColor(red: 83.0/255.0, green: 155.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        
        //changes tabBarController background image
        UITabBar.appearance().backgroundImage = UIImage (named:"tabBarBackground.png")
        //changes color of tabBar
        //UITabBar.appearance().barTintColor = UIColor(red: 52.0/255.0, green: 126.0/255.0, blue: 187.0/255.0, alpha: 1.0)
        
        //Production
       //Mixpanel.sharedInstanceWithToken("9955bea4e861e38f30086091b171d9fd")
        
        // development key
        Mixpanel.sharedInstanceWithToken("9955bea4e861e38f30086091b171d9fdoirthg9e78r")
        

        //ParseCrashReporting.enable()
        //devolpment key
        //Parse.setApplicationId("HawWPTDabdo1FXdxMevotUNmVCwVl62wTkjiFyNg", clientKey: "Gj2fnhH0CkA6G1Hkl5igSQRooXeD3ByVBKjMF1Bq")
        
        //Production Key
         Parse.setApplicationId("BFxrzfMk4LK2WDbBdwtfeWmFcZwZwkMLdryiDPwm", clientKey: "tALwULorTkQbcVv3JHqVtTDrrelIZFSebtb0cHJs")
        
        //Set the user Time stamp
  
        let theMix = Mixpanel.sharedInstance()
        theMix.track("App Open")
        theMix.flush()
        
        
        var window: UIWindow?
        var locationManager: CLLocationManager?
        
        
                
                locationManager = CLLocationManager()
                locationManager?.requestAlwaysAuthorization()
   
     
        
       
        let userNotificationTypes: UIUserNotificationType = ([UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]);
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        //PFTwitterUtils.initializeWithConsumerKey("8UEyO7HCWxgi6qtNOrHlkNXQk",  consumerSecret:"UwR53WCjwtmac7RthglrliwtoJuNg8rT3R7bne3pkM5gzhu053")
       
    
        
    PFFacebookUtils.initializeFacebook()
    
 
        // Override point for customization after application launch.
        return true
    }
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
        
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()

        print("Success", terminator: "")
    
        
        
    }

    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError ) {
        
        print("Fail!", terminator: "")
    
    }
   

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        let theMix = Mixpanel.sharedInstance()
        theMix.track("App Close")
        theMix.flush()
        print("poop")
        var i = 0
        var poo = [CLLocation]()
        let locationmgr = CLLocationManager()
        locationmgr.delegate = self
        
        locationmgr.requestAlwaysAuthorization()
        if #available(iOS 9.0, *) {
            print(locationmgr.allowsBackgroundLocationUpdates)
        } else {
            // Fallback on earlier versions
        }
        locationmgr.startUpdatingLocation()
        
        
        while( i != 50){
        
            
            print(locationmgr.location?.coordinate.latitude)
            i++
        }
        
      
   
        
       
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
       }

    func applicationDidBecomeActive(application: UIApplication) {
     
       FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
        let install = PFInstallation.currentInstallation()
        if install.badge != 0 {
            
            install.badge = 0
            install.saveInBackground()
            
        }
       
        
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    

    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication,
            withSession:PFFacebookUtils.session())
    }
   


}

