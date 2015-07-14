//
//  ConditionViewController.swift
//  ZenWalkThoughts
//
//  Created by Pamina Lin on 7/13/15.
//  Copyright (c) 2015 Pamina Lin. All rights reserved.
//

import UIKit

class ConditionViewController: UIViewController {
    
    var meditationCondition: String = ""
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMeditation" {
            var svc = segue.destinationViewController as! MeditationViewController
            svc.condition = self.meditationCondition
            
        }
    }

}
