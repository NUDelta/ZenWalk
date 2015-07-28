//
//  EndViewController.swift
//  ZenWalk
//
//  Created by Pamina Lin on 7/20/15.
//  Copyright (c) 2015 Scott Cambo. All rights reserved.
//

import Parse
import UIKit

class EndViewController: UIViewController {

    @IBOutlet weak var streakLabel: UILabel!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func homeButton(sender: UIBarButtonItem) {
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var vc = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        self.showViewController(vc, sender: self)
    }
    
    
    func calculateStreak() {
        let username:String = defaults.stringForKey("username")!
        var query = PFQuery(className: "Location")
        query.whereKey("user", equalTo: username)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // Found successfully
                println("found \(objects!.count) objects")
            } else {
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
