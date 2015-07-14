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
    
    var meditationCondition: String = ""
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(false, animated:  true)
    }
    
    @IBAction func tenMinButton(sender: UIButton) {
        self.meditationCondition = "A"
        performSegueWithIdentifier("toMeditation", sender: self)
    }
    
    @IBAction func fifteenMinButton(sender: UIButton) {
        self.meditationCondition = "B"
        performSegueWithIdentifier("toMeditation", sender: self)
    }
    
    @IBAction func twentyMinButton(sender: UIButton) {
        self.meditationCondition = "C"
        performSegueWithIdentifier("toMeditation", sender: self)
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
