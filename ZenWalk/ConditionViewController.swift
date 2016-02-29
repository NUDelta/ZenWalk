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
    
    /*
        Testing Conditions
        Will show one of X or Y

    */
    
    
    var testCondition: String = "X"
    let defaults = NSUserDefaults.standardUserDefaults()
    var selectColor:UIColor = UIColor.lightGrayColor()
    @IBOutlet weak var testConditionLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(false, animated: false)
        
        // Get the user's test condition
        if let q = PFUser.query(), u = PFUser.currentUser(), username = u.username {
            q.whereKey("username", equalTo: username)
            q.findObjectsInBackgroundWithBlock({(objects, error) -> Void in
                if let objs = objects, user = objs.first as? PFUser,
                    firstVersionIsX = user["firstVersionIsX"] as? Bool,
                    completedX = user["completedX"] as? Bool,
                    completedY = user["completedY"] as? Bool {
                        if (firstVersionIsX && !completedX) || (!firstVersionIsX && completedY) {
                            self.testCondition = "X"
                        } else {
                            print("condition Y")
                            self.testCondition = "Y"
                        }
                } else {
                    print("User not found")
                }
                if self.testCondition == "X" {
                    print("label condition X")
                    self.testConditionLabel.text = "Condition X"
                }
                else if self.testCondition == "Y" {
                    print("label condition Y")
                    self.testConditionLabel.text = "Condition Y"
                }
            })
        }
    }
    
    
    
    @IBAction func startButton(sender: UIButton) {
        performSegueWithIdentifier("toWalk", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func logoutButton(sender: UIBarButtonItem) {
        PFUser.logOut()
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController") as! SignUpInViewController
        self.showViewController(vc, sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toWalk" {
            let svc = segue.destinationViewController as! WalkViewController
        
            svc.condition = self.testCondition
            //print("svc condition \(svc.condition)")
        }
    }

}
