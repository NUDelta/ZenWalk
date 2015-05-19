//
//  ViewController.swift
//  ZenWalk
//
//  Created by Scott Cambo on 5/5/15.
//  Copyright (c) 2015 Scott Cambo. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MapKit
import CoreLocation

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate
{
    
    @IBOutlet var theMap: MKMapView!
    
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []

    /*override func viewDidAppear(animated: Bool) {
        var logInController = PFLogInViewController()
        logInController.delegate = self
        self.presentViewController(logInController, animated:true, completion: nil)

    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Set up the location manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        // Set up the map view
        theMap.delegate = self
        theMap.mapType = MKMapType.Standard
        theMap.showsUserLocation = true
        
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]!) {
        //theLabel.text = "\(locations[0])"
        myLocations.append(locations[0] as! CLLocation)
        
        let spanX = 0.007
        let spanY = 0.007
        var newRegion = MKCoordinateRegion(center: theMap.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        theMap.setRegion(newRegion, animated: true)
        
        if (myLocations.count > 1) {
            var sourceIndex = myLocations.count - 1
            var destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            var polyline = MKPolyline(coordinates: &a, count: a.count)
            theMap.addOverlay(polyline)
            
            
            // Save the location to Parse
            let loc = PFObject(className: "Location")
            loc["latitude"] = c2.latitude
            loc["longitude"] = c2.longitude
            loc.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                println("Object has been saved.")
            }
            
        }
        
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return nil
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

