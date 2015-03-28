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
        var geo = CLGeocoder()
        var geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(eventLocation.text, {
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
    }
   
    @IBOutlet var displayLocation: UITextField!
    var locationmgr : CLLocationManager! // locatiom manger
    @IBOutlet var map: MKMapView! // lol map
    var manager:CLLocationManager! // another manger?
    var myLocations: [CLLocation] = [] // locations that are manged
    @IBOutlet var eventLocation: UITextField! // address of location
    var eventGeoLocation = (CLLocation)() //Cordination of event
    
    //Keyboard functions and modfies them
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
       
        if self.eventLocation.endEditing(true) {
    
        }
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        var geo = CLGeocoder()
        var geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(eventLocation.text, {
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
 
       self.segueForUnwindingToViewController(eventMake(), fromViewController:self, identifier: "location")
        
        
    }

    
    override func viewDidAppear(animated: Bool) {
  
      
        
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
        
       
        var uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        
        uilpgr.minimumPressDuration = 0.5
        
        map.addGestureRecognizer(uilpgr)
        
    
      
        
        // Do any additional setup after loading the view.
    }
    
    

    
     func locationManager(locationmgr: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as CLLocation
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
            event.eventLocation = displayLocation.text
            event.locations = eventGeoLocation
            event.address = eventLocation.text
            event.tabBarController?.navigationItem.backBarButtonItem = nil
            
        }
    }


}
