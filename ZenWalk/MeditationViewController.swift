//
//  MeditationViewController.swift
//  ZenWalkThoughts
//
//  Created by Pamina Lin on 7/13/15.
//  Copyright (c) 2015 Pamina Lin. All rights reserved.
//


import AVFoundation
import CoreLocation
import CoreMotion
import MapKit
import Parse
import UIKit

class MeditationViewController: UIViewController, AVAudioPlayerDelegate,CLLocationManagerDelegate, MKMapViewDelegate, OEEventsObserverDelegate {
    
    @IBOutlet weak var theMap: MKMapView!
    lazy var motionManager = CMMotionManager()
    var avPlayer1:AVPlayerItem!
    var avPlayer2:AVPlayerItem!
    var avPlayer3:AVPlayerItem!
    var avPlayer4:AVPlayerItem!
    var avPlayer5:AVPlayerItem!
    var currentStage:NSString = "Not Started"
    var condition: String!  // the meditation condition
    var queue:AVQueuePlayer!
    var x:NSString = "No X"
    var y:NSString = "No Y"
    var z:NSString = "No Z"
    
    var openEarsEventsObserver: OEEventsObserver = OEEventsObserver()
    var currentHypothesis: String = ""
    
    var manager: CLLocationManager!
    var myLocations: [CLLocation] = []
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(false, animated:  true)
        queue = AVQueuePlayer()
        println(condition)
        
        // Set up the audio players
        let fileURL:NSURL = NSBundle.mainBundle().URLForResource("1", withExtension: "mp3")!
        var error: NSError?
        avPlayer1 = AVPlayerItem(URL: fileURL)
        if avPlayer1 == nil {
            if let e = error {
                println(e.localizedDescription)
            }
        }
        
        let fileURL2:NSURL = NSBundle.mainBundle().URLForResource("2", withExtension: "mp3")!
        var error2: NSError?
        avPlayer2 = AVPlayerItem(URL: fileURL2)
        if avPlayer2 == nil {
            if let e = error2 {
                println(e.localizedDescription)
            }
        }
        
        let fileURL3:NSURL = NSBundle.mainBundle().URLForResource("3", withExtension: "mp3")!
        var error3: NSError?
        avPlayer3 = AVPlayerItem(URL: fileURL3)
        if avPlayer3 == nil {
            if let e = error3 {
                println(e.localizedDescription)
            }
        }
        
        let fileURL4Tree:NSURL = NSBundle.mainBundle().URLForResource("4a", withExtension: "mp3")!
        var error4Tree: NSError?
        avPlayer4 = AVPlayerItem(URL: fileURL4Tree)
        if avPlayer4 == nil {
            if let e = error4Tree {
                println(e.localizedDescription)
            }
        }

        
        // Condition A: Walk around tree in a loop
        if self.condition == "A" {
            let fileURL5:NSURL = NSBundle.mainBundle().URLForResource("5a", withExtension: "mp3")!
            var error5: NSError?
            avPlayer5 = AVPlayerItem(URL: fileURL)
            if avPlayer5 == nil {
                if let e = error5 {
                    println(e.localizedDescription)
                }
            }
        }
        
        // Condition B: Spin self next to tree
        else if self.condition == "B" {
            let fileURL5:NSURL = NSBundle.mainBundle().URLForResource("5b", withExtension: "mp3")!
            var error5: NSError?
            avPlayer5 = AVPlayerItem(URL: fileURL)
            if avPlayer5 == nil {
                if let e = error5 {
                    println(e.localizedDescription)
                }
            }
        }
        
        // etc
        
        
        // Set up Core Motion
        if motionManager.accelerometerAvailable {
            let q = NSOperationQueue()
            motionManager.accelerometerUpdateInterval = 0.2
            motionManager.startAccelerometerUpdatesToQueue(q, withHandler: {(data: CMAccelerometerData!, error:NSError!) in
                if data != nil {
                    self.x = String(format:"%f", data.acceleration.x)
                    self.y = String(format:"%f", data.acceleration.y)
                    self.z = String(format:"%f", data.acceleration.z)
                }
            })
        } else {
            println("Accelerometer is not available")
        }
        
        setUpAVQueuePlayer()
    }
    

    func setUpAVQueuePlayer() {
        if queue != nil {
            queue.removeAllItems()
        }
        
        queue.insertItem(avPlayer1, afterItem: nil)
        queue.insertItem(avPlayer2, afterItem: nil)
        queue.insertItem(avPlayer3, afterItem: nil)
        
        // Walk around tree in a circle
        if self.condition == "A" {
            //queue.insertItem(avPlayer4Tree, afterItem: nil)
            //queue.insertItem(avPlayer5TreeCircle, afterItem: nil)
        }
            
        // Spin yourself around near tree
        else if self.condition == "B" {
            //queue.insertItem(avPlayer4Tree, afterItem: nil)
            //queue.insertItem(avPlayer5TreeSpin, afterItem: nil)
        }
        
        // Color thing
        else if self.condition == "C" {
            //queue.insertItem(avPlayer4Rock, afterItem: nil)
            //queue.insertItem(avPlayer5GreyRock, afterItem: nil)
            //queue.insertItem(avPlayer5Rocks, afterItem: nil)
        }
        
        queue.seekToTime(CMTimeMake(0, 1))
        
        
        // Set up the location manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        
        // Set up the map view
        theMap.delegate = self
        theMap.mapType = MKMapType.Standard
        theMap.showsUserLocation = true
        
        // Set up the language model
        var lmGenerator : OELanguageModelGenerator = OELanguageModelGenerator()
        var words : [String] = ["light", "dark", "medium", "brown", "lime", "black", "red", "orange", "yellow", "green", "blue", "purple", "turquoise", "pink", "white", "magenta", "violet", "maroon", "gray", "rainbow"]
        var name = "languageModelFiles"
        var error = lmGenerator.generateLanguageModelFromArray(words, withFilesNamed: name, forAcousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"))
        
        var lmPath : String = String()
        var dicPath : String = String()
        
        if (error == nil) {
            
            lmPath = lmGenerator.pathToSuccessfullyGeneratedLanguageModelWithRequestedName(name)
            dicPath = lmGenerator.pathToSuccessfullyGeneratedDictionaryWithRequestedName(name)
            
        } else {
            println(error.localizedDescription)
        }
        
        var sphinxController : OEPocketsphinxController = OEPocketsphinxController.sharedInstance()
        sphinxController.setActive(true, error: nil)
        sphinxController.startListeningWithLanguageModelAtPath(lmPath, dictionaryAtPath: dicPath, acousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"), languageModelIsJSGF: false)
        
        openEarsEventsObserver.delegate = self
    

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
            
            //PARSE STUFF
            // Save the location to Parse
            let loc = PFObject(className: "Location")
            loc["latitude"] = c2.latitude
            loc["longitude"] = c2.longitude
            //loc["session"] = defaults.stringForKey("session") // change to constant later
            loc["session"] = "test"
            
            // which stage are we at?
            if queue.currentItem != nil {
                currentStage = queue.currentItem.description
                currentStage = currentStage.substringFromIndex(currentStage.length-8)
                loc["stage"] = currentStage.substringToIndex(2)
            } else {
                currentStage = "none"
                loc["stage"] = currentStage
            }
            //currentStage = queue.currentItem.description
            
            
            // Save accelerometer data to Parse
            loc["x"] = self.x
            loc["y"] = self.y
            loc["z"] = self.z
            
            // Save the color data to Parse
            loc["color"] = self.currentHypothesis
            self.currentHypothesis = ""
            println(self.currentHypothesis)
            
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
    
    var isPlaying = false
    
    @IBAction func playButton(sender: UIButton) {
        // Start updating location
        if sender.titleLabel!.text == "Start" {
            manager.startUpdatingLocation()
            println("updating location")
        }
        
        // Start playing
        if !isPlaying {
            manager.startUpdatingLocation()
            isPlaying = true
            sender.setTitle("Pause", forState: UIControlState.Normal)
            queue.play()
        } else {
            manager.stopUpdatingLocation()
            isPlaying = false
            sender.setTitle("Play", forState: UIControlState.Normal)
            queue.pause()
        }
    }
    
    // OEEventsObserver delegate methods
    func pocketsphinxDidReceiveHypothesis(hypothesis: String!, recognitionScore: String!, utteranceID: String!) {
        //println("The received hypothesis is " + hypothesis + " with a score of " + recognitionScore + "and an ID of " + utteranceID)
        // if score is a certain certainty
        self.currentHypothesis = hypothesis
        // add the hypothesis to wherever you wanna store it
    }
    
    func pocketsphinxDidStartListening() {
        //println("Pocketsphinx is now listening.")
    }
    
    func pocketsphinxDidDetectSpeech() {
        //println("Pocketsphinx has detected speech.")
    }
    
    func pocketsphinxDidDetectFinishedSpeech() {
        //println("Pocketsphinx has detected a period of silence, concluding an utterance.")
    }
    
    func pocketsphinxDidStopListening() {
        //println("Pocketsphinx has stopped listening.")
    }
    
    func pocketsphinxDidSuspendRecognition() {
        //println("Pocketsphinx has suspended recognition")
    }
    
    func pocketsphinxDidResumeRecognition() {
        //println("Pocketsphinx has resumed recognition")
    }
    
    func pocketsphinxDidChangeLanguageModelToFile(newLanguageModelPathAsString: String!, andDictionary newDictionaryPathAsString: String!) {
        println("Pocketsphinx is now using the following language model: " + newLanguageModelPathAsString + " and the following dictionary: " + newDictionaryPathAsString)
    }
    
    func pocketSphinxContinuousSetupDidFailWithReason(reasonForFailure: String!) {
        println("Listening setup wasn't successful and returned the failure reason " + reasonForFailure)
    }
    
    func pocketSphinxContinuousTeardownDidFailWithReason(reasonForFailure: String!) {
        println("Listening teardown wasn't successful and returned with the following failure reason: " + reasonForFailure)
    }
    
    func testRecognitionCompleted() {
        println("A test file that was submitted for recognition is now compete")
    }


    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func logoutButton(sender: UIBarButtonItem) {
        PFUser.logOut()
        performSegueWithIdentifier("toLogin", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toLogin" {
            var svc = segue.destinationViewController as! SignUpInViewController
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
