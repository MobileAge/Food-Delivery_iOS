//
//  SettingsViewController.swift
//  Capstone
//
//  Created by MobileAge Team on 10/22/15.
//  Copyright © 2015 MobileAge Team. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4
import MMDrawerController

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var searchDistanceSlider: UISlider!
    @IBOutlet weak var searchDistanceTxt: UILabel!
    @IBOutlet weak var driverSignupCell: UITableViewCell!
    
    var currentUser = PFUser.currentUser()
    var isDriver: Bool = false
    var searchDistance: Float = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        isDriver = currentUser!.isDriver()
        searchDistance = currentUser!.getSearchDistance()
        searchDistanceSlider.value = searchDistance
        
        let distance = String(format: "%.1f", searchDistance)
        searchDistanceTxt.text = "\(distance) mi."
        
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if super.tableView(tableView, cellForRowAtIndexPath: indexPath).reuseIdentifier == "DriverSignupCell" {
            if isDriver {
                return 0
            }
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    @IBAction func searchDistanceChanged(sender: UISlider) {
        let distance = String(format: "%.1f", sender.value)
        searchDistanceTxt.text = "\(distance) mi."
        PFUser.currentUser()!.setSearchDistance(sender.value)
    }
    
    @IBAction func logoutButtonClicked(sender: UIBarButtonItem) {
        PFUser.logOut()
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func drawerMenuClicked(sender: UIBarButtonItem) {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
}