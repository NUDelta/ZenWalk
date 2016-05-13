//
//  WalkViewController.swift
//  ZenWalk
//
//  Created by Pamina Lin on 1/15/16.
//  Copyright © 2016 Scott Cambo. All rights reserved.
//

import CoreLocation
import Foundation
import MapKit
import MediaPlayer
import Parse
import UIKit

class WalkViewController: UIViewController, MKMapViewDelegate, ExperienceManagerDelegate {

    

    // MARK: Properties
    var experienceManager:ExperienceManager!
    var musicPlayer:MPMusicPlayerController?
    @IBOutlet weak var mapView: MKMapView!
    //@IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var condition:String! // the meditation condition
    //var myLocations:[CLLocation] = []
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WalkViewController.back(_:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
        // TTS test
//        let mystring = "Hello World!  Find a place to stand for a little bit, before you begin to walk."
//        let utterance = AVSpeechUtterance(string: mystring)
//        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//        let synthesizer = AVSpeechSynthesizer()
//        synthesizer.speakUtterance(utterance)
        
        CLLocationManager().requestAlwaysAuthorization()
        
        
        // 20 min
        let moment1 = Sound(fileNames: ["what_is_mindfulness_1-45", "body_and_posture_awareness_2-00", "allow_mind_to_be_free_2-30"])
       
        
        // Condition A (21 min) - Stand at tree
        let moment2a = CollectorWithSound(fileNames: ["focus_on_environment_3-00"], dataLabel: "tree", sensors: [.Location])
        let moment2b = CollectorWithSound(fileNames: ["near_the_tree_2-00"], dataLabel: "tree", sensors: [.Location])
        let moment2c = ContinuousMoment(conditionFunc: movedAway, dataLabel: "tree", sensors: [.Location])
        // Condition B (21 min) - Walk back and forth in front of tree
        let moment2d = CollectorWithSound(fileNames: ["as_before_observe_tree_1-10"], dataLabel: "tree", sensors: [.Location])
        let moment3 = Sound(fileNames: ["reflect_3-20"])

        
        var stages: [MomentBlock] = []
        
        switch condition {
            case "A":
                let stage1 = MomentBlock(moments: [moment1], title: "Introduction")
                let stage2 = MomentBlock(moments: [moment2a], title: "Beginning to walk")
                let stage3 = MomentBlock(moments: [moment2b], title: "Stand in front of tree")
                let stage4 = MomentBlock(moments: [moment2c], title: "Interim at tree")
                let stage5 = MomentBlock(moments: [moment2d], title: "Stand in front of second tree")
                let stage6 = MomentBlock(moments: [moment3], title: "End")
                stages = [stage1, stage2, stage3, stage4, stage5, stage4, stage6]
                experienceManager = ExperienceManager(title: "condition A", momentBlocks: stages)
                break
            default:
                experienceManager = ExperienceManager(title: "no condition", momentBlocks: stages)
                break
        }
        
        experienceManager.delegate = self
        mapView.delegate = self
        mapView.mapType = MKMapType.Standard
        mapView.userTrackingMode = MKUserTrackingMode.FollowWithHeading
        mapView.showsUserLocation = true
        
        self.experienceManager.start()
        self.experienceManager.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: Actions
    @IBAction func controlPlayPause(sender: UIButton) {
        if self.playButton.titleLabel!.text == "Resume" {
            self.experienceManager.play()
            self.playButton.setTitle("Pause", forState: .Normal)
        }
        else {
            self.experienceManager.pause()
            self.playButton.setTitle("Resume", forState: .Normal)
        }
    }
    
    func movedAway() -> Bool {
        // Get user's current location
        let startingLocation = experienceManager.dataManager!.locationManager.location;
        // While user is within 15 meters of the initial location, return false
        while (startingLocation!.distanceFromLocation(experienceManager.dataManager!.locationManager.location!) < 15) {
            continue
        }
        return true
    }
    
    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
        self.experienceManager.pause()
    }
    
    // ExperienceManagerDelegate methods
    func didFinishStage() {
//        if let currentAnnotation = currentAnnotation {
//            mapView.removeAnnotation(currentAnnotation)
//        }
    }
    
    func didFinishExperience() {
        if self.navigationController != nil {
            //navController.popViewControllerAnimated(true)
            // change to segue to "FINISHED" view
            performSegueWithIdentifier("toEnd", sender: self)
        }
    }
    
    func didAddDestination(destLocation: CLLocationCoordinate2D, destinationName: String) {
        //addObjectToMap(destLocation, annotationTitle: destinationName)
    }
    
    // Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toEnd" {
            let svc = segue.destinationViewController as! EndViewController
        }
        if segue.identifier == "toCondition" {
            let svc = segue.destinationViewController as! ConditionViewController
        }
    }
    

}