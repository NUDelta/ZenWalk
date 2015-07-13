//
//  ViewController.swift
//  ZenWalkThoughts
//
//  Created by Pamina Lin on 7/6/15.
//  Copyright (c) 2015 Pamina Lin. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController, UITextFieldDelegate {
    
    var controller: UIAlertController?
    
    @IBOutlet weak var sessionName: UITextField!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let sessionKey = "session"

    override func viewDidLoad() {
        self.sessionName.delegate = self
        
        controller = UIAlertController(title: "Condition or Session not set",
            message: "Please set both the session and the condition before starting.",
            preferredStyle: .Alert)
        let action = UIAlertAction(
            title: "Done",
            style: UIAlertActionStyle.Default,
            handler: {(paramAction:UIAlertAction!) in println("Tried to start ZenWalk without session or condition")
        })
        controller!.addAction(action)
        
        if defaults.stringForKey("session") != nil {
            self.sessionName.text = defaults.stringForKey("session")
        }
        
    }
    
    @IBAction func nextButton(sender: UIButton) {
        if (self.sessionName.text == "") {
            self.presentViewController(self.controller!, animated: true, completion: nil)
        } else {
            defaults.setObject(self.sessionName.text, forKey: sessionKey)
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


}

