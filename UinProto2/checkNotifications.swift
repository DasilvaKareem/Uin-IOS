//
//  checkNotifications.swift
//  Uin
//
//  Created by Sir Lancelot on 3/11/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import Foundation
import UiKit


public struct currentNotifications {
    var old = (Int)()
    var newCheck = (Int)()
}
public func notifications() {
    var currentNotification = currentNotifications()
    var check = PFQuery(className: "Notification")
    check.whereKey("receiver", equalTo: PFUser.currentUser().username)
    currentNotification.old = check.countObjects()
}
public class Kareem {
    
    class public func checkNotifications(tabArray: NSArray!)  {
        var currentNotification = currentNotifications()
        var check = PFQuery(className: "Notification")
        check.whereKey("receiver", equalTo: PFUser.currentUser().username)
        currentNotification.newCheck = check.countObjects()
        
        if currentNotification.old != currentNotification.newCheck {
            var diffrence = currentNotification.old - currentNotification.newCheck
            var tabItem = tabArray.objectAtIndex(1) as UITabBarItem
            tabItem.badgeValue = String(diffrence)
            println()
            println()
            println("You have gotten a new notification")
            println()
            println()
        }
        else {
            println()
            println()
            println("You do not have a any new notification ")
            println()
            println()
        }
    }
    
}

public func customAlert(title:String, error:String) {
    
    var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
        
        
        
    }))
    alert.addAction(UIAlertAction(title: "C", style: .Default, handler: { action in
        
        
        
    }))
    
    
  
    
    func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
}

public struct timeObjects {
    
    var dateTime1 = String()
    var time.dateStr1 = String()
    var orderDate1 = NSDate()
    var dateTime2 = String()
    var dateStr2 = String()
    var orderDate2 = NSDate()
    var startString = String()
    var endString = String()
    
}