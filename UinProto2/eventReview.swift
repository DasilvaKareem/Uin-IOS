//
//  eventReview.swift
//  Uin
//
//  Created by Sir Lancelot on 6/15/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit
import MapKit
class eventCollection {
    var start = (NSDate)()
    var end = (NSDate)()
    var name = (String)()
    var title = (String)()
    var icon1 = (Int)()
    var icon2 = (Int)()
    var icon3 = (Int)()
    var gpsCord = (PFGeoPoint)()
    var location = (String)()
    
    class eventReview: UIViewController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        /*
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        }
        */
        
    }
    
    
    class datepickers: UIViewController {
        
        @IBOutlet var startTIme: UILabel!
        @IBOutlet var endTime: UILabel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.tabBarController?.tabBar.hidden = true
            // Do any additional setup after loading the view.
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        @IBOutlet var datepicker1: UIDatePicker!
        @IBAction func theDatePicker(sender: AnyObject) {
            
            
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            dateStr1 = dateFormatter.stringFromDate(datepicker1.date)
            
            var dateTimeformat = NSDateFormatter()
            dateTimeformat.timeStyle = NSDateFormatterStyle.ShortStyle
            dateTime1 =  dateTimeformat.stringFromDate(datepicker1.date)
            orderDate1 = datepicker1.date
            startString = dateStr1 + " " + dateTime1
            startTIme.text = startString
            
            
        }
        
        @IBOutlet var datepicker2: UIDatePicker!
        @IBAction func thesecondDate(sender: AnyObject) {
            
            
            //startTIme.text = endString
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            var dateTimeformat = NSDateFormatter()
            dateTimeformat.timeStyle = NSDateFormatterStyle.ShortStyle
            dateTime2 = dateTimeformat.stringFromDate(datepicker2.date)
            dateStr2 = dateFormatter.stringFromDate(datepicker2.date)
            orderDate2 = datepicker2.date
            endString = dateStr2 + " " + dateTime2
            endTime.text = endString
        }
    }

    class iconCreateViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
        
        
        
        @IBOutlet weak var iconCollection: UICollectionView!
        
        //Counter setup
        var counter = 0
        
        func keepTrack(){
            if counter != 3 {
                counter++
            }
        }
        //Info to hold images
        var iconId = [Int]()
        var iconImage = [UIImage]()
        var inActiveImage = [UIImage]()
        var caption = [String]()
        
        //Gets data from parse and display images into collection view
        func getIcons(){
            var query = PFQuery(className: "EventTag")
            query.findObjectsInBackgroundWithBlock({
                (objects:[AnyObject]! , error: NSError!) -> Void in
                if error == nil {
                    
                    var placeHolder = (PFFile)()
                    println("got objects")
                    for object in objects {
                        self.iconId.append(object["tagId"] as! Int) //Get tag id
                        self.caption.append(object["caption"] as! String) // get the caption
                        //Gets the active from parse and makes into an image
                        placeHolder = object["activeImage"] as! PFFile
                        placeHolder.getDataInBackgroundWithBlock({
                            (imageData: NSData!, error: NSError!) -> Void in
                            if error == nil {
                                self.iconImage.append(UIImage(data: imageData)!)
                            }
                        })
                        
                        //Gets the inactive from parse and makes into an image
                        placeHolder = object["inactiveImage"] as! PFFile
                        placeHolder.getDataInBackgroundWithBlock({
                            (imageData: NSData!, error: NSError!) -> Void in
                            if error == nil {
                                self.inActiveImage.append(UIImage(data: imageData)!)
                            }
                        })
                        
                        
                    }
                    //println(self.iconId)
                    //println(self.caption)
                    self.iconCollection.reloadData()
                } else {
                    println(error.debugDescription)
                }
            })
        }
        override func viewDidLoad() {
            getIcons()
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
        }
        override func viewWillAppear(animated: Bool) {
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell:iconCell = iconCollection.dequeueReusableCellWithReuseIdentifier("icon", forIndexPath: indexPath) as! iconCell
            
            cell.backgroundColor = UIColor.blackColor()
            println(caption)
            // cell.iconCaption.text = caption[2]
            
            
            return cell
        }
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return 1
        }
        
        func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
            
            return 3
        }
        
        
        func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            keepTrack()
            println(counter)
        }
        
        
        /*
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        }
        */
        
    }
    class iconCell:UICollectionViewCell {
        
        @IBOutlet weak var iconImage: UIImageView!
        
        @IBOutlet weak var iconCaption: UILabel!
        
    }
    
    class eventLocationView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
        
        //Stores user current lcoation address
        @IBAction func getUserLocation(sender: AnyObject) {
            var geo = CLGeocoder()
            var geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(eventLocation.text, completionHandler: {
                (placemarks: [AnyObject]!, error: NSError!) -> Void in
                if let placemark = placemarks?[0] as? CLPlacemark {
                    var eventLatitude = placemark.location.coordinate.latitude //Laitude of the place marker
                    var eventLongitude = placemark.location.coordinate.longitude //Longitude of the place marker
                    var location = CLLocation(latitude: eventLatitude, longitude: eventLongitude)
                    let center = CLLocationCoordinate2D(latitude: eventLatitude, longitude: eventLongitude)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    self.eventGeoLocation = location // passes the cllocation to the segue
                    self.map.setRegion(region, animated: true)
                }
            })
        }
        var passedDisplayLocation = (String)()
        @IBOutlet var displayLocation: UITextField!
        var locationmgr : CLLocationManager! // locatiom manger
        @IBOutlet var map: MKMapView! // lol map
        var manager:CLLocationManager! // another manger?
        var myLocations: [CLLocation] = [] // locations that are manged
        @IBOutlet var eventLocation: UITextField! // address of location
        var eventGeoLocation = (CLLocation)() //Cordination of event
        
        //Keyboard functions and modfies them
        
        override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
            self.view.endEditing(true)
        }
        func textFieldShouldReturn(textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            var geo = CLGeocoder()
            var geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(eventLocation.text, completionHandler: {
                (placemarks: [AnyObject]!, error: NSError!) -> Void in
                if let placemark = placemarks?[0] as? CLPlacemark {
                    
                    
                    
                    var eventLatitude = placemark.location.coordinate.latitude //Laitude of the place marker
                    var eventLongitude = placemark.location.coordinate.longitude //Longitude of the place marker
                    var location = CLLocation(latitude: eventLatitude, longitude: eventLongitude)
                    let center = CLLocationCoordinate2D(latitude: eventLatitude, longitude: eventLongitude)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    self.eventGeoLocation = location
                    self.map.setRegion(region, animated: true)
                    
                    
                }
            })
            return true
        }
        
        //Submits the locations to event make view
        @IBAction func checkLocation(sender: AnyObject) {
        }
        
        
        override func viewWillAppear(animated: Bool) {
            self.displayLocation.text = passedDisplayLocation
        }
        //Keeps track of the center cordinate location
        func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
            var geocoder = CLGeocoder()
            var location = CLLocation(latitude: map.centerCoordinate.latitude, longitude: map.centerCoordinate.longitude)
            var location2D = CLLocationCoordinate2D(latitude: map.centerCoordinate.latitude, longitude: map.centerCoordinate.longitude)
            geocoder.reverseGeocodeLocation(location, completionHandler:{
                (placemarks: [AnyObject]!, error: NSError!) -> Void in
                let placemark = placemarks?[0] as? CLPlacemark
                self.eventLocation.text = placemark?.name
                self.eventGeoLocation = location
            })
        }
        
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            map.delegate = self
            eventLocation.delegate = self
            displayLocation.delegate = self
            locationmgr = CLLocationManager()
            locationmgr.delegate = self
            locationmgr.requestWhenInUseAuthorization()
            map.showsUserLocation = true
            locationmgr.startUpdatingLocation()
            println(map.userLocation.location)
            
            
            
            
            
            
            
            // Do any additional setup after loading the view.
        }
        
        
        
        
        func locationManager(locationmgr: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
            let location = locations.last as! CLLocation
            println("it is moving and running")
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let geoLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            var geocode = CLGeocoder()
            locationmgr.stopUpdatingLocation()
            
            geocode.reverseGeocodeLocation(location, completionHandler: {
                (placemarks: [AnyObject]!, error: NSError!) -> Void in
                let placemark = placemarks?[0] as? CLPlacemark
                println(placemark?.name)
                self.eventLocation.text = placemark?.name
                self.map.setRegion(region, animated: false)
            })
            
            
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        
        // MARK: - Navigation
        
        
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "location" {
                var event:eventMake = segue.destinationViewController as! eventMake
                event.eventLocation = displayLocation.text
                event.locations = eventGeoLocation
                event.address = eventLocation.text
                
                
            }
        }
        
        
    }


}

