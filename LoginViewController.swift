//
//  ViewController.swift
//  ZenWalkThoughts
//
//  Created by Pamina Lin on 7/6/15.
//  Copyright (c) 2015 Pamina Lin. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    var controller: UIAlertController?
    
    //@IBOutlet weak var sessionName: UITextField!
    
    @IBOutlet weak var loginInitialLabel: UILabel!
    @IBOutlet weak var loginUserTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var loginSavePasswordSwitch: UISwitch!
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let sessionKey = "session"
    
    /*override func viewDidAppear(animated: Bool) {
        var logInController = PFLogInViewController()
        logInController.delegate = self
        self.presentViewController(logInController, animated:true, completion: nil)
    }*/

    override func viewDidLoad() {
        //self.sessionName.delegate = self
        
        controller = UIAlertController(title: "Condition or Session not set",
            message: "Please set both the session and the condition before starting.",
            preferredStyle: .Alert)
        let action = UIAlertAction(
            title: "Done",
            style: UIAlertActionStyle.Default,
            handler: {(paramAction:UIAlertAction!) in println("Tried to start ZenWalk without session or condition")
        })
        controller!.addAction(action)
        
        //if defaults.stringForKey("session") != nil {
        //    self.sessionName.text = defaults.stringForKey("session")
        //}
        
    }
    
    
    
    @IBAction func nextButton(sender: UIButton) {
        /*if (self.sessionName.text == "") {
            self.presentViewController(self.controller!, animated: true, completion: nil)
        } else {
            defaults.setObject(self.sessionName.text, forKey: sessionKey)
        }*/
        if loginUserTextField.text != "" && loginPasswordTextField.text != "" {
            // not empty
            if loginSavePasswordSwitch.on {
                // User selected to save password
                PFUser.logInWithUsernameInBackground(loginUserTextField.text, password:loginPasswordTextField.text) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if user != nil {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.performSegueWithIdentifier("toCondition", sender: self)
                        }
                    } else {
                        self.loginInitialLabel.textColor = UIColor.redColor()
                        self.loginInitialLabel.text = "User not found"
                    }
                }
            } else {
                // User chose not to save password
            }
        } else {
            // Empty: prompt for login
            self.loginInitialLabel.textColor = UIColor.redColor()
            self.loginInitialLabel.text = "All Fields Required!"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toCondition" {
            var svc = segue.destinationViewController as! ConditionViewController
        }
    }


}

