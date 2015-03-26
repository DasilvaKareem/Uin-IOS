//
//  eventLocation.swift
//  Uin
//
//  Created by Kareem Dasilva on 3/23/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit
import MapKit

class eventLocation: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {

     //Stores user current lcoation address
    @IBAction func getUserLocation(sender: AnyObject) {
        
    }
   
    @IBOutlet var displayLocation: UITextField!
var locationmgr : CLLocationManager!
    @IBOutlet var map: MKMapView!
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    @IBOutlet var eventLocation: UITextField!
    var eventGeoLocation = (CLLocation)() //Cordination of event
    //Keyboard functions and modfies them
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.eventLocation.endEditing(true)
        if self.eventLocation.endEditing(true) {
            var geo = CLGeocoder()
            var geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(eventLocation.text, {
                (placemarks: [AnyObject]!, error: NSError!) -> Void in
                if let placemark = placemarks?[0] as? CLPlacemark {
                    let annotationsToRemove = self.map.annotations.filter { $0 !== self.map.userLocation }
                    self.map.removeAnnotations( annotationsToRemove )
                    self.map.addAnnotation(MKPlacemark(placemark: placemark))
                    
                    var eventLatitude = placemark.location.coordinate.latitude //Laitude of the place marker
                    var eventLongitude = placemark.location.coordinate.longitude //Longitude of the place marker
                    var location = CLLocation(latitude: eventLatitude, longitude: eventLongitude)
                    let center = CLLocationCoordinate2D(latitude: eventLatitude, longitude: eventLongitude)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    
                    self.map.setRegion(region, animated: true)
                    
                }
            })
        }
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Submits the locations to event make view
    @IBAction func checkLocation(sender: AnyObject) {
 
       self.performSegueWithIdentifier("location", sender: self)
        
    }

    
    override func viewDidAppear(animated: Bool) {
  
      
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLocation.delegate = self
        locationmgr = CLLocationManager()
        locationmgr.delegate = self
        locationmgr.requestWhenInUseAuthorization()
        map.showsUserLocation = true
       locationmgr.startUpdatingLocation()
        println(map.userLocation.location)
       
        
        var uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        
        uilpgr.minimumPressDuration = 0.5
        
        map.addGestureRecognizer(uilpgr)
        
    
      
        
        // Do any additional setup after loading the view.
    }
    
    

    
     func locationManager(locationmgr: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let geoLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        var geocode = CLGeocoder()
        geocode.reverseGeocodeLocation(location, completionHandler: {
            (placemarks: [AnyObject]!, error: NSError!) -> Void in
            let placemark = placemarks?[0] as? CLPlacemark
            println(placemark?.name)
            self.eventLocation.text = placemark?.name
            
        })
        self.map.setRegion(region, animated: true)
        locationmgr.stopUpdatingLocation()
    
        
    }
    
    //Creates a annotation that tells you wheere you want your event to be
    func action(gestureRecognizer: UIGestureRecognizer) {
        
        println("Gesture Recognized")
        
        //Removes  current annoations on the map
        let annotationsToRemove = map.annotations.filter { $0 !== self.map.userLocation }
        map.removeAnnotations( annotationsToRemove )
        
        //Gets current touch points cordinates
        var touchPoint = gestureRecognizer.locationInView(self.map)
        var newCoordinate: CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
        
       //Creats an annototians and locations/sets regions
        var annotation = MKPointAnnotation()
      
  
        var geocoder = CLGeocoder()
        var location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude) //location for app
        
        //Reverses the lat n long to real human people things
        geocoder.reverseGeocodeLocation(location, completionHandler:{
            (placemarks: [AnyObject]!, error: NSError!) -> Void in
            let placemark = placemarks?[0] as? CLPlacemark
            self.eventLocation.text = placemark?.name
            println(placemark?.location)
            println(placemark?.addressDictionary[2])
            annotation.coordinate = newCoordinate //sets teh cordinates for the annotation
            annotation.title = placemark?.name
            annotation.subtitle = placemark?.thoroughfare
            
                 //Creates map region for new cordinates
              self.map.addAnnotation(annotation)
        })
     
        self.eventGeoLocation = location
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation

  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "location" {
            var event:eventMake = segue.destinationViewController as eventMake
            event.eventDisplay = displayLocation.text
            event.locations = eventGeoLocation
            
        }
    }


}
