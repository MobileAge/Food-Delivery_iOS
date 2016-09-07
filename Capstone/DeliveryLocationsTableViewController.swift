//
//  DeliveryLocationsTableViewController.swift
//  Capstone
//
//  Created by MobileAge Team on 11/6/15.
//  Copyright © 2015 MobileAge Team. All rights reserved.
//

import Parse

class DeliveryLocationsTableViewController: UITableViewController {
    
    var deliveryLocations = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        getDeliveryLocations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pullToRefreshActivated(sender: UIRefreshControl) {
        getDeliveryLocations()
        sender.endRefreshing();
    }
    
    
    func getDeliveryLocations() {
        let query = PFQuery(className:"DeliveryLocation")
        query.whereKey("User", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.deliveryLocations.removeAll()
                    for object in objects {
                        var instance = Dictionary<String, String>()
                        instance["Nickname"] = object["Nickname"] as? String
                        instance["Address"] = object["Address"] as? String
                        instance["City"] = object["City"] as? String
                        instance["State"] = object["State"] as? String
                        instance["ZipCode"] = object["ZipCode"] as? String
                        
                        self.deliveryLocations.append(instance)
                        self.tableView.reloadData()
                    }
                }
            } else {
            }
        }

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryLocations.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCellWithIdentifier("newDeliveryLocationCell", forIndexPath: indexPath)
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath)
            
            if indexPath.row % 2 == 1 {
                cell.backgroundColor = UIColor(red: 203/255, green: 239/255, blue: 255/255, alpha: 1.0)
            } else {
                cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            }
            
            if let object = deliveryLocations[indexPath.row - 1] as? Dictionary<String, String> {
                cell.textLabel?.text = object["Nickname"]
                let address = object["Address"]
                let city = object["City"]
                let state = object["State"]
                cell.detailTextLabel?.text = "\(address!) \(city!), \(state!)"
            }
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        if let object = deliveryLocations[indexPath.row - 1] as? Dictionary<String, String> {
            let address = object["Address"]!.stringByReplacingOccurrencesOfString(" ", withString: "+")
            let city = object["City"]!.stringByReplacingOccurrencesOfString(" ", withString: "+")
            let state = object["State"]!.stringByReplacingOccurrencesOfString(" ", withString: "+")
            let zipCode = object["ZipCode"]!.stringByReplacingOccurrencesOfString(" ", withString: "+")
            let search = "\(address)+\(city),+\(state)+\(zipCode)"
            
            if UIApplication.sharedApplication().canOpenURL(NSURL(string: "comgooglemaps://")!) {
                UIApplication.sharedApplication().openURL(NSURL(string: "comgooglemaps://?q=\(search)")!)
            } else {
                if UIApplication.sharedApplication().canOpenURL(NSURL(string: "maps://")!) {
                    UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/?q=\(search)")!)
                }
            }

        }
    }
    
}
