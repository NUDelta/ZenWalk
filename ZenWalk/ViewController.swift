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
import CoreMotion
import AVFoundation



class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, AVAudioPlayerDelegate, CLLocationManagerDelegate, MKMapViewDelegate{
    @IBOutlet var theMap: MKMapView!
    lazy var motionManager = CMMotionManager()
    var avPlayer1:AVPlayerItem!
    var avPlayer2:AVPlayerItem!
    var avPlayer3:AVPlayerItem!
    var avPlayer4:AVPlayerItem!
    var currentStage:NSString = "Not Started"
    var conditions:NSArray!
    var selectedCondition:NSString = "Not Selected"
    var queue:AVQueuePlayer!
    var x:NSString = "No X"
    var y:NSString = "No Y"
    var z:NSString = "No Z"
    
    @IBOutlet weak var conditionControl: UISegmentedControl!
    @IBOutlet weak var sessionName: UITextField!
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []

    /*override func viewDidAppear(animated: Bool) {
        var logInController = PFLogInViewController()
        logInController.delegate = self
        self.presentViewController(logInController, animated:true, completion: nil)

    }*/
    func segmentedControlValueChange(sender : UISegmentedControl){
        let segindex = sender.selectedSegmentIndex
        self.selectedCondition = sender.titleForSegmentAtIndex(segindex)!
        println("condition = " + (self.selectedCondition as String))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.conditions = ["A","B","C"]

        
        // Set up the audio players
        let fileURL:NSURL = NSBundle.mainBundle().URLForResource("Part 1", withExtension: "mp3")!
        var error: NSError?
        avPlayer1 = AVPlayerItem(URL: fileURL)
        if avPlayer1 == nil {
            if let e = error {
                println(e.localizedDescription)
            }
        }
        
        let fileURL2:NSURL = NSBundle.mainBundle().URLForResource("Part 2", withExtension: "mp3")!
        var error2: NSError?
        avPlayer2 = AVPlayerItem(URL: fileURL2)
        if avPlayer2 == nil {
            if let e = error2 {
                println(e.localizedDescription)
            }
        }
        
        let fileURL3:NSURL = NSBundle.mainBundle().URLForResource("Part 3", withExtension: "mp3")!
        var error3: NSError?
        avPlayer3 = AVPlayerItem(URL: fileURL3)
        if avPlayer3 == nil {
            if let e = error3 {
                println(e.localizedDescription)
            }
        }
        
        let fileURL4:NSURL = NSBundle.mainBundle().URLForResource("Part 4", withExtension: "mp3")!
        var error4: NSError?
        avPlayer4 = AVPlayerItem(URL: fileURL4)
        if avPlayer4 == nil {
            if let e = error4 {
                println(e.localizedDescription)
            }
        }
        
        var avPlayerItemsArray = [AVPlayerItem]()
        avPlayerItemsArray.append(avPlayer1)
        avPlayerItemsArray.append(avPlayer2)
        avPlayerItemsArray.append(avPlayer3)
        avPlayerItemsArray.append(avPlayer4)
        
        queue = AVQueuePlayer(items: avPlayerItemsArray)
        
    
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
        
        //set up Core Motion
        if motionManager.accelerometerAvailable{
            let queue = NSOperationQueue()
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
                {(data: CMAccelerometerData!, error: NSError!) in
                    
                    println("X = \(data.acceleration.x)")
                    println("Y = \(data.acceleration.y)")
                    println("Z = \(data.acceleration.z)")
                    self.x = String(format:"%f", data.acceleration.x)
                    self.y = String(format:"%f", data.acceleration.y)
                    self.z = String(format:"%f", data.acceleration.z)

                }
            )
        } else {
            println("Accelerometer is not available")
        }

        
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
            loc["session"] = sessionName.text
            
            // which stage are we at?
            currentStage = queue.currentItem.description
            
            loc["stage"] = currentStage.substringFromIndex(currentStage.length - 7)
           
            if (self.currentStage == "Part 4"){
                if self.selectedCondition == "A" {
                    // set up condition A 4th Stage
                } else if self.selectedCondition == "B" {
                    // set up condition B 4th Stage
                } else if self.selectedCondition == "C" {
                    // set up condition C 4th Stageg
                }
            }
            loc.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                println("Object has been saved.")
            }
            
        }
        // will use this as an opportunity to check currentStage, should be done in another method later.
        

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
    
    // Play Part1 when standing
    // Play Part2 when walking -- focus on posture
    // Play Part3 when walking -- focus on breath, emotions
    // Play Part4 when observing
    
    //optional func audioPlayerDidFinishPlaying(_player: AVAudioPlayer!, successfully flag: Bool)
    // when user pauses at preknown object, play a certain file
    // also to switch out different interactions
    
    var isPlaying = false
    
    @IBAction func playButton(sender: AnyObject) {
        if (!isPlaying) {
            isPlaying = true
            sender.setTitle("Pause", forState: UIControlState.Normal)
            queue.play()
        
        }
        else {
            isPlaying = false
            sender.setTitle("Play", forState: UIControlState.Normal)
            
            queue.pause()
        }
    }
    
    
    


}

