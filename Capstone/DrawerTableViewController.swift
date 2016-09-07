//
//  DrawerTableViewController.swift
//  Capstone
//
//  Created by MobileAge Team on 10/29/15.
//  Copyright © 2015 MobileAge Team. All rights reserved.
//

import UIKit
import MMDrawerController
import Parse

class DrawerTableViewController: UITableViewController {
    
    var labels = ["Home", "Orders", "Settings", "Logout"]
    var isDriver: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(animated: Bool) {
        self.isDriver = (PFUser.currentUser()?.isDriver())!
        self.title = PFUser.currentUser()?.username
        
        if isDriver {
            labels = ["Home", "Orders", "Driver", "Settings", "Logout"]
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DrawerCell", forIndexPath: indexPath)
    
        cell.textLabel?.text = labels[indexPath.row]

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row) {
        case 0:
            let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
            let homeNavController = UINavigationController(rootViewController: homeViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController = homeNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
        case 1:
            let ordersTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("OrdersTableViewController") as! OrdersTableViewController
            let ordersTableNavController = UINavigationController(rootViewController: ordersTableViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController = ordersTableNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
        case 2 where isDriver:
            let driverViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DriverViewController") as! DriverViewController
            let driverNavController = UINavigationController(rootViewController: driverViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
            appDelegate.centerContainer!.centerViewController = driverNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
        case 2 where !isDriver: fallthrough
        case 3 where isDriver:
            let settingsTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsTableViewController") as! SettingsTableViewController
            let settingsNavController = UINavigationController(rootViewController: settingsTableViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController = settingsNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
        case 3 where !isDriver: fallthrough
        case 4:
            PFUser.logOut()
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
            self.presentViewController(viewController, animated: true, completion: nil)
            
        default: break
        }
    }

}
