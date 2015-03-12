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

public func checkNotifications() {
    var currentNotification = currentNotifications()
    var check = PFQuery(className: "Notification")
    check.whereKey("receiver", equalTo: PFUser.currentUser().username)
    currentNotification.newCheck = check.countObjects()
    
    if currentNotification.old != currentNotification.newCheck {
        var diffrence = currentNotification.old - currentNotification.newCheck
        var event = eventFeedViewController()
        var tabArray = event.tabBarController?.tabBar.items as NSArray!
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
