//
//  SignUpInViewController.swift
//  ZenWalk
//
//  Created by Pamina Lin on 7/14/15.
//  Copyright (c) 2015 Scott Cambo. All rights reserved.
//


import Parse
import UIKit

class SignUpInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var loginSignupButton: UIButton!
    
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var rememberTextField: UILabel!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var loggingIn: Bool = true

    
    override func viewDidAppear(animated: Bool) {
        
        self.navigationController!.setNavigationBarHidden(true, animated:  true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rememberSwitch.hidden = true
        rememberTextField.hidden = true
        
        if (PFUser.currentUser() != nil) {
            self.performSegueWithIdentifier("toHome", sender: self)
        }
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        message.hidden = true
        passwordTextField.secureTextEntry = true
    
    }

    
    @IBAction func logInSignUpButton(sender: UIButton) {
        var userUsername = usernameTextField.text.lowercaseString
        var userPassword = passwordTextField.text
        
        // Start activity indicator
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        if loggingIn {
            PFUser.logInWithUsernameInBackground(userUsername, password:userPassword) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    self.activityIndicator.stopAnimating()
                    self.message.hidden = true
                    self.defaults.setObject(userUsername, forKey: "username")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.segueToHome()
                    }
                } else {
                    self.activityIndicator.stopAnimating()
                    if let message: AnyObject = error!.userInfo!["error"] {
                        self.message.hidden = false
                        self.message.textColor = UIColor.redColor()
                        self.message.text = "\(message)!"
                    }
                }
            }
        } else {
            // Create the user
            var user = PFUser()
            user.username = userUsername
            user.password = userPassword
            // user.email =
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if error == nil {
                    self.activityIndicator.stopAnimating()
                    self.message.hidden = true
                    self.defaults.setObject(userUsername, forKey: "username")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.segueToHome()
                    }
                } else {
                    self.activityIndicator.stopAnimating()
                    if let message: AnyObject = error!.userInfo!["error"] {
                        self.message.hidden = false
                        self.message.textColor = UIColor.redColor()
                        self.message.text = "\(message)!"
                    }
                }
            }
        }
    }
    
    func segueToHome() {
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var vc = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        self.showViewController(vc, sender: self)
    }

    @IBAction func toggleLogInSignIn(sender: UIButton) {
        if loggingIn {
            loggingIn = false
            loginSignupButton.setTitle("Sign Up", forState: UIControlState.Normal)
            sender.setTitle("Have an account already?  Log in!", forState: UIControlState.Normal)
            self.message.hidden = true
            self.activityIndicator.stopAnimating()
        } else {
            loggingIn = true
            loginSignupButton.setTitle("Log In", forState: UIControlState.Normal)
            sender.setTitle("No account?  Sign up for ZenWalk!", forState: UIControlState.Normal)
            self.message.hidden = true
            self.activityIndicator.stopAnimating()
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
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
