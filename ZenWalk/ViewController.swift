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



class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, AVAudioPlayerDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate, OEEventsObserverDelegate {
    @IBOutlet var theMap: MKMapView!
    lazy var motionManager = CMMotionManager()
    var avPlayer1:AVPlayerItem!
    var avPlayer2:AVPlayerItem!
    var avPlayer3:AVPlayerItem!
    var avPlayer4Tree:AVPlayerItem!
    var avPlayer4Rock:AVPlayerItem!
    var avPlayer5TreeCircle:AVPlayerItem!
    var avPlayer5TreeSpin:AVPlayerItem!
    var avPlayer5GreyRock:AVPlayerItem! // to be used with avPlayer5Rocks
    var avPlayer5Rocks:AVPlayerItem!
    var avPlayer5ColorRocks1:AVPlayerItem!
    var avPlayer5ColorRocks2:AVPlayerItem!
    var avPlayer5ColorRocks3:AVPlayerItem!
    var currentStage:NSString = "Not Started"
    var selectedCondition:NSString = "A" // Default set to condition A
    var queue:AVQueuePlayer!
    var x:NSString = "No X"
    var y:NSString = "No Y"
    var z:NSString = "No Z"
    
    var controller:UIAlertController?
    
    // Speech to text 
    var openEarsEventsObserver : OEEventsObserver = OEEventsObserver()
    var currentHypothesis = ""
    
    
    @IBOutlet var conditionControl: UISegmentedControl!
    
    @IBOutlet weak var sessionName: UITextField!
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []

    /*override func viewDidAppear(animated: Bool) {
        var logInController = PFLogInViewController()
        logInController.delegate = self
        self.presentViewController(logInController, animated:true, completion: nil)

    }*/
    
    @IBAction func segmentedControlValueChanged(sender: UISegmentedControl) {
        
        let selectedSegmentIndex = sender.selectedSegmentIndex
        let selectedSegmentText = sender.titleForSegmentAtIndex(selectedSegmentIndex)
        
        self.selectedCondition = selectedSegmentText!
        
        setUpAVQueuePlayer()
        println("Segment \(selectedSegmentIndex) with text" + " of \(selectedSegmentText) is selected")
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queue = AVQueuePlayer()
        
        conditionControl.addTarget(self, action: "segmentedControlValueChanged:", forControlEvents: .ValueChanged)
        
        self.view.addSubview(conditionControl)
        self.sessionName.delegate = self
        

        // set up alert controller
        controller = UIAlertController(title: "Condition or Session not set",
            message: "You must set both the session and the condition before starting.",
            preferredStyle: .Alert)
        let action = UIAlertAction(
                title: "Done",
                style: UIAlertActionStyle.Default,
                handler: {(paramAction:UIAlertAction!) in println("Tried to start ZenWalk without session or condition")
                })
        controller!.addAction(action)
        
                
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
        
        let fileURL4Tree:NSURL = NSBundle.mainBundle().URLForResource("Part 4 Tree", withExtension: "mp3")!
        var error4Tree: NSError?
        avPlayer4Tree = AVPlayerItem(URL: fileURL4Tree)
        if avPlayer4Tree == nil {
            if let e = error4Tree {
                println(e.localizedDescription)
            }
        }
        
        let fileURL4Rocks:NSURL = NSBundle.mainBundle().URLForResource("Part 4 Rocks", withExtension: "mp3")!
        var error4Rocks: NSError?
        avPlayer4Rock = AVPlayerItem(URL: fileURL4Rocks)
        if avPlayer4Rock == nil {
            if let e = error4Rocks {
                println(e.localizedDescription)
            }
        }
        
        let fileURL5TreeCircle:NSURL = NSBundle.mainBundle().URLForResource("Part 5 Tree Circle", withExtension: "mp3")!
        var error5TreeCircle: NSError?
        avPlayer5TreeCircle = AVPlayerItem(URL: fileURL5TreeCircle)
        if avPlayer5TreeCircle == nil {
            if let e = error5TreeCircle {
                println(e.localizedDescription)
            }
        }
        
        let fileURL5TreeSpin:NSURL = NSBundle.mainBundle().URLForResource("Part 5 Tree Spin", withExtension: "mp3")!
        var error5TreeSpin: NSError?
        avPlayer5TreeSpin = AVPlayerItem(URL: fileURL5TreeSpin)
        if avPlayer5TreeSpin == nil {
            if let e = error5TreeSpin {
                println(e.localizedDescription)
            }
        }
        
        let fileURL5GreyRock:NSURL = NSBundle.mainBundle().URLForResource("Part 5 Grey Rock", withExtension: "mp3")!
        var error5gr: NSError?
        avPlayer5GreyRock = AVPlayerItem(URL: fileURL5GreyRock)
        if avPlayer5GreyRock == nil {
            if let e = error5gr {
                println(e.localizedDescription)
            }
        }
        
        let fileURL5Rocks:NSURL = NSBundle.mainBundle().URLForResource("Part 5 Rocks", withExtension: "mp3")!
        var error5rock: NSError?
        avPlayer5Rocks = AVPlayerItem(URL: fileURL5Rocks)
        if avPlayer5Rocks == nil {
            if let e = error5rock {
                println(e.localizedDescription)
            }
        }
        
        let fileURL5ColorRocks1:NSURL = NSBundle.mainBundle().URLForResource("ColorRock1", withExtension: "mp3")!
        var error5color: NSError?
        avPlayer5ColorRocks1 = AVPlayerItem(URL: fileURL5ColorRocks1)
        if avPlayer5ColorRocks1 == nil {
            if let e = error5color {
                println(e.localizedDescription)
            }
        }
        
        let fileURL5ColorRocks2:NSURL = NSBundle.mainBundle().URLForResource("ColorRock2", withExtension: "mp3")!
        var error5color2: NSError?
        avPlayer5ColorRocks2 = AVPlayerItem(URL: fileURL5ColorRocks2)
        if avPlayer5ColorRocks2 == nil {
            if let e = error5color2 {
                println(e.localizedDescription)
            }
        }

        
        let fileURL5ColorRocks3:NSURL = NSBundle.mainBundle().URLForResource("ColorRock3", withExtension: "mp3")!
        var error5color3: NSError?
        avPlayer5ColorRocks3 = AVPlayerItem(URL: fileURL5ColorRocks3)
        if avPlayer5ColorRocks3 == nil {
            if let e = error5color3 {
                println(e.localizedDescription)
            }
        }

        
        
        //set up Core Motion
        if motionManager.accelerometerAvailable {
            let queue = NSOperationQueue()
            
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
                {(data: CMAccelerometerData!, error: NSError!) in
                    
                    if self.motionManager.accelerometerData != nil {
                        println("X = \(data.acceleration.x)")
                        println("Y = \(data.acceleration.y)")
                        println("Z = \(data.acceleration.z)")
                        self.x = String(format:"%f", data.acceleration.x)
                        self.y = String(format:"%f", data.acceleration.y)
                        self.z = String(format:"%f", data.acceleration.z)
                    }
                    
                }
            )
            
        } else {
            println("Accelerometer is not available")
        }
        
        setUpAVQueuePlayer()
    }
    
    // Set up AVQueuePlayer AND set up location manager
    func setUpAVQueuePlayer(){
        
        if queue != nil {
            queue.removeAllItems()
            println("removing items")
        }
        
        queue.insertItem(avPlayer1, afterItem: nil)
        queue.insertItem(avPlayer2, afterItem: nil)
        queue.insertItem(avPlayer3, afterItem: nil)
        
        // check self.selectedCondition
        // Walk around tree in a circle
        if self.selectedCondition == "A" {
            queue.insertItem(avPlayer4Tree, afterItem: nil)
            queue.insertItem(avPlayer5TreeCircle, afterItem: nil)
            println("A")
        }
        // Spin yourself around near tree
        else if self.selectedCondition == "B" {
            queue.insertItem(avPlayer4Tree, afterItem: nil)
            queue.insertItem(avPlayer5TreeSpin, afterItem: nil)
            println("B")
        
        }
        // Identify known grey rock
        else if self.selectedCondition == "C" {
            queue.insertItem(avPlayer4Rock, afterItem: nil)
            queue.insertItem(avPlayer5GreyRock, afterItem: nil)
            queue.insertItem(avPlayer5Rocks, afterItem: nil)
            println("C")
        }
        // Observe rocks
        else if self.selectedCondition == "D" {
            queue.insertItem(avPlayer4Rock, afterItem: nil)
            queue.insertItem(avPlayer5Rocks, afterItem: nil)
            println("D")
        }
        
        // Observe colors of rocks
        else if self.selectedCondition == "E" {
            queue.insertItem(avPlayer4Rock, afterItem: nil)
            queue.insertItem(avPlayer5ColorRocks1, afterItem: nil)
            queue.insertItem(avPlayer5ColorRocks2, afterItem: nil)
            queue.insertItem(avPlayer5ColorRocks3, afterItem: nil)
            println("E")
        }
        
        queue.seekToTime(CMTimeMake(0, 1))
    
        
        // Set up the location manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        //manager.startUpdatingLocation()
        
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
            
            
            // Save the location to Parse
            let loc = PFObject(className: "Location")
            loc["latitude"] = c2.latitude
            loc["longitude"] = c2.longitude
            loc["session"] = sessionName.text
            
            // which stage are we at?
            if queue.currentItem != nil {
                currentStage = queue.currentItem.description
                loc["stage"] = currentStage.substringFromIndex(currentStage.length - 20)
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // OEEventsObserver delegate methods
    
    func pocketsphinxDidReceiveHypothesis(hypothesis: String!, recognitionScore: String!, utteranceID: String!) {
        println("The received hypothesis is " + hypothesis + " with a score of " + recognitionScore + "and an ID of " + utteranceID)
        // if score is a certain certainty
        self.currentHypothesis = hypothesis
        // add the hypothesis to wherever you wanna store it
    }
    
    func pocketsphinxDidStartListening() {
        println("Pocketsphinx is now listening.")
    }
    
    func pocketsphinxDidDetectSpeech() {
        println("Pocketsphinx has detected speech.")
    }
    
    func pocketsphinxDidDetectFinishedSpeech() {
        println("Pocketsphinx has detected a period of silence, concluding an utterance.")
    }
    
    func pocketsphinxDidStopListening() {
        println("Pocketsphinx has stopped listening.")
    }
    
    func pocketsphinxDidSuspendRecognition() {
        println("Pocketsphinx has suspended recognition")
    }
    
    func pocketsphinxDidResumeRecognition() {
        println("Pocketsphinx has resumed recognition")
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

    
    // Play Part1 when standing
    // Play Part2 when walking -- focus on posture
    // Play Part3 when walking -- focus on breath, emotions
    // Play Part4 when observing
    
    //optional func audioPlayerDidFinishPlaying(_player: AVAudioPlayer!, successfully flag: Bool)
    // when user pauses at preknown object, play a certain file
    // also to switch out different interactions
    
    
    var isPlaying = false
    
    @IBAction func playButton(sender: AnyObject) {
        // check that session and session are set
        if (self.sessionName.text == "") || (self.selectedCondition == "Not Selected"){
            self.presentViewController(self.controller!, animated: true, completion: nil)
        } else {
            // if queue player null, set up for this condition
            // Start updating location
            if sender.titleLabel!!.text == "Start" {
                manager.startUpdatingLocation()
                println("updating location")
            }
        
            // start playing for this condition
            if (!isPlaying) {
                    // set self.selectedCondition
                    // load up player
                    manager.startUpdatingLocation()
                    isPlaying = true
                    sender.setTitle("Pause", forState: UIControlState.Normal)
                    queue.play()
                
            } else {
                // should we stop updating location when paused??
                manager.stopUpdatingLocation()
                isPlaying = false
                sender.setTitle("Play", forState: UIControlState.Normal)
                queue.pause()
            }
        }

    }
    
    

}

