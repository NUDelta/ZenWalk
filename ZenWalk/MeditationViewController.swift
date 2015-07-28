//
//  MeditationViewController.swift
//  ZenWalkThoughts
//
//  Created by Pamina Lin on 7/13/15.
//  Copyright (c) 2015 Pamina Lin. All rights reserved.
//


import AudioToolbox
import AVFoundation
import CoreLocation
import CoreMotion
import MapKit
import Parse
import UIKit

class MeditationViewController: UIViewController, AVAudioPlayerDelegate,CLLocationManagerDelegate, MKMapViewDelegate, OEEventsObserverDelegate {
    
    let defaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var theMap: MKMapView!
    lazy var motionManager = CMMotionManager()
    
    var audioSession:AVAudioSession!
    var queue:AVQueuePlayer!
    var avPlayer1:AVPlayerItem!
    var avPlayer2:AVPlayerItem!
    var avPlayer3:AVPlayerItem!
    var avPlayer4:AVPlayerItem!
    var avPlayer5:AVPlayerItem!
    var avPlayer6:AVPlayerItem!
    var avPlayer7:AVPlayerItem!
    var avPlayer8:AVPlayerItem!
    var avPlayer9:AVPlayerItem!
    var avPlayerEnd:AVPlayerItem!
    
    var currentStage:NSString = "Not Started"
    var condition: String!  // the meditation condition
    var timeStamp:String!
    var x:NSString = "No X"
    var y:NSString = "No Y"
    var z:NSString = "No Z"
    var rotationX:NSString = "No rotationX"
    var rotationY:NSString = "No rotationY"
    var rotationZ:NSString = "No rotation Z"
    
    var openEarsEventsObserver: OEEventsObserver = OEEventsObserver()
    var sphinxController : OEPocketsphinxController = OEPocketsphinxController.sharedInstance()
    var currentHypothesis: String = ""
    
    var manager:CLLocationManager!
    var myLocations:[CLLocation] = []
    
    var meditationIsFinished:Bool = false // only used right now for handling back bar button to previous screen (commented out)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.setNavigationBarHidden(false, animated:  true)
        self.timeStamp = getCurrentTimestampString()
        queue = AVQueuePlayer()
        audioSession = AVAudioSession()
        audioSession.setCategory(AVAudioSessionCategoryPlayback, error: nil)
        audioSession.setActive(true, error: nil)
        //println(condition)
        
        // Set up the audio players
        let fileURL:NSURL = NSBundle.mainBundle().URLForResource("Standing_1", withExtension: "mp3")!
        var error: NSError?
        avPlayer1 = AVPlayerItem(URL: fileURL)
        if avPlayer1 == nil {
            if let e = error {
                println(e.localizedDescription)
            }
        }
        
        let fileURL2:NSURL = NSBundle.mainBundle().URLForResource("WalkingPosture1_2", withExtension: "mp3")!
        var error2: NSError?
        avPlayer2 = AVPlayerItem(URL: fileURL2)
        if avPlayer2 == nil {
            if let e = error2 {
                println(e.localizedDescription)
            }
        }
        
        let fileURL3:NSURL = NSBundle.mainBundle().URLForResource("WalkingPosture2_2", withExtension: "mp3")!
        var error3: NSError?
        avPlayer3 = AVPlayerItem(URL: fileURL3)
        if avPlayer3 == nil {
            if let e = error3 {
                println(e.localizedDescription)
            }
        }
        
        // Condition A: 20 min
        if self.condition == "A" {
            
            // Observe trees
            let fileURL4:NSURL = NSBundle.mainBundle().URLForResource("ObserveTrees", withExtension: "mp3")!
            var error4: NSError?
            avPlayer4 = AVPlayerItem(URL: fileURL4)
            if avPlayer4 == nil {
                if let e = error4 {
                    println(e.localizedDescription)
                }
            }
            
            // Spin self near tree
            let fileURL5:NSURL = NSBundle.mainBundle().URLForResource("TreeSpin", withExtension: "mp3")!
            var error5: NSError?
            avPlayer5 = AVPlayerItem(URL: fileURL5)
            if avPlayer5 == nil {
                if let e = error5 {
                    println(e.localizedDescription)
                }
            }
        }
        
        // Condition B: 30 min
        else if self.condition == "B" {
            // Observe surroundings
            let fileURL4:NSURL = NSBundle.mainBundle().URLForResource("WalkingAwarenessOfSurroundings", withExtension: "mp3")!
            var error4: NSError?
            avPlayer4 = AVPlayerItem(URL: fileURL4)
            if avPlayer4 == nil {
                if let e = error4 {
                    println(e.localizedDescription)
                }
            }
            
            // Observe trees
            let fileURL5:NSURL = NSBundle.mainBundle().URLForResource("ObserveTrees", withExtension: "mp3")!
            var error5: NSError?
            avPlayer5 = AVPlayerItem(URL: fileURL5)
            if avPlayer5 == nil {
                if let e = error5 {
                    println(e.localizedDescription)
                }
            }
            
            // Circle tree
            let fileURL6:NSURL = NSBundle.mainBundle().URLForResource("TreeCircle", withExtension: "mp3")!
            var error6: NSError?
            avPlayer6 = AVPlayerItem(URL: fileURL5)
            if avPlayer6 == nil {
                if let e = error5 {
                    println(e.localizedDescription)
                }
            }
            
        }
        
        // Condition C: 40 min
        else if self.condition == "C" {
            // Walking, feelings
            let fileURL4:NSURL = NSBundle.mainBundle().URLForResource("WalkingObserveFeelings", withExtension: "mp3")!
            var error4: NSError?
            avPlayer4 = AVPlayerItem(URL: fileURL4)
            if avPlayer4 == nil {
                if let e = error4 {
                    println(e.localizedDescription)
                }
            }

            // Walking, emotions
            let fileURL5:NSURL = NSBundle.mainBundle().URLForResource("WalkingObserveEmotions", withExtension: "mp3")!
            var error5: NSError?
            avPlayer5 = AVPlayerItem(URL: fileURL5)
            if avPlayer5 == nil {
                if let e = error5 {
                    println(e.localizedDescription)
                }
            }

            // Walking, objects of consciousness
            let fileURL6:NSURL = NSBundle.mainBundle().URLForResource("WalkingObjectsofConsciousness", withExtension: "mp3")!
            var error6: NSError?
            avPlayer6 = AVPlayerItem(URL: fileURL6)
            if avPlayer6 == nil {
                if let e = error6 {
                    println(e.localizedDescription)
                }
            }
            
            // Walking awareness of surroundings
            let fileURL7:NSURL = NSBundle.mainBundle().URLForResource("WalkingAwarenessOfSurroundings", withExtension: "mp3")!
            var error7: NSError?
            avPlayer7 = AVPlayerItem(URL: fileURL7)
            if avPlayer7 == nil {
                if let e = error7 {
                    println(e.localizedDescription)
                }
            }

            // Observe trees
            let fileURL8:NSURL = NSBundle.mainBundle().URLForResource("ObserveTrees", withExtension: "mp3")!
            var error8: NSError?
            avPlayer8 = AVPlayerItem(URL: fileURL8)
            if avPlayer8 == nil {
                if let e = error8 {
                    println(e.localizedDescription)
                }
            }

            // Tree circle
            let fileURL9:NSURL = NSBundle.mainBundle().URLForResource("TreeCircle", withExtension: "mp3")!
            var error9: NSError?
            avPlayer9 = AVPlayerItem(URL: fileURL9)
            if avPlayer9 == nil {
                if let e = error9 {
                    println(e.localizedDescription)
                }
            }

        }
        
        
        // End
        let fileURLEnd:NSURL = NSBundle.mainBundle().URLForResource("End", withExtension: "mp3")!
        var errorEnd: NSError?
        avPlayerEnd = AVPlayerItem(URL: fileURLEnd)
        if avPlayerEnd == nil {
            if let e = errorEnd {
                println(e.localizedDescription)
            }
        }
        
        // Set up Core Motion (accelerometer and gyroscope)
        if motionManager.accelerometerAvailable {
            let q = NSOperationQueue()
            motionManager.accelerometerUpdateInterval = 0.1
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
        
        if motionManager.gyroAvailable {
            let queue = NSOperationQueue()
            motionManager.gyroUpdateInterval = 0.1
            motionManager.deviceMotionUpdateInterval = 0.01
            motionManager.startGyroUpdatesToQueue(queue, withHandler: {(data: CMGyroData!, error:NSError!) in
                if data != nil {
                    // Gyro data here
                    self.rotationX = String(format:"%f", data.rotationRate.x)
                    self.rotationY = String(format:"%f", data.rotationRate.y)
                    self.rotationZ = String(format:"%f", data.rotationRate.z)
                }
            })
        } else {
            println("Gyroscope is not available")
        }
        
        setUpAVQueuePlayer()
        
        // Check if audio route changed
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "routeChanged", name: "AVAudioSessionRouteChangeNotification", object: nil)
        //Check if the meditation is done playing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "meditationFinished", name: "AVPlayerItemDidPlayToEndTimeNotification", object:avPlayerEnd)
        
        manager.startUpdatingLocation()
        queue.play()
    }
    
    /*func createAVPlayerItem(filename: String) -> AVPlayerItem {
        let fileURL:NSURL = NSBundle.mainBundle().URLForResource(filename, withExtension: "mp3")!
        var error: NSError?
        var player: AVPlayerItem = AVPlayerItem(URL: fileURL)
        if player == nil {
            if let e = error {
                println(e.localizedDescription)
            }
        } else {
            return player
        }
    }*/
    
    func routeChanged() {
        // If the audio route changed, pause
        queue.pause()
        self.playPauseButton.setTitle("Play", forState: UIControlState.Normal)
        isPlaying = false
        
        // jk If audio route changes, keep playing
        println("route changed")
        //queue.play()
        //self.playPauseButton.setTitle("Pause", forState: UIControlState.Normal)
    }
    
    func meditationFinished() {
        
        self.meditationIsFinished = true
        
        // Save session to Parse
        let session = PFObject(className: "CompletedSession")
        session["user"] = defaults.stringForKey("username")
        //session["date"] = NSDate() //getCurrentTimestampString()
        
        session.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            //println("Object has been saved.")
        }
        
        // Update streak
        var streak: Int = 0
        
        var query = PFQuery(className: "CompletedSession")
        query.limit = 1000
        query.whereKey("user", equalTo: "kpl976")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error != nil {
                println("Error")
            } else {
                if let objects = objects as? [PFObject] {
                    for obj in objects {
                            println(obj.valueForKey("createdAt"))
                    }
                }
                streak = objects!.count
                println("found \(streak) objects")
            }
        }
        defaults.setObject(streak, forKey: "streak")
        // Segue to end
        performSegueWithIdentifier("toEnd", sender: self)
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            queue.pause()
            queue.removeAllItems()
            //audioSession.setActive(false, error: nil)
            sphinxController.stopListening()
        }
    }
    
    func getCurrentTimestampString() -> String {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        
        //println(formatter.stringFromDate(date))
        
        return formatter.stringFromDate(date)
    }
    
    func getDate(date: NSDate?) {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
    }

    func setUpAVQueuePlayer() {
        if queue != nil {
            queue.removeAllItems()
        }
        
        queue.insertItem(avPlayer1, afterItem: nil)
        queue.insertItem(avPlayer2, afterItem: nil)
        queue.insertItem(avPlayer3, afterItem: nil)
        
        // 20 min -- spin
        if self.condition == "A" {
            queue.insertItem(avPlayer4, afterItem: nil)
            queue.insertItem(avPlayer5, afterItem: nil)
        }
            
        // 30 min -- circle
        else if self.condition == "B" {
            queue.insertItem(avPlayer4, afterItem: nil)
            queue.insertItem(avPlayer5, afterItem: nil)
            queue.insertItem(avPlayer6, afterItem: nil)
        }
        
        // 40 min -- circle
        else if self.condition == "C" {
            queue.insertItem(avPlayer4, afterItem: nil)
            queue.insertItem(avPlayer5, afterItem: nil)
            queue.insertItem(avPlayer6, afterItem: nil)
            queue.insertItem(avPlayer7, afterItem: nil)
            queue.insertItem(avPlayer8, afterItem: nil)
            queue.insertItem(avPlayer9, afterItem: nil)
        }
        
        queue.insertItem(avPlayerEnd, afterItem: nil)
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
        
        sphinxController.setActive(true, error: nil)
        sphinxController.doNotWarnAboutPermissions = true
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
            loc["user"] = defaults.stringForKey("username")
            loc["session"] = defaults.stringForKey("username")! + self.timeStamp
            loc["condition"] = self.condition
            
            // which stage are we at?
            if queue.currentItem != nil {
                currentStage = queue.currentItem.description
                currentStage = currentStage.substringFromIndex(currentStage.length-8)
                loc["stage"] = currentStage.substringToIndex(2)
            } else {
                currentStage = "none"
                loc["stage"] = currentStage
            }
            
            // Save accelerometer data to Parse
            loc["x"] = self.x
            loc["y"] = self.y
            loc["z"] = self.z
            
            // Save gyroscope data to Parse
            loc["rotX"] = self.rotationX
            loc["rotY"] = self.rotationY
            loc["rotZ"] = self.rotationZ

            // Save the color data to Parse
            loc["color"] = self.currentHypothesis
            self.currentHypothesis = ""
            //println(self.currentHypothesis)
            
            loc.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                //println("Object has been saved.")
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
        /*if sender.titleLabel!.text == "Start" {
            manager.startUpdatingLocation()
            println("updating location")
        }
        */
        
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
        var storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        var vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController") as! SignUpInViewController
        self.showViewController(vc, sender: self)
    }
    
    /*@IBAction func backButton(sender: UIBarButtonItem) {
        if !meditationIsFinished {
            // If user isn't done walking, warn them
            let alertController = UIAlertController(title: "This will end your walk before it is completed.", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            var stopAction = UIAlertAction(title: "End Walk", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.segueToCondition()
            }
            var continueAction = UIAlertAction(title: "Keep Walking", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(stopAction)
            alertController.addAction(continueAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            performSegueWithIdentifier("toCondition", sender: self)
        }
    }
    
    func segueToCondition() {
        var storyboard: UIStoryboard = UIStoryboard(name: "Walk", bundle: nil)
        var vc = storyboard.instantiateViewControllerWithIdentifier("ConditionViewController") as! ConditionViewController
        self.showViewController(vc, sender: self)
    }*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toEnd" {
            var svc = segue.destinationViewController as! EndViewController
        }
        if segue.identifier == "toCondition" {
            var svc = segue.destinationViewController as! ConditionViewController
        }
    }
    
}
