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
        Conditions
        A: standing, walking (posture), observe trees, spin tree [21 min]
        B:
        C:

    */
    
    @IBOutlet weak var shortButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var longButton: UIButton!
    
    var meditationCondition: String = "A"
    let defaults = NSUserDefaults.standardUserDefaults()
    var selectColor:UIColor = UIColor.lightGrayColor()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(false, animated: false)
        shortButton.backgroundColor = selectColor
    }
    
    @IBAction func shortButton(sender: UIButton) {
        // 20 min
        self.meditationCondition = "A"
        chooseButton(sender, text: "20 min")
        resetMediumButton()
        resetLongButton()
    }
    
    @IBAction func mediumButton(sender: UIButton) {
        // 30 min
        self.meditationCondition = "B"
        chooseButton(sender, text: "30 min")
        resetShortButton()
        resetLongButton()
    }
    
    @IBAction func LongButton(sender: UIButton) {
        // 40 min
        self.meditationCondition = "C"
        chooseButton(sender, text: "40 min")
        resetShortButton()
        resetMediumButton()
    }
    
    
    func chooseButton(sender: UIButton, text: String) {
        sender.backgroundColor = selectColor
        sender.setTitle(text, forState: UIControlState.Normal)
    }
    
    
    func resetShortButton() {
        self.shortButton.backgroundColor = UIColor.whiteColor()
        self.shortButton.setTitle("20", forState: UIControlState.Normal)
    }
    
    func resetMediumButton() {
        self.mediumButton.backgroundColor = UIColor.whiteColor()
        self.mediumButton.setTitle("30", forState: UIControlState.Normal)
    }
    
    func resetLongButton() {
        self.longButton.backgroundColor = UIColor.whiteColor()
        self.longButton.setTitle("40", forState: UIControlState.Normal)
    }
    
    
    @IBAction func startButton(sender: UIButton) {
        // If no time was selected, alert
        /*if shortButton.backgroundColor != selectColor && mediumButton.backgroundColor != selectColor {
            let alertController = UIAlertController(title: "Select an amount of time", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {*/
        performSegueWithIdentifier("toMeditation", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logoutButton(sender: UIBarButtonItem) {
        PFUser.logOut()
        var storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        var vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController") as! SignUpInViewController
        self.showViewController(vc, sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMeditation" {
            var svc = segue.destinationViewController as! MeditationViewController
            svc.condition = self.meditationCondition
            //println("svc condition \(svc.condition)")
        }
    }

}
