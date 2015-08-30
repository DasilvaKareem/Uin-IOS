//
//  postEvent.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 1/26/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit
import EventKit

class postEvent: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var eventDescription: UILabel!
    @IBOutlet var calendarCount: UILabel!
    @IBOutlet var peopleView: UIImageView!
    @IBOutlet var locationTitle: UILabel!
    @IBOutlet var dateTitle: UILabel!
    
    @IBOutlet var imageShower: UIButton!
    @IBOutlet weak var picture: UIImageView!
    var image = (UIImage)()
    
    @IBOutlet var location: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet var startTime: UILabel!
    @IBOutlet var endTime: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var username: UIButton!
    
    @IBOutlet weak var firstTag: UIImageView!
    @IBOutlet weak var secondTag: UIImageView!
    @IBOutlet weak var thirdTag: UIImageView!
    @IBOutlet weak var firstTagDescriptor: UILabel!
    @IBOutlet weak var secondTagDescriptor: UILabel!
    @IBOutlet weak var thirdTagDescriptor: UILabel!
    
    
    @IBOutlet weak var wigoCollectionView: UICollectionView!

    
    @IBAction func gotoProfile(sender: AnyObject) {
        if PFUser.currentUser().objectId != organizationID {
            self.performSegueWithIdentifier("gotoprofile", sender: self)
        } else {
            self.performSegueWithIdentifier("editEvent", sender: self)
        }
        
        
    }
    
    @IBOutlet var theeditButton: UIBarButtonItem!
    var alertTime:NSTimeInterval = -6000
    var profileEditing = false
    var address = String()
    var organization = String()
    var storeTitle = String()
    var storeLocation = String()
    var storeStartTime = String()
    var storeEndTime = String()
    var storeEndDate = String()
    var storeDate = String()
    var storeSum = String()
    var data = Int()
    var icon1 = String()
    var icon2 = String()
    var icon3 = String()
    var storeStartDate = NSDate()
    var endStoreDate = NSDate()
    var eventId = String()
    var localStart = String()
    var localEnd = String()
    var organizationID = String()
    var eventDescriptionHolder = String()
    var searchEvent = false
    var imageFile = (PFFile)()
    var startDate = (String)()
    var endDate = (String)()
    func checkevent(){
        var minique = PFQuery(className: "UserCalendar")
        minique.whereKey("user", equalTo: PFUser.currentUser().username)
       
        minique.whereKey("eventID", equalTo: eventId)
        
        minique.getFirstObjectInBackgroundWithBlock{
            
            (results:PFObject!, error: NSError!) -> Void in
            
            if error == nil {
                self.longBar.setImage(UIImage(named: "addedToCalendarBig.png"), forState: UIControlState.Normal)
               
                self.calendarCount.textColor = UIColor(red: 52.0/255.0, green: 127.0/255.0, blue: 191.0/255, alpha:1) //blue color
            }   else {
                self.longBar.setImage(UIImage(named: "addToCalendarBig.png"), forState: UIControlState.Normal)
             
                self.calendarCount.textColor = UIColor(red: 254.0/255.0, green: 186.0/255.0, blue: 1.0/255, alpha:1 ) //yellow color
            }
        }
        //getCount()
    }
    //Gets the amount of people added to calendar
    func getCount() {
        var minique2 = PFQuery(className: "UserCalendar")
        minique2.whereKey("eventID", equalTo: eventId)
        var goingCount = minique2.countObjects()
        self.calendarCount.text = String(goingCount)
    }
    //Queries from object ID

    override func viewWillAppear(animated: Bool) {
      
        if profileEditing == false {
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
            // Changes text color on navbar
            var nav = self.navigationController?.navigationBar
            nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
        }
    }

    func getEvents() {
       var getEvents = PFQuery(className: "Event")
        getEvents.includeKey("author")
        getEvents.getObjectInBackgroundWithId(eventId, block: {
            (result: PFObject!, error: NSError!) -> Void in
            if error == nil {
                
                var dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale.currentLocale() // Gets current locale and switches
                dateFormatter.dateFormat = "MMM. dd, yyyy - h:mm a"
                let start =  result["start"] as! NSDate
                
                self.startDate = dateFormatter.stringFromDate(start) // Creates date
                self.endDate = dateFormatter.stringFromDate(result["end"] as! NSDate) // Creates date
                
                let author = result["author"] as! PFObject
                
                self.organization = author["name"] as! String
                self.organizationID = author.objectId
                self.address = result["address"] as!String!
                self.storeLocation = result["location"] as!String!
                self.location.text = result["location"] as!String!
                self.eventTitle.text = result["title"] as!String!
                self.storeTitle = result["title"] as!String!
                self.date.text = self.startDate
                
                if (result["tag1"]  === nil)  {
                    self.icon1 = ""
                } else {
                    
                    self.icon1 = result["tag1"] as! String
                }
                
                //Checks if the tag2 is nil then enters a blank icon
                if (result["tag2"]  === nil)  {
                    self.icon2 = ""
                } else {
                    
                    self.icon2 = result["tag2"] as! String
                }
                //Checks if the tag3 is nil then enters a blank icon
                if (result["tag3"]  === nil)  {
                    self.icon3 = ""
                } else {
                    self.icon3 = result["tag3"] as! String
                }
            
                self.eventDescription.text = result["description"] as? String
                
               
                self.eventId = result.objectId
                self.putIcons()
            }
        })
    }
    override func viewDidAppear(animated: Bool) {
     
    }
    
    override func viewDidLoad() {
        
        var theMix = Mixpanel.sharedInstance()
        theMix.track("Event View Opened")
        theMix.flush()
        super.viewDidLoad()
        getWhosGoing()
        //username.setTitle(organization, forState:UIControlState.Normal)
        //If event is owned by organization the org can edit the event
        /*if organizationID == PFUser.currentUser()["organization"] as! String{
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        } else {
            self.navigationItem.rightBarButtonItem?.title = organizationID
        }*/
    
        self.tabBarController?.tabBar.hidden = true
        if profileEditing == true {
        
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
            // Changes text color on navbar
            var nav = self.navigationController?.navigationBar
            nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
            
        } else {
            
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBackground.png"), forBarMetrics: UIBarMetrics.Default)
            // Changes text color on navbar
            var nav = self.navigationController?.navigationBar
            nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
        }
        if searchEvent == true {
            getEvents()
        } else {
            getEvents()
        }
            checkevent()
    }
    
    @IBAction func eventShare(sender: AnyObject) {
        let textToShare = "Check out '\(storeTitle)' hosted by '\(organization)' at '\(self.storeLocation)' on Uin! " + "iOS: http://apple.co/1G2pLXs " + "Android: http://bit.ly/1NwYAD9"
    
            let objectsToShare = [textToShare]
            let poop = UIActivityTypePostToFacebook
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: nil)
        
    }
    @IBAction func changeForm(sender: AnyObject) {
      
      
    
    }
    
    
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        func preferredStatusBarStyle() -> UIStatusBarStyle {
            return UIStatusBarStyle.Default
        }
        
    }
    //Adds the event to calenar and creats a notifcations,push, and changes the button itself
    @IBAction func addtocalendar(sender: AnyObject) {
        
   
    }
    // Switch display location with the real addrss
    @IBAction func switchAddress(sender: AnyObject) {
        if address == storeLocation {
            address = address + " (address)"
            storeLocation = storeLocation + " (location)"
            if location.text == storeLocation {
                location.text = address
                locationTitle.text = "address"
            } else {
                location.text = storeLocation
                locationTitle.text = "location"
            }
        } else {
            if location.text == storeLocation {
                location.text = address
                locationTitle.text = "address"
            } else {
                location.text = storeLocation
                locationTitle.text = "location"
            }
        }
       
    }
    
    // Switch start time with the end time
    @IBAction func switchDates(sender: UIButton) {
        if self.startDate == self.endDate {
            self.dateTitle.text = "starts at and ends at"
        } else {
            if self.date.text == self.startDate {
                self.date.text = self.endDate
                dateTitle.text = "ends at"
            } else {
                self.date.text = self.startDate
                dateTitle.text = "starts at"
            }
        }
      
       
    }
    
    @IBOutlet var longBar: UIButton!
    
    func putIcons(){
        switch icon1 {
        case "PvApxif2rw": //Popcorn
            firstTag.image = UIImage(named: "popcorn.png")
            firstTagDescriptor.text = "Popcorn"
            break
            
        case "LP5fLvLurL": //recuitment
            firstTag.image = UIImage(named: "recruitment.png")
           firstTagDescriptor.text = "recruitment"
            
            break
            
        case "8HvnDADGY2": // run
            firstTag.image = UIImage(named: "run.png")
            firstTagDescriptor.text = "run"
            break
            
        case "BX9RsT3EpW": //tour
            firstTag.image = UIImage(named: "tour.png")
            firstTagDescriptor.text = "tour"
            break
        case "u2EAfQk9Lf": //intramural
            firstTag.image = UIImage(named: "intramural.png")
             firstTagDescriptor.text = "Intramural"
            break
            
        case "ayCBAVwQ93": //sales event
            firstTag.image = UIImage(named: "sales.png")
             firstTagDescriptor.text = "Sales"
            break
            
        case "D1nxE6j63a": //dance
            firstTag.image = UIImage(named: "dance.png")
             firstTagDescriptor.text = "Dance"
            break
            
        case "XiWPxYMwEO": //games
             firstTag.image = UIImage(named: "games.png")
             firstTagDescriptor.text = "Games"
            break
            
        case "6IkmbdKMnn": //meetup
             firstTag.image = UIImage(named: "meet.png")
             firstTagDescriptor.text = "meet"
            break
            
        case "wLt1TPYiyV": //religous
             firstTag.image = UIImage(named: "religous.png")
             firstTagDescriptor.text = "Religous"
            break
            
        case "f8ZpiOF9cg": //conference
             firstTag.image = UIImage(named: "conference.png")
             firstTagDescriptor.text = "conference"
            break
            
        case "leITfmSo7E": //party
             firstTag.image = UIImage(named: "party.png")
             firstTagDescriptor.text = "Party"
            break
        case "s5XU11BTs3": // drinking
             firstTag.image = UIImage(named: "drinking.png")
             firstTagDescriptor.text = "drinking"
            break
            
        case "a3pMl70t39": //Outdoors
             firstTag.image = UIImage(named: "outdoors.png")
             firstTagDescriptor.text = "outdoors"
            break
            
        case "V6fIqmoG05": //philanthropy
             firstTag.image = UIImage(named: "phil.png")
             firstTagDescriptor.text = "Philanthropy"
            break
        case "mch3EIhozC": //music
             firstTag.image = UIImage(named: "music.png")
             firstTagDescriptor.text = "Music"
            break
            
        case "AjosKs2UWi": //byob
             firstTag.image = UIImage(named: "byob.png")
             firstTagDescriptor.text = "Byob"
            break
            
        case "Ymclya9lwu": //performance
             firstTag.image = UIImage(named: "performance.png")
             firstTagDescriptor.text = "Performance"
            break
        case "XYV5giSlCO": // food
             firstTag.image = UIImage(named: "food.png")
             firstTagDescriptor.text = "Food"
            break
            
        case "GawBDHRtfo": //free
             firstTag.image = UIImage(named: "free.png")
             firstTagDescriptor.text = "Free"
            break
        case "8OXtrEEL7c"://On campus
             firstTag.image = UIImage(named: "onCampus.png")
             firstTagDescriptor.text = "Oncampus"
            break
            
        default:
             firstTag.image = nil
             firstTagDescriptor.text = ""
            
            
        }
        
        switch icon2 {
        case "PvApxif2rw": //Popcorn
            secondTag.image = UIImage(named: "popcorn.png")
            secondTagDescriptor.text = "Popcorn"
            break
            
        case "LP5fLvLurL": //recuitment
            secondTag.image = UIImage(named: "recruitment.png")
            secondTagDescriptor.text = "recruitment"
            
            break
            
        case "8HvnDADGY2": // run
            secondTag.image = UIImage(named: "run.png")
            secondTagDescriptor.text = "run"
            break
            
        case "BX9RsT3EpW": //tour
            secondTag.image = UIImage(named: "tour.png")
            secondTagDescriptor.text = "tour"
            break
        case "u2EAfQk9Lf": //intramural
            secondTag.image = UIImage(named: "intramural.png")
            secondTagDescriptor.text = "Intramural"
            break
            
        case "ayCBAVwQ93": //sales event
            secondTag.image = UIImage(named: "sales.png")
            secondTagDescriptor.text = "Sales"
            break
            
        case "D1nxE6j63a": //dance
            secondTag.image = UIImage(named: "dance.png")
            secondTagDescriptor.text = "Dance"
            break
            
        case "XiWPxYMwEO": //games
            secondTag.image = UIImage(named: "games.png")
            secondTagDescriptor.text = "Games"
            break
            
        case "6IkmbdKMnn": //meetup
            secondTag.image = UIImage(named: "meet.png")
            secondTagDescriptor.text = "meet"
            break
            
        case "wLt1TPYiyV": //religous
            secondTag.image = UIImage(named: "religous.png")
            secondTagDescriptor.text = "Religous"
            break
            
        case "f8ZpiOF9cg": //conference
            secondTag.image = UIImage(named: "conference.png")
            secondTagDescriptor.text = "conference"
            break
            
        case "leITfmSo7E": //party
            secondTag.image = UIImage(named: "party.png")
            secondTagDescriptor.text = "Party"
            break
        case "s5XU11BTs3": // drinking
            secondTag.image = UIImage(named: "drinking.png")
            secondTagDescriptor.text = "drinking"
            break
            
        case "a3pMl70t39": //Outdoors
            secondTag.image = UIImage(named: "outdoors.png")
            secondTagDescriptor.text = "outdoors"
            break
            
        case "V6fIqmoG05": //philanthropy
            secondTag.image = UIImage(named: "phil.png")
            secondTagDescriptor.text = "Philanthropy"
            break
        case "mch3EIhozC": //music
            secondTag.image = UIImage(named: "music.png")
            secondTagDescriptor.text = "Music"
            break
            
        case "AjosKs2UWi": //byob
            secondTag.image = UIImage(named: "byob.png")
            secondTagDescriptor.text = "Byob"
            break
            
        case "Ymclya9lwu": //performance
            secondTag.image = UIImage(named: "performance.png")
            secondTagDescriptor.text = "Performance"
            break
        case "XYV5giSlCO": // food
            secondTag.image = UIImage(named: "food.png")
            secondTagDescriptor.text = "Food"
            break
            
        case "GawBDHRtfo": //free
            secondTag.image = UIImage(named: "free.png")
            secondTagDescriptor.text = "Free"
            break
        case "8OXtrEEL7c"://On campus
            secondTag.image = UIImage(named: "onCampus.png")
            secondTagDescriptor.text = "Oncampus"
            break
            
        default:
            secondTag.image = nil
            secondTagDescriptor.text = ""
            
            
        }
        switch icon3 {
        case "PvApxif2rw": //Popcorn
            thirdTag.image = UIImage(named: "popcorn.png")
            thirdTagDescriptor.text = "Popcorn"
            break
            
        case "LP5fLvLurL": //recuitment
            thirdTag.image = UIImage(named: "recruitment.png")
            thirdTagDescriptor.text = "recruitment"
            
            break
            
        case "8HvnDADGY2": // run
            thirdTag.image = UIImage(named: "run.png")
            thirdTagDescriptor.text = "run"
            break
            
        case "BX9RsT3EpW": //tour
            thirdTag.image = UIImage(named: "tour.png")
            thirdTagDescriptor.text = "tour"
            break
        case "u2EAfQk9Lf": //intramural
            thirdTag.image = UIImage(named: "intramural.png")
            thirdTagDescriptor.text = "Intramural"
            break
            
        case "ayCBAVwQ93": //sales event
            thirdTag.image = UIImage(named: "sales.png")
            thirdTagDescriptor.text = "Sales"
            break
            
        case "D1nxE6j63a": //dance
            thirdTag.image = UIImage(named: "dance.png")
            thirdTagDescriptor.text = "Dance"
            break
            
        case "XiWPxYMwEO": //games
            thirdTag.image = UIImage(named: "games.png")
            thirdTagDescriptor.text = "Games"
            break
            
        case "6IkmbdKMnn": //meetup
            thirdTag.image = UIImage(named: "meet.png")
            thirdTagDescriptor.text = "meet"
            break
            
        case "wLt1TPYiyV": //religous
            thirdTag.image = UIImage(named: "religous.png")
            thirdTagDescriptor.text = "Religous"
            break
            
        case "f8ZpiOF9cg": //conference
            thirdTag.image = UIImage(named: "conference.png")
            thirdTagDescriptor.text = "conference"
            break
            
        case "leITfmSo7E": //party
            thirdTag.image = UIImage(named: "party.png")
            thirdTagDescriptor.text = "Party"
            break
        case "s5XU11BTs3": // drinking
            thirdTag.image = UIImage(named: "drinking.png")
            thirdTagDescriptor.text = "drinking"
            break
            
        case "a3pMl70t39": //Outdoors
            thirdTag.image = UIImage(named: "outdoors.png")
            thirdTagDescriptor.text = "outdoors"
            break
            
        case "V6fIqmoG05": //philanthropy
            thirdTag.image = UIImage(named: "phil.png")
            thirdTagDescriptor.text = "Philanthropy"
            break
        case "mch3EIhozC": //music
            thirdTag.image = UIImage(named: "music.png")
            thirdTagDescriptor.text = "Music"
            break
            
        case "AjosKs2UWi": //byob
            thirdTag.image = UIImage(named: "byob.png")
            thirdTagDescriptor.text = "Byob"
            break
            
        case "Ymclya9lwu": //performance
            thirdTag.image = UIImage(named: "performance.png")
            thirdTagDescriptor.text = "Performance"
            break
        case "XYV5giSlCO": // food
            thirdTag.image = UIImage(named: "food.png")
            thirdTagDescriptor.text = "Food"
            break
            
        case "GawBDHRtfo": //free
            thirdTag.image = UIImage(named: "free.png")
            thirdTagDescriptor.text = "Free"
            break
        case "8OXtrEEL7c"://On campus
            thirdTag.image = UIImage(named: "onCampus.png")
            thirdTagDescriptor.text = "Oncampus"
            break
            
        default:
            thirdTag.image = nil
            thirdTagDescriptor.text = ""
            
            
        }



    }
    //Setups wigo feature and collectionview
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return wigoImage.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:WigoCell = wigoCollectionView.dequeueReusableCellWithReuseIdentifier("icon", forIndexPath: indexPath) as! WigoCell
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2
        cell.profilePic.clipsToBounds = true
        while(wigoImage.count == 0 ) {
            cell.profilePic.image = nil
            return cell
        }
        cell.profilePic.image = wigoImage[indexPath.row]
        cell.name.text = wigoNames[indexPath.row]
        
        return cell
    }

    var wigoImage = [UIImage]()
    var wigoNames = [String]()
    func getWhosGoing(){
        var userImage = (PFFile)()
        var wigoQuery = PFQuery(className: "WigoFeature")
        wigoQuery.whereKey("event", equalTo: PFObject(withoutDataWithClassName: "Event", objectId: eventId))
        //wigoQuery.limit = 5
        wigoQuery.includeKey("user")
        wigoQuery.includeKey("event")
        wigoQuery.findObjectsInBackgroundWithBlock({
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
               // println(objects)
                for object in objects {
                    println(object)
                    var wigoUser = object["user"] as! PFObject
                    self.wigoNames.append(wigoUser["firstName"] as! String)
                    println(wigoUser["profilePicture"] as! PFFile)
                    userImage = wigoUser["profilePicture"] as! PFFile
                    userImage.getDataInBackgroundWithBlock({
                        (data:NSData!, error:NSError!) -> Void in
                        if error == nil {
                           // println(data)
                            self.wigoImage.append(UIImage(data: data)!)
                             self.wigoCollectionView.reloadData()
                             println(self.wigoImage)
                        } else {
                            println("No data found")
                        }
                    })
                    
            
                }
               
               
            } else {
                println("Error was found")
            }
        })
        
        
    }
    override func prepareForSegue(segue:UIStoryboardSegue, sender: AnyObject?){
        
        if segue.identifier == "gotoprofile" {
            var theMix = Mixpanel.sharedInstance()
            theMix.track("Tap Username (EV)")
            theMix.flush()
            var orginzationPages:OrginazationPage = segue.destinationViewController as! OrginazationPage
            orginzationPages.orgID = organizationID
        }
        if segue.identifier == "editEvent" {
            var theMix = Mixpanel.sharedInstance()
            theMix.track("Tap Edit (EV)")
            theMix.flush()
            var editEvent:eventMake = segue.destinationViewController as! eventMake
            editEvent.editing = true
            editEvent.eventID = eventId
        }
        if segue.identifier == "imagePreview" {
            var theMix = Mixpanel.sharedInstance()
            theMix.track("Tap image Preview (EV)")
            theMix.flush()
            var imageView:imagePreview = segue.destinationViewController as! imagePreview
            imageView.eventID = self.eventId
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class WigoCell: UICollectionViewCell {
    //Image of people
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
}
class imagePreview: UIViewController {
    var eventID = (String)()
    var imageFile = (PFFile)()
    @IBOutlet var eventPicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        var getImage = PFQuery(className: "Event")
        getImage.getObjectInBackgroundWithId(eventID, block: {
            (object:PFObject!, error:NSError!) -> Void in
            if error == nil {
                self.imageFile = object["picture"] as! PFFile
                self.imageFile.getDataInBackgroundWithBlock({
                    (imageData: NSData!, error: NSError!) -> Void in
                    if error == nil {
                        self.eventPicture.image = UIImage(data: imageData)
                        UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData), nil, nil, nil)
                       
                        
                    } else {
                        println(error)
                    }
                })
            }
        })
     

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}