//
//  DriverViewController.swift
//  Capstone
//
//  Created by MobileAge Team on 11/9/15.
//  Copyright © 2015 MobileAge Team. All rights reserved.
//

import UIKit
import Parse

class AcceptedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var orderStatus = -1
    var selectedIndexPath: NSIndexPath?
    var requests = [DriverOrder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.clearColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        getOrders()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DriverTableViewCell
        let item = requests[indexPath.row]
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 203/255, green: 239/255, blue: 255/255, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        }
        
        cell.orderTitle.text = item.orderName
        cell.pickUpName.text = item.pName
        cell.pLocation.text = item.pLocation
        cell.dLocation.text = item.dLocation
        cell.oDescription.text = item.orderMessage
        cell.oID.text = item.orderNumber
        cell.updateOrderLabel(orderStatus)
        return cell
    }
    
    //Controls cell expansion
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths : Array<NSIndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! DriverTableViewCell).watchFrameChanges()
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! DriverTableViewCell).ignoreFrameChanges()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in tableView.visibleCells as! [DriverTableViewCell] {
            cell.ignoreFrameChanges()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return DriverTableViewCell.expandedHeight
        } else {
            return DriverTableViewCell.defaultHeight
        }
    }
    
    //Allows for slide left gesture to display buttons
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let accept = UITableViewRowAction(style: .Normal, title: "Update") { action, index in
            let row = indexPath.row
            let item = self.requests[row]
            self.updateStatus(item)
        }
        accept.backgroundColor = UIColor.greenColor()
        
        let deny = UITableViewRowAction(style: .Normal, title: "Deny") { action, index in
            let row = indexPath.row
            let item = self.requests[row]
            self.orderRemoved(item)
        }
        deny.backgroundColor = UIColor.redColor()
        
        return [deny, accept]
    }

    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func getOrders(){
        requests.removeAll()
        
        let query = PFQuery(className: "Order")
        query.whereKeyExists("OrderHeader")
        
        //Only get orders which haven't been accepted
        query.whereKey("orderStatus", notEqualTo: 0)
        
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            if error == nil {
                let pfobjects = objects
                if objects != nil {
                    for object in pfobjects! {
                        
                        let uOrder = object["OrderHeader"] as! String
                        let uDesc = object["OrderDescription"] as! String
                        let uNum: String = object["orderNumber"] as! String
                        let uPickup: String = object["pickUpAddress"] as! String
                        let pName: String = object["pickUpName"] as! String
                        
                        let uDeliv: String = object["deliveryAddress"] as! String
                        self.orderStatus = object["orderStatus"] as! Int
                        self.requests.append(DriverOrder(name: uOrder, number: uNum, message: uDesc, pickup: uPickup, pName: pName, deliver: uDeliv))
                        self.tableView.reloadData()
                    }
                }
                else {
                } }
        }
    }
    
    
    func orderRemoved(order: DriverOrder) {
        let index = (requests as NSArray).indexOfObject(order)
        if index == NSNotFound { return }
        
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        requests.removeAtIndex(index)
        
        // use the UITableView to animate the removal of this row
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        tableView.endUpdates()
    }
    
    func updateStatus(order: DriverOrder) {
        let index = (requests as NSArray).indexOfObject(order)
        if index == NSNotFound { return }
        
        let orderID = requests[index].orderNumber
        let query = PFQuery(className: "Order")
        
        query.getObjectInBackgroundWithId(orderID){
            (accepted: PFObject?, error: NSError?) -> Void in
            if error != nil {
            } else if let accepted = accepted {
                accepted.incrementKey("orderStatus")
                self.orderStatus++
                accepted.saveInBackground()
            }
        }
    }
    
}
