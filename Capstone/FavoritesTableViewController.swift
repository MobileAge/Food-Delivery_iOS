//
//  FavoritesTableViewController.swift
//  Capstone
//
//  Created by MobileAge Team on 12/15/15.
//  Copyright © 2015 MobileAge Team. All rights reserved.
//

import UIKit
import Parse

class FavoritesTableViewController: UITableViewController {
    
    var favoritePlaces:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritePlaces = PFUser.currentUser()!["FavoritePlaces"] as! [String]
        favoritePlaces.sortInPlace()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoritePlaces.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let place = favoritePlaces[indexPath.row]
        let data = place.componentsSeparatedByString("|||")
        let placeName = data[0]
        let placeAddress = data[1]
        
        cell.textLabel?.text = placeName
        cell.detailTextLabel?.text = placeAddress
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 203/255, green: 239/255, blue: 255/255, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            favoritePlaces.removeAtIndex(indexPath.row)
            PFUser.currentUser()!["FavoritePlaces"] = favoritePlaces
            PFUser.currentUser()!.saveInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo["error"] as? NSString
                    print(errorString)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "PlaceOrderFromFavoriteSegue") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                let custOrderViewController = segue.destinationViewController as! CustomerOrderViewController
                custOrderViewController.pickUpNameText = (cell?.textLabel?.text)!
                custOrderViewController.pickUpAddressText = (cell?.detailTextLabel?.text)!
            }
        }
    }

}
