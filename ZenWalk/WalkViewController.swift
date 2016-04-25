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
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
        // TTS test
//        let mystring = "Hello World!  Find a place to stand for a little bit, before you begin to walk."
//        let utterance = AVSpeechUtterance(string: mystring)
//        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//        let synthesizer = AVSpeechSynthesizer()
//        synthesizer.speakUtterance(utterance)
        
        CLLocationManager().requestAlwaysAuthorization()
        
        // 15 min
        let conditionA_1 = Sound(fileNames: ["Standing_1-16min", "WalkObservingBody_1-16min", "WalkingBreathingShort_3"])
        let conditionA_2 = CollectorWithSound(fileNames: ["ObservingTrees_3-20min", "TreeCircle_5"], title: "Circle around tree A", dataLabel: "tree", sensors: [.Location, .Accel])
        let conditionA_end = Sound(fileNames: ["End"])
        
        
        // 20 min
//        let conditionB_1 = Sound(fileNames: ["Standing_2min", "WalkingPosture1_2", "WalkingPosture2_2"])
//        let conditionB_2 = CollectorWithSound(fileNames: ["ObserveTrees_4", "TreeSpin_5"], title: "Spin next to tree B", dataLabel: "tree", sensors: [.Location, .Accel])
//        let conditionB_end = Sound(fileNames: ["End"])
        let conditionB_1 = Sound(fileNames: ["Standing_3-20", "WalkObservingBody_1-16min", "WalkingBreathingShort_3"])
        let conditionB_2 = CollectorWithSound(fileNames: ["ObservingTrees_3-20min", "CircleFirstTree_2-48"], title: "Circle around tree B", dataLabel: "tree", sensors: [.Location, .Accel])
        let conditionB_3 = CollectorWithSound(fileNames: ["FindAnotherTree_1-05", "CircleNextTree_2-33"], title: "Circle around another B", dataLabel: "tree", sensors: [.Location, .Accel])
        let conditionB_end = Sound(fileNames: ["End_3-03"])

        
        let conditionC_1 = Sound(fileNames: ["Standing_2min", "WalkingPosture1_2", "WalkingPosture2_2", "WalkingAwarenessofSurroundings_3"])
        let conditionC_2 = CollectorWithSound(fileNames: ["ObserveTrees_4", "TreeCircle_5"], title: "Walk in Circle Around Tree C", dataLabel: "tree", sensors: [.Location])
        let conditionC_end = Sound(fileNames: ["End"])

        /*
        let conditionD_1 = Sound(fileNames: ["Standing_1", "WalkingPosture1_2", "WalkingPosture2_2", "WalkingFeelings_3", "WalkingEmotion_3", "WalkingObjofConsciousness_3", "WalkingAwarenessofSurroundings_3"])
        let conditionD_2 = CollectorWithSound(fileNames: ["ObserveTrees_4", "TreeCircle_5"], title: "Walk in Circle Around Tree C", dataLabel: "tree", sensors: [.Location])
        let conditionD_end = Sound(fileNames: ["End"])
        */
        
        /* USER STUDY CONDITIONS:
        * X - Interactive
        * Y - Noninteractive
        */
        
        let conditionX_1 = Sound(fileNames: ["Standing_3-20", "WalkObservingBody_1-16min", "WalkingBreathingShort_3"])
        let conditionX_2 = CollectorWithSound(fileNames: ["ObservingTrees_3-20min", "CircleFirstTree_2-48"], title: "Circle around tree X", dataLabel: "tree", sensors: [.Location, .Accel])
        let conditionX_3 = CollectorWithSound(fileNames: ["FindAnotherTree_1-05", "CircleNextTree_2-33"], title: "Circle around another X", dataLabel: "tree", sensors: [.Location, .Accel])
        let conditionX_end = Sound(fileNames: ["End_3-03"])
        
        let conditionY_1 = Sound(fileNames: ["Standing_3-20", "WalkObservingBody_1-16min", "WalkingBreathingLong_1-42", "WalkingPosture_5-37", "WalkingObserveSurroundings_4-00", "End_3-03"])
        
        
        let moment1 = Sound(fileNames: ["as_you_begin_to_walk_1-05", "as_you_walk_4-00", "continue_walking_naturally_3-00", "allow_your_awareness_2-30"])
       
        // Condition A (21 min) - Stand at tree
        let moment2a = CollectorWithSound(fileNames: ["once_you're_near_the_tree_4-20"], dataLabel: "tree", sensors: [.Location])
        
        // Condition B (21 min) - Walk back and forth in front of tree
        let moment2b = CollectorWithSound(fileNames: ["once_you're_near_the_tree_just_walk_4-05"], dataLabel: "tree", sensors: [.Location])

        let moment3 = Sound(fileNames: ["now_as_we_come_to_the_end_3-00"])

        
        var stages: [Stage] = []
        
        switch condition {
            case "A":
                let stage1 = Stage(moments: [moment1], title: "Beginning")
                let stage2 = Stage(moments: [moment2a], title: "Stand in front of tree")
                let stage3 = Stage(moments: [moment3], title: "End")
                stages = [stage1, stage2, stage3]
                experienceManager = ExperienceManager(title: "condition A", stages: stages)
                break
            case "B":
                let stage1 = Stage(moments: [moment1], title: "Beginning")
                let stage2 = Stage(moments: [moment2b], title: "Walk in front of tree")
                let stage3 = Stage(moments: [moment3], title: "End")
                stages = [stage1, stage2, stage3]
                experienceManager = ExperienceManager(title: "condition B", stages: stages)
                break
            case "C":
                let stage1 = Stage(moments: [conditionC_1], title: "Condition C 1")
                let stage2 = Stage(moments: [conditionC_2], title: "Condition C 2")
                let stage3 = Stage(moments: [conditionC_end], title: "Condition C 3")
                stages = [stage1, stage2, stage3]
                experienceManager = ExperienceManager(title: "condition C", stages: stages)
                break
            case "X":
                let stage1 = Stage(moments: [conditionX_1], title: "Condition X 1")
                let stage2 = Stage(moments: [conditionX_2], title: "Condition X 2")
                let stage3 = Stage(moments: [conditionX_3], title: "Condition X 3")
                let stage4 = Stage(moments: [conditionX_end], title: "Condition X 4")
                stages = [stage1, stage2, stage3, stage4]
                experienceManager = ExperienceManager(title: "condition X", stages: stages)
                break
            case "Y":
                let stage1 = Stage(moments: [conditionY_1], title: "Condition Y")
                stages = [stage1]
                experienceManager = ExperienceManager(title: "condition Y", stages: stages)
                break
            default:
                experienceManager = ExperienceManager(title: "no condition", stages: stages)
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
        if let navController = self.navigationController {
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