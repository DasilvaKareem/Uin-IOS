//
//  eventLocation.swift
//  Uin
//
//  Created by Kareem Dasilva on 3/23/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit
import MapKit

class eventLocation: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
var locationmgr : CLLocationManager!
    @IBOutlet var map: MKMapView!
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    @IBOutlet var eventLocation: UITextField!
    @IBAction func checkLocation(sender: AnyObject) {
        var geo = CLGeocoder()
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(eventLocation.text, {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                self.map.addAnnotation(MKPlacemark(placemark: placemark))
                
                var eventLatitude = placemark.location.coordinate.latitude //Laitude of the place marker
                var eventLongitude = placemark.location.coordinate.longitude //Longitude of the place marker
                
                let center = CLLocationCoordinate2D(latitude: eventLatitude, longitude: eventLongitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                
                self.map.setRegion(region, animated: true)
            }
        })
       
        
    }


    override func viewDidAppear(animated: Bool) {
  
      
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        locationmgr = CLLocationManager()
        locationmgr.delegate = self
        locationmgr.requestWhenInUseAuthorization()
        map.showsUserLocation = true
       locationmgr.startUpdatingLocation()
        
        
        
    
      
        
        // Do any additional setup after loading the view.
    }
    
     func locationManager(locationmgr: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
        locationmgr.stopUpdatingLocation()
    }
    
    //Creates a annotation that tells you wheere you want your event to be
    
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
