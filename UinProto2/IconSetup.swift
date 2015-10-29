//
//  File.swift
//  Uin
//
//  Created by Kareem Dasilva on 9/27/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit
public struct Icon {
    var caption = ""
    var iconImage = (UIImage)()
    
}

public func setIcon(iconID:String) -> Icon {
    var icon = (Icon)()
    if(iconID == "Food"){
        icon.iconImage =  UIImage(named: "yesFood.png")!
        icon.caption = "Food"
    } else if(iconID == "Campus") {
        icon.iconImage = UIImage(named: "onCampus.png")!
        icon.caption = "On Campus"
        
    } else if(iconID == "Free"){
        icon.iconImage = UIImage(named: "yesFree.png")!
        icon.caption = "Free"
        
    } else {
        icon.caption = ""
        //icon.iconImage = UIImage.
    
    }
    return icon
    /*switch iconID {
    case "PvApxif2rw": //Popcorn
        icon.iconImage = UIImage(named: "popcorn.png")!
        icon.caption = "Popcorn"
        return icon
        break
        
    case "LP5fLvLurL": //recuitment
        icon.iconImage = UIImage(named: "recruitment.png")!
        icon.caption = "recruitment"
        return icon
        
        break
        
    case "8HvnDADGY2": // run
        icon.iconImage = UIImage(named: "run.png")!
        icon.caption = "run"
        return icon
        break
        
    case "BX9RsT3EpW": //tour
        icon.iconImage = UIImage(named: "tour.png")!
        icon.caption = "tour"
        return icon
        break
    case "u2EAfQk9Lf": //intramural
        icon.iconImage = UIImage(named: "intramural.png")!
        icon.caption = "Intramural"
        return icon
        break
        
    case "ayCBAVwQ93": //sales event
        icon.iconImage = UIImage(named: "sales.png")!
        icon.caption = "Sales"
        return icon
        break
        
    case "D1nxE6j63a": //dance
        icon.iconImage = UIImage(named: "dance.png")!
        icon.caption = "Dance"
        return icon
        break
        
    case "XiWPxYMwEO": //games
        icon.iconImage = UIImage(named: "games.png")!
        icon.caption = "Games"
        return icon
        break
        
    case "6IkmbdKMnn": //meetup
        icon.iconImage = UIImage(named: "meet.png")!
        icon.caption = "meet"
        return icon
        break
        
    case "wLt1TPYiyV": //religous
        icon.iconImage = UIImage(named: "religous.png")!
        icon.caption = "Religous"
        return icon
        break
        
    case "f8ZpiOF9cg": //conference
        icon.iconImage = UIImage(named: "conference.png")!
        icon.caption = "conference"
        return icon
        break
        
    case "leITfmSo7E": //party
        icon.iconImage = UIImage(named: "party.png")!
        icon.caption = "Party"
        return icon
        break
    case "s5XU11BTs3": // drinking
        icon.iconImage = UIImage(named: "drinking.png")!
        icon.caption = "drinking"
        return icon
        break
        
    case "a3pMl70t39": //Outdoors
        icon.iconImage = UIImage(named: "outdoors.png")!
        icon.caption = "outdoors"
        return icon
        break
        
    case "V6fIqmoG05": //philanthropy
       icon.iconImage = UIImage(named: "phil.png")!
        icon.caption = "Philanthropy"
       return icon
        break
    case "mch3EIhozC": //music
        icon.iconImage = UIImage(named: "music.png")!
        icon.caption = "Music"
        return icon
        break
        
    case "AjosKs2UWi": //byob
        icon.iconImage = UIImage(named: "byob.png")!
        icon.caption = "Byob"
        return icon
        break
        
    case "Ymclya9lwu": //performance
        icon.iconImage = UIImage(named: "performance.png")!
        icon.caption = "Performance"
        return icon
        break
    case "XYV5giSlCO": // food
        icon.iconImage = UIImage(named: "food.png")!
        icon.caption = "Food"
        return icon
        break
        
    case "GawBDHRtfo": //free
        icon.iconImage = UIImage(named: "free.png")!
        icon.caption = "Free"
        return icon
        break
    case "8OXtrEEL7c"://On campus
        icon.iconImage = UIImage(named: "onCampus.png")!
        icon.caption = "on campus"
        return icon
        break
        
    default:
        //icon.iconImage = UIImage.
        icon.caption = ""
        return icon
        
    }*/
    
    
}
