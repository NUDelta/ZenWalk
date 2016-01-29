//
//  UserProfileViewController.swift
//  ZenWalk
//
//  Created by Pamina Lin on 7/21/15.
//  Copyright (c) 2015 Scott Cambo. All rights reserved.
//

import Parse
import UIKit

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let textCellIdentifier = "TextCell"
    var username:String = ""
    var walkHistoryArray:[String] = []
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var walksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.username = defaults.stringForKey("username")!
        usernameLabel.text = self.username

        walksTableView.delegate = self
        walksTableView.dataSource = self
        
        
    }
    
    
    @IBAction func logoutButton(sender: AnyObject) {
        PFUser.logOut()
        let storyboard:UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController") as! SignUpInViewController
        self.showViewController(vc, sender: self)
    }
    
    func getDateString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        
        return formatter.stringFromDate(date)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let walkHistoryArray:[String] = defaults.objectForKey("walkHistory") as! [String]
        return walkHistoryArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = walksTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        var walkHistoryArray:[String] = defaults.objectForKey("walkHistory") as! [String]
        let row = indexPath.row
        if walkHistoryArray.count == 0 {
            print("no walks yet")
            cell.textLabel?.text = "No walks yet!"
        } else {
            cell.textLabel?.text = walkHistoryArray[row]
        }
        
        return cell
    }

}
