//
//  WalksListViewController.swift
//  ZenWalk
//
//  Created by Pamina Lin on 7/20/15.
//  Copyright (c) 2015 Scott Cambo. All rights reserved.
//

import Parse
import UIKit

class WalksListViewController: UIViewController/*, UITableViewDelegate, UITableViewDataSource */{

   
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var numWalks:Int = 0
    var walks:[NSDate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If there are no walks yet
        // Say so
        
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let username: String = defaults.stringForKey("username")!
        var query = PFQuery(className: "CompletedSession")
        query.whereKey("user", equalTo: username)
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if let error = error {
                print("Error: \(error.userInfo)")
                // Success

            } else if let objects = objects {
                    self.numWalks = objects.count
                    for obj in objects {
                        let date:NSDate = obj.valueForKey("createdAt") as! NSDate
                        print(self.getDateString(date))
                        self.walks.insert(obj.valueForKey("createdAt") as! NSDate, atIndex: 0)
                    }
            }
            
        }
        print(self.numWalks)
    }
    
    func getDateString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        
        return formatter.stringFromDate(date)
    }
    
    /*func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numWalks
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.textLabel?.text = "Hi"//self.walks[indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
