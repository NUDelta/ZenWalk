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
        
        CLLocationManager().requestAlwaysAuthorization()
        
        // Create Moments
        let test = CollectorWithSound(fileNames: ["test1", "test2"], title: "Test", dataLabel: "test", sensors: [.Location])
        let test2 = CollectorWithSound(fileNames: ["test3", "test4"], title: "Test", dataLabel: "test", sensors: [.Location])

        
        let conditionA_1 = Sound(fileNames: ["Standing_1-16min", "WalkObservingBody_1-16min", "WalkingBreathingShort_3"])
        let conditionA_2 = CollectorWithSound(fileNames: ["ObservingTrees_3-20min", "TreeCircle_5"], title: "Circle around tree A", dataLabel: "tree", sensors: [.Location, .Accel])
        let conditionA_end = Sound(fileNames: ["End"])
        
        
        let conditionB_1 = Sound(fileNames: ["Standing_2min", "WalkingPosture1_2", "WalkingPosture2_2"])
        let conditionB_2 = CollectorWithSound(fileNames: ["ObserveTrees_4", "TreeSpin_5"], title: "Spin next to tree B", dataLabel: "tree", sensors: [.Location, .Accel])
        let conditionB_end = Sound(fileNames: ["End"])

        
        let conditionC_1 = Sound(fileNames: ["Standing_2min", "WalkingPosture1_2", "WalkingPosture2_2", "WalkingAwarenessofSurroundings_3"])
        let conditionC_2 = CollectorWithSound(fileNames: ["ObserveTrees_4", "TreeCircle_5"], title: "Walk in Circle Around Tree C", dataLabel: "tree", sensors: [.Location])
        let conditionC_end = Sound(fileNames: ["End"])

        /*
        let conditionD_1 = Sound(fileNames: ["Standing_1", "WalkingPosture1_2", "WalkingPosture2_2", "WalkingFeelings_3", "WalkingEmotion_3", "WalkingObjofConsciousness_3", "WalkingAwarenessofSurroundings_3"])
        let conditionD_2 = CollectorWithSound(fileNames: ["ObserveTrees_4", "TreeCircle_5"], title: "Walk in Circle Around Tree C", dataLabel: "tree", sensors: [.Location])
        let conditionD_end = Sound(fileNames: ["End"])
        */
        
        var stages: [Stage] = []
        
        switch condition {
            case "A":
                let stage1 = Stage(moments: [conditionA_1], title: "Condition A 1")
                let stage2 = Stage(moments: [conditionA_2], title: "Condition A 2")
                let stage3 = Stage(moments: [conditionA_end], title: "Condition A 3")
                stages = [stage1, stage2, stage3]
                experienceManager = ExperienceManager(title: "condition A", stages: stages)
                break
            case "B":
                let stage1 = Stage(moments: [conditionB_1], title: "Condition B 1")
                let stage2 = Stage(moments: [conditionB_2], title: "Condition B 2")
                let stage3 = Stage(moments: [conditionB_end], title: "Condition B 3")
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
            case "test":
                let stage1 = Stage(moments: [test], title: "Test Stage 1")
                let stage2 = Stage(moments: [test2], title: "Test Stage 2")
                stages = [stage1, stage2]
                experienceManager = ExperienceManager(title: "test", stages: stages)
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