//
//  HomeViewController.swift
//  ZenWalk
//
//  Created by Pamina Lin on 7/21/15.
//  Copyright (c) 2015 Scott Cambo. All rights reserved.
//

import Parse
import UIKit

class HomeViewController: UIViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var username:String = ""
    var walkHistoryArray:[String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Nav bar things
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // Check if no user is logged in
        if PFUser.currentUser() == nil || defaults.stringForKey("username") == nil {
            var storyboard:UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            var vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController") as! SignUpInViewController
            self.showViewController(vc, sender: self)
        }
        
        else {
            self.username = defaults.stringForKey("username")!
            
            // Set walk history array in user defaults
            var query = PFQuery(className: "CompletedSession")
            query.whereKey("user", equalTo: self.username)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    if let objects = objects as? [PFObject] {
                        for obj in objects {
                            let date:NSDate = obj.valueForKey("createdAt") as! NSDate
                            //println(self.getDateString(date))
                            self.walkHistoryArray.insert(self.getDateString(date), atIndex: 0)
                        }
                    }
                } else {
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }
        }
    }
    
    @IBAction func myAccountButton(sender: AnyObject) {
        // Set walk history array
        defaults.setObject(walkHistoryArray, forKey: "walkHistory")
        
        // Segue to user account view
        var storyboard: UIStoryboard = UIStoryboard(name: "UserInfo", bundle: nil)
        var vc = storyboard.instantiateViewControllerWithIdentifier("UserProfileViewController") as! UserProfileViewController
        vc.walkHistoryArray = defaults.objectForKey("walkHistory")! as! [String]
        self.showViewController(vc, sender: self)
    }
    
    @IBAction func startWalkingButton(sender: AnyObject) {
        // Segue to new walk (conditions) view
        var storyboard: UIStoryboard = UIStoryboard(name: "Walk", bundle: nil)
        var vc = storyboard.instantiateViewControllerWithIdentifier("ConditionViewController") as! ConditionViewController
        self.showViewController(vc, sender: self)
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        PFUser.logOut()
        var storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        var vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController") as! SignUpInViewController
        self.showViewController(vc, sender: self)
    }
    
    func getDateString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        
        return formatter.stringFromDate(date)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //lala
    }

    

}
