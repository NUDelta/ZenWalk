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
        
        // Prompts user to give permissions now so it doesn't interrupt the experience later on
        CLLocationManager().requestAlwaysAuthorization()
        CMMotionActivityManager().stopActivityUpdates()
        
    
        
        // Create Moments

        /* DATA STUDY CONDITIONS:
        * Circle 4 trees
        */
        
        let condition_Data1 = CollectorWithSound(fileNames: ["FindLargeTree_1-23", "CircleLargeTree_3-01"], title: "Tree 1", dataLabel: "tree", sensors: [.Location])
        let condition_Data2 = CollectorWithSound(fileNames: ["FindAnotherLargeTree_1-00", "CircleAnotherLargeTree_2-40"], title: "Tree 2", dataLabel: "tree", sensors: [.Location])
        let condition_Data3 = CollectorWithSound(fileNames: ["FindAnotherLargeTree_1-00", "CircleAnotherLargeTree_2-40"], title: "Tree 3", dataLabel: "tree", sensors: [.Location])
        
        let condition_Data4 = Sound(fileNames: ["End_DataStudy"])
        
        
        var stages: [Stage] = []
        
        switch condition {
            case "data":
                let stage1 = Stage(moments: [condition_Data1], title: "Data Tree 1")
                let stage2 = Stage(moments: [condition_Data2], title: "Data Tree 2")
                let stage3 = Stage(moments: [condition_Data3], title: "Data Tree 3")
                let stage4 = Stage(moments: [condition_Data4], title: "Data Tree 4")
                stages = [stage1, stage2, stage3, stage4]
                experienceManager = ExperienceManager(title: "DataStudy", stages: stages)
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
    
    @IBAction func logoutButton(sender: UIBarButtonItem) {
        PFUser.logOut()
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController") as! SignUpInViewController
        self.showViewController(vc, sender: self)
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