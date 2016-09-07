//
//  DisputeCenterTableViewController.swift
//  Capstone
//
//  Created by MobileAge Team on 12/15/15.
//  Copyright © 2015 MobileAge Team. All rights reserved.
//

import UIKit
import Parse

class DisputeCenterTableViewController: UITableViewController {
    
    var disputeClaims = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        getDisputeClaims()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pullToRefreshActivated(sender: UIRefreshControl) {
        getDisputeClaims()
        sender.endRefreshing();
    }
    
    
    func getDisputeClaims() {
        let query = PFQuery(className:"DisputeClaims")
        query.whereKey("User", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.disputeClaims.removeAll()
                    for object in objects {
                        var instance = Dictionary<String, AnyObject>()
                        instance["Date"] = object["Date"] as? NSDate
                        instance["Status"] = object["Status"] as? String
                        
                        self.disputeClaims.append(instance)
                        self.tableView.reloadData()
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return disputeClaims.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCellWithIdentifier("newDisputeClaimCell", forIndexPath: indexPath)
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("disputeCell", forIndexPath: indexPath)
            
            if indexPath.row % 2 == 1 {
                cell.backgroundColor = UIColor(red: 203/255, green: 239/255, blue: 255/255, alpha: 1.0)
            } else {
                cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            }
            
            if let object = disputeClaims[indexPath.row - 1] as? Dictionary<String, AnyObject> {
                let date = object["Date"] as! NSDate
                let formatter = NSDateFormatter()
                formatter.dateFormat = "EEEE, MMMM d, yyyy"
                cell.textLabel?.text = formatter.stringFromDate(date)
                let status = object["Status"]!
                cell.detailTextLabel?.text = "Dispute Status: \(status)"
            }
            return cell
        }
    }
}