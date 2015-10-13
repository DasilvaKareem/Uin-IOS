//
//  eventLocation.swift
//  Uin
//
//  Created by Kareem Dasilva on 3/23/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit
import MapKit

class eventLocationView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
   
     //Stores user current lcoation address
    @IBAction func getUserLocation(sender: AnyObject) {
        //geo = CLGeocoder()
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(eventLocation.text!, completionHandler: {
            placemarks, error in
            if let placemark:CLPlacemark = placemarks![0]  {
                let eventLatitude = placemark.location!.coordinate.latitude //Laitude of the place marker
                let eventLongitude = placemark.location!.coordinate.longitude //Longitude of the place marker
                let location = CLLocation(latitude: eventLatitude, longitude: eventLongitude)
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
   
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(eventLocation.text!, completionHandler: {
            placemarks, error  in
            if let placemark:CLPlacemark = placemarks?[0]  {
                
                
                
                let eventLatitude = placemark.location!.coordinate.latitude //Laitude of the place marker
                let eventLongitude = placemark.location!.coordinate.longitude //Longitude of the place marker
                let location = CLLocation(latitude: eventLatitude, longitude: eventLongitude)
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
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        var geocoder = CLGeocoder()
        var location = CLLocation(latitude: map.centerCoordinate.latitude, longitude: map.centerCoordinate.longitude)
        var location2D = CLLocationCoordinate2D(latitude: map.centerCoordinate.latitude, longitude: map.centerCoordinate.longitude)
        geocoder.reverseGeocodeLocation(location, completionHandler:{
            placemarks, error in
            let placemark:CLPlacemark = (placemarks?[0])!
            self.eventLocation.text = placemark.name
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
        print(map.userLocation.location)
        
       

        
    
      
        
        // Do any additional setup after loading the view.
    }
    
    

    
     func locationManager(locationmgr: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation = locations.last!
        print("it is moving and running")
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let geoLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        var geocode = CLGeocoder()
        locationmgr.stopUpdatingLocation()
       
        geocode.reverseGeocodeLocation(location, completionHandler: {
            placemarks, error in
            let placemark:CLPlacemark = placemarks![0]
            
            self.eventLocation.text = placemark.name
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
            let event:eventMake = segue.destinationViewController as! eventMake
            event.eventLocation = displayLocation.text!
            event.locations = eventGeoLocation
            event.address = eventLocation.text!
            
            
        }
    }


}
