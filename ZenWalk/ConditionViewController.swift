//
//  ConditionViewController.swift
//  ZenWalkThoughts
//
//  Created by Pamina Lin on 7/13/15.
//  Copyright (c) 2015 Pamina Lin. All rights reserved.
//

import Parse
import UIKit

class ConditionViewController: UIViewController {
    
    
    @IBOutlet weak var tenMinButton: UIButton!
    @IBOutlet weak var fifteenMinButton: UIButton!
    //@IBOutlet weak var twentyMinButton: UIButton!
    
    var meditationCondition: String = ""
    let defaults = NSUserDefaults.standardUserDefaults()
    var selectColor:UIColor = UIColor.lightGrayColor()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //twentyMinButton.hidden = true
        self.navigationController!.setNavigationBarHidden(false, animated:  true)
        self.navigationItem.setHidesBackButton(true, animated: false)
        tenMinButton.backgroundColor = selectColor
    }
    
    @IBAction func tenMinButton(sender: UIButton) {
        self.meditationCondition = "A"
        sender.backgroundColor = selectColor
        fifteenMinButton.backgroundColor = UIColor.whiteColor()
        //performSegueWithIdentifier("toMeditation", sender: self)
    }
    
    @IBAction func fifteenMinButton(sender: UIButton) {
        self.meditationCondition = "B"
        sender.backgroundColor = selectColor
        tenMinButton.backgroundColor = UIColor.whiteColor()
        //performSegueWithIdentifier("toMeditation", sender: self)
    }
    
    @IBAction func twentyMinButton(sender: UIButton) {
        self.meditationCondition = "C"
        //performSegueWithIdentifier("toMeditation", sender: self)
    }
    
    @IBAction func startButton(sender: UIButton) {
        // If no time was selected, alert
        if tenMinButton.backgroundColor != selectColor && fifteenMinButton.backgroundColor != selectColor {
            let alertController = UIAlertController(title: "Select an amount of time", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            performSegueWithIdentifier("toMeditation", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logoutButton(sender: UIBarButtonItem) {
        PFUser.logOut()
        performSegueWithIdentifier("toLogin", sender: self)
    }
   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMeditation" {
            var svc = segue.destinationViewController as! MeditationViewController
            svc.condition = self.meditationCondition
        }
        if segue.identifier == "toLogin" {
            var svc = segue.destinationViewController as! SignUpInViewController
        }
    }

}
