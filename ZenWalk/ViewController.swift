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
import AVFoundation



class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, AVAudioPlayerDelegate, CLLocationManagerDelegate, MKMapViewDelegate
{
    @IBOutlet var theMap: MKMapView!
    
    var avPlayer1:AVAudioPlayer!
    var avPlayer2:AVAudioPlayer!
    var avPlayer3:AVAudioPlayer!
    var avPlayer4:AVAudioPlayer!
    
    var player1:AVPlayer!
    var player2:AVPlayer!
    var player3:AVPlayer!
    var player4:AVPlayer!
    
    
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []

    /*override func viewDidAppear(animated: Bool) {
        var logInController = PFLogInViewController()
        logInController.delegate = self
        self.presentViewController(logInController, animated:true, completion: nil)

    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the audio players
        let fileURL:NSURL = NSBundle.mainBundle().URLForResource("Part 1", withExtension: "mp3")!
        var error: NSError?
        self.avPlayer1 = AVAudioPlayer(contentsOfURL: fileURL, error: &error)
        if self.avPlayer1 == nil {
            if let e = error {
                println(e.localizedDescription)
            }
        }
        
        let asset1 = AVAsset.assetWithURL(fileURL) as? AVAsset
        let playerItem1 = AVPlayerItem(asset: asset1)
        player1 = AVPlayer(playerItem: playerItem1)
        player1.volume = 1.0
        
        avPlayer1.delegate = self
        avPlayer1.prepareToPlay()
        avPlayer1.volume = 1.0
        
        let fileURL2:NSURL = NSBundle.mainBundle().URLForResource("Part 2", withExtension: "mp3")!
        var error2: NSError?
        self.avPlayer2 = AVAudioPlayer(contentsOfURL: fileURL2, error: &error2)
        if self.avPlayer2 == nil {
            if let e = error2 {
                println(e.localizedDescription)
            }
        }
        
        
        avPlayer2.delegate = self
        avPlayer2.prepareToPlay()
        avPlayer2.volume = 1.0
        
        let fileURL3:NSURL = NSBundle.mainBundle().URLForResource("Part 3", withExtension: "mp3")!
        var error3: NSError?
        self.avPlayer3 = AVAudioPlayer(contentsOfURL: fileURL3, error: &error3)
        if self.avPlayer3 == nil {
            if let e = error3 {
                println(e.localizedDescription)
            }
        }
        
        avPlayer3.delegate = self
        avPlayer3.prepareToPlay()
        avPlayer3.volume = 1.0
        
        let fileURL4:NSURL = NSBundle.mainBundle().URLForResource("Part 4", withExtension: "mp3")!
        var error4: NSError?
        self.avPlayer4 = AVAudioPlayer(contentsOfURL: fileURL4, error: &error4)
        if self.avPlayer4 == nil {
            if let e = error4 {
                println(e.localizedDescription)
            }
        }
        
        avPlayer4.delegate = self
        avPlayer4.prepareToPlay()
        avPlayer4.volume = 1.0
    
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

    var isPlaying = false
    
    // Play Part1 when standing
    // Play Part2 when walking -- focus on posture
    // Play Part3 when walking -- focus on breath, emotions
    // Play Part4 when observing
    
    //optional func audioPlayerDidFinishPlaying(_player: AVAudioPlayer!, successfully flag: Bool)
    // when user pauses at preknown object, play a certain file
    // also to switch out different interactions
    
    
    
    @IBAction func playButton(sender: AnyObject) {
        
        self.avPlayer1.play()
        
        while (self.avPlayer1.playing) {
            
        }
        
        self.avPlayer2.play()
        
        while (self.avPlayer2.playing) {
            
        }
        
        self.avPlayer3.play()
        
        while (self.avPlayer3.playing) {
            
        }
        
        self.avPlayer4.play()
        /*if (!isPlaying) {
        
            isPlaying = true
            sender.setTitle("Pause", forState: UIControlState.Normal)
            
            self.avPlayer1.play()
            
            while (self.avPlayer1.playing) {
                
            }
            
            self.avPlayer2.play()
            
            while (self.avPlayer2.playing) {
                
            }
        
            self.avPlayer3.play()
            
            while (self.avPlayer3.playing) {
                
            }
            
            self.avPlayer4.play()
            
        
        }
        else {
            isPlaying = false
            sender.setTitle("Play", forState: UIControlState.Normal)
            
            self.avPlayer1.stop()
            self.avPlayer2.stop()
            self.avPlayer3.stop()
            self.avPlayer4.stop()
            
        }*/
    }

}

