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
        //CMMotionActivityManager(). // TODO somehow trigger motion fitness activity permissions before walk starts
        
        
        // 20 min
        let moment1 = Sound(fileNames: ["what_is_mindfulness_1-45", "body_and_posture_awareness_2-00", "allow_mind_to_be_free_2-30"])
       
        
        // Condition A (~15 min) - stand or walk around tree for as long as you want
        //let moment2a = CollectorWithSound(fileNames: ["focus_on_environment_3-00"], dataLabel: "tree", sensors: [.Location])
        // TODO should be able to detect "staying still" next to a tree and then trigger the next moment based on that
        
        // if user is stationary, play tree guidance.  otherwise, play alternative instructions
        let moment2a = Sound(fileNames: ["walk_up_to_tree_0-50"])
        let moment2b_false = CollectorWithSound(fileNames: ["near_the_tree_2-00"], dataLabel: "tree", sensors: [.Location])
        let moment2b_true = CollectorWithSound(fileNames: ["if_you_don't_see_a_tree_0-25", "reminder_walk_up_to_tree_0-20", "near_the_tree_2-00"], dataLabel: "tree", sensors: [.Location])
        let moment2b = ConditionalMoment(moment_true: moment2b_true, moment_false: moment2b_false, conditionFunc: userIsNotStationary)
    
        
        /*
         let moment2c_false = CollectorWithSound(fileNames: ["near_the_tree_2-00"], dataLabel: "tree", sensors: [.Location])
        let moment2c_true = Sound(fileNames: ["keep_breathing_0-25"])
        let moment2c = ConditionalMoment(moment_true: moment2c_true, moment_false: moment2c_false, conditionFunc: userIsNotStationary)
        */
        /*
            I think we need to be able to branch on more than one moment (like branch at the momentblock level)
        */
        
        //let moment2_wait = ContinuousMoment(title: "Wait for standing", conditionFunc: userIsNotStationary)
        //let moment2b = CollectorWithSound(fileNames: ["near_the_tree_2-00"], dataLabel: "tree", sensors: [.Location])
        let moment2c_func = FunctionMoment(execFunc: {()-> Void in self.experienceManager.saveCurrentContext() })
        let moment2c = ContinuousMoment(title: "Walk Away from Tree", conditionFunc: movedAway)
        let moment2d = Sound(fileNames: ["walk_away_from_tree_0-45"])
        let moment2e = ContinuousMoment(title: "Wait for standing", conditionFunc: userIsNotStationary)
        let moment2f = CollectorWithSound(fileNames: ["as_before_observe_tree_1-10"], dataLabel: "tree", sensors: [.Location])
        let moment3 = Sound(fileNames: ["reflect_3-20"])
        
        // Testing condition
        let moment_test1 = Sound(fileNames: ["test_cat"])
        let moment_test1b = FunctionMoment(execFunc: {()-> Void in self.experienceManager.saveCurrentContext() })
        let moment_test2 = ContinuousMoment(title: "Wait for standing", conditionFunc: userIsNotStationary)
        let moment_test3 = Sound(fileNames: ["test_banjo"])

        
        var stages: [MomentBlock] = []
        
        switch condition {
            case "A":
                let stage1 = MomentBlock(moments: [moment1], title: "Introduction")
                let stage2 = MomentBlock(moments: [moment2a], title: "Walk to Tree")
                let stage3 = MomentBlock(moments: [moment2b], title: "Stand in front of tree")
                let stage4 = MomentBlock(moments: [moment2c_func, moment2c], title: "Interim at tree")
                let stage5 = MomentBlock(moments: [moment2d, moment2e, moment2f], title: "Stand in front of second tree")
                let stage6 = MomentBlock(moments: [moment3], title: "End")
                stages = [stage1, stage2, stage3, stage4, stage5, stage6]
                experienceManager = ExperienceManager(title: "condition A", momentBlocks: stages)
                break
            case "test":
                //let stage_test = MomentBlock(moments: [moment_test1, moment_test1b, moment_test2, moment_test3], title: "test")
                //let stage1 = MomentBlock(moments: [moment1], title: "Introduction")
                let stage2 = MomentBlock(moments: [moment2a], title: "Walk to Tree")
                let stage3 = MomentBlock(moments: [moment2b], title: "Stand in front of tree")
                let stage4 = MomentBlock(moments: [moment2c_func, moment2c], title: "Interim at tree")
                //let stage5 = MomentBlock(moments: [moment2d, moment2e, moment2f], title: "Stand in front of second tree")
                //let stage6 = MomentBlock(moments: [moment3], title: "End")
                stages = [stage2, stage3, stage4]
                experienceManager = ExperienceManager(title: "test", momentBlocks: stages)
                break
            default:
                experienceManager = ExperienceManager(title: "no condition", momentBlocks: stages)
                break
        }
        
        //SCAFFOLDING MANAGER
        var scaffoldingManager = ScaffoldingManager(
            experienceManager: experienceManager)
        
        let momentblock_hydrant = MomentBlockSimple(moments: [
            //instruction
            SynthVoiceMoment(content: "there is a a fire hydrant 3 meters ahead"),
            ], title: "scaffold_fire_hydrant",
               requirement: Requirement(conditions:[Condition.InRegion, Condition.ExistsObject],
                objectLabel: "fire_hydrant"))
        let momentblock_tree = MomentBlockSimple(moments: [
            //instruction
            SynthVoiceMoment(content: "there is a a tree within 3 second walking distance. if you feel comfortable, walk to it and stand for 10 seconds. if you would rather not, continue your path"),
            //wait for person to make decisive action
            Interim(lengthInSeconds: 2),
            //branch: stationary, then push location, if not
            ConditionalMoment(
                moment_true: SynthVoiceMoment(content: "detected stop - tree recorded"),
                moment_false: SynthVoiceMoment(content: "you're moving - no tree I see"),
                conditionFunc: {() -> Bool in
                    if let speed = self.experienceManager.dataManager?.currentLocation?.speed
                        //true condition: user is stationary
                        where speed <= 1.2 {
                        let curEvaluatingObject = scaffoldingManager.curPulledObject!
                        self.experienceManager.dataManager?.updateWorldObject(curEvaluatingObject, information: [], validated: true)
                        return true
                    }
                    //false condition: user keeps moving
                    let curEvaluatingObject = scaffoldingManager.curPulledObject!
                    self.experienceManager.dataManager?.updateWorldObject(curEvaluatingObject, information: [], validated: false)
                    return false
            }),
            SynthVoiceMoment(content: "good job - now move on"),
            ], title: "scaffold_tree",
               requirement: Requirement(conditions:[Condition.InRegion, Condition.ExistsObject],
                objectLabel: "tree"))
        
        
        //[scaffolding: variation]
        let momentblock_tree_var0 = MomentBlockSimple(moments: [
            //instruction
            SynthVoiceMoment(content: "there is a a tree 3 meters ahead. does it have green leaves?"),
            ConditionalMoment(
                moment_true: SynthVoiceMoment(content: "detected stop - green leaves recorded"),
                moment_false: SynthVoiceMoment(content: "you're moving - no green leaves I see"),
                conditionFunc: {() -> Bool in
                    if let speed = self.experienceManager.dataManager?.currentLocation?.speed
                        //true condition: user is stationary
                        where speed <= 1.2 {
                        self.experienceManager.dataManager?.pushWorldObject(["label": "tree_leaves_green", "interaction" : "scaffold_tree_leaves_green", "variation" : "1"])
                        return true
                    }
                    //false condition: user keeps moving
                    self.experienceManager.dataManager?.pushWorldObject(["label": "tree_leaves_green(false)", "interaction" : "scaffold_tree_leaves_green", "variation" : "1"])
                    return false
            }),
            SynthVoiceMoment(content: "good job - now move on"),
            ], title: "scaffold_tree_var0",
               requirement: Requirement(conditions:[Condition.InRegion, Condition.ExistsObject],
                objectLabel: "tree", variationNumber: 0))
        
        scaffoldingManager.insertableMomentBlocks = [momentblock_hydrant, momentblock_tree, momentblock_tree_var0]
        
        //SET DELEGATES
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
        let startingLocation = experienceManager.getCurrentSavedContext()!.location!;
        
        // While user is within 15 meters of the initial location, return true
        let loc_start = MKMapPointForCoordinate(startingLocation)
        let loc_cur = MKMapPointForCoordinate(experienceManager.currentContext.location!)
        
        let dist = MKMetersBetweenMapPoints(loc_start, loc_cur)
        print (dist)
        return (dist <= 15)
    }
    
    func userIsNotStationary() -> Bool {
        if let loc = experienceManager.dataManager!.locationManager.location {
            let speed = loc.speed
            if (speed < 1.0) {
                // Tree condition
                self.experienceManager.dataManager?.pushWorldObject(["label": "tree", "interaction" : "tree_circle", "variation" : "0"])
                return false
            }
        }
        // No tree condition
        self.experienceManager.dataManager?.pushWorldObject(["label": "tree[false]", "interaction" : "tree_circle", "variation" : "0"])
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