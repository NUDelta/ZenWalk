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

        
        // 15 min
        let conditionA_1 = Sound(fileNames: ["Standing_1-16min", "WalkObservingBody_1-16min", "WalkingBreathingShort_3"])
        let conditionA_2 = CollectorWithSound(fileNames: ["ObservingTrees_3-20min", "TreeCircle_5"], title: "Circle around tree A", dataLabel: "tree", sensors: [.Location, .Accel])
        let conditionA_end = Sound(fileNames: ["End"])
        
        
        let conditionB_1 = Sound(fileNames: ["Standing_3-20", "WalkObservingBody_1-16min", "WalkingBreathingShort_3"])
        let conditionB_2 = CollectorWithSound(fileNames: ["ObservingTrees_3-20min", "CircleFirstTree_2-48"], title: "Circle around tree B", dataLabel: "tree", sensors: [.Location, .Accel])
        let conditionB_3 = CollectorWithSound(fileNames: ["FindAnotherTree_1-05", "CircleNextTree_2-33"], title: "Circle around another B", dataLabel: "tree", sensors: [.Location, .Accel])
        let conditionB_end = Sound(fileNames: ["End_3-03"])

        
        let conditionC_1 = Sound(fileNames: ["Standing_2min", "WalkingPosture1_2", "WalkingPosture2_2", "WalkingAwarenessofSurroundings_3"])
        let conditionC_2 = CollectorWithSound(fileNames: ["ObserveTrees_4", "TreeCircle_5"], title: "Walk in Circle Around Tree C", dataLabel: "tree", sensors: [.Location])
        let conditionC_end = Sound(fileNames: ["End"])

        
        /* USER STUDY CONDITIONS:
        * X - Interactive
        * Y - Noninteractive
        */
        
        let conditionX_1 = Sound(fileNames: ["Standing_3-20", "WalkObservingBody_1-16min", "WalkingBreathingShort_3"])
        let conditionX_2 = CollectorWithSound(fileNames: ["ObservingTrees_3-20min", "CircleFirstTree_2-48"], title: "Circle around tree X", dataLabel: "tree", sensors: [.Location, .Accel])
        let conditionX_3 = CollectorWithSound(fileNames: ["FindAnotherTree_1-05", "CircleNextTree_2-33"], title: "Circle around another X", dataLabel: "tree", sensors: [.Location, .Accel])
        let conditionX_end = Sound(fileNames: ["End_3-03"])
        
        let conditionY_1 = Sound(fileNames: ["Standing_3-20", "WalkObservingBody_1-16min", "WalkingBreathingLong_1-42", "WalkingPosture_5-37", "WalkingObserveSurroundings_4-00", "End_3-03"])
        
        var stages: [Stage] = []
        
        switch condition {
            case "X":
                let stage1 = Stage(moments: [conditionX_1], title: "Version X")
                let stage2 = Stage(moments: [conditionX_2], title: "Version X")
                let stage3 = Stage(moments: [conditionX_3], title: "Version X")
                let stage4 = Stage(moments: [conditionX_end], title: "Version X")
                stages = [stage1, stage2, stage3, stage4]
                experienceManager = ExperienceManager(title: "Version X", stages: stages)
                break
            case "Y":
                let stage1 = Stage(moments: [conditionY_1], title: "Version Y")
                stages = [stage1]
                experienceManager = ExperienceManager(title: "Version Y", stages: stages)
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
            // update the test condition information
            if let u = PFUser.currentUser() {
                if self.condition == "X" {
                    u["completedX"] = true
                }
                else if self.condition == "Y" {
                    u["completedY"] = true
                }
            }
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