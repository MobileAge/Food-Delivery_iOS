//
//  OrdersTableViewController.swift
//  Capstone
//
//  Created by MobileAge Team on 10/22/15.
//  Copyright © 2015 MobileAge Team . All rights reserved.
//


import UIKit
import Parse
import MMDrawerController

class OrdersTableViewController: UITableViewController {
    
    var count: Int = 0
    var detailViewController: OrdersDetailViewController? = nil
    var nextOrder: CustomerOrder = CustomerOrder(name: "TableTestHeader", number: "negative one", message: "TableTestMessage")
    var orderList = [CustomerOrder]()
    var refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        insertNewObject(self, index: 0)
        self.refreshControl = refreshController
        self.refreshControl?.addTarget(self, action: "didRefresh", forControlEvents: .ValueChanged)
        self.tableView.backgroundColor = UIColor.lightTextColor()
        //   getOrders()
        //        if let split = self.splitViewController {
        //            let controllers = split.viewControllers
        //            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? OrdersDetailViewController
        //        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        insertNewObject(self, index: 0)
        self.refreshControl = refreshController
        self.refreshControl?.addTarget(self, action: "didRefresh", forControlEvents: .ValueChanged)
        
        getOrders()
    }

    func didRefresh() {
        self.refreshControl?.beginRefreshing()
        orderList.removeAll()
        getOrders()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    func getOrders(){
        orderList.removeAll()
        
        let query = PFQuery(className: "Order")
        query.whereKeyExists("OrderHeader")
        query.whereKey("orderCreator", equalTo: PFUser.currentUser()!.username!)
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            if error == nil {
                let pfobjects = objects
                if objects != nil {
                    for object in pfobjects! {
                        let uOrder = object["OrderHeader"] as! String
                        let uDesc = object["OrderDescription"] as! String
                        let uNum: String = object["orderNumber"] as! String
                        self.orderList.append(CustomerOrder(name: uOrder, number: uNum, message: uDesc))
                        self.tableView.reloadData()
                    }
                }
                else {
                    
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count+1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
              
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("AddNewRowCell", forIndexPath: indexPath)
        } else {
            let cell2: OrdersTableCell
            cell2 = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! OrdersTableCell
            let object = orderList[indexPath.row-1]
            cell2.orderHeaderLabel.text = object.orderName
            
            if indexPath.row % 2 == 1 {
                cell2.backgroundColor = UIColor(red: 203/255, green: 239/255, blue: 255/255, alpha: 1.0)
            } else {
                cell2.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            }
    
//            var image1 = UIImage
//            
//            var imagename: String = getStatus(object.orderStatus)
//            
//            let image = UIImageAsset.setValue(image1, forKeyPath: imagename)
            
            cell2.orderStatusImage.image = UIImage(named: getStatus(object.orderStatus))
        //    cell2.orderNumberLabel.text = "Order Number: \(object.orderNumber)"
            return cell2
        }
        return cell
    }
    
    
    func getStatus(status: Int) -> String{
        
        if status == 0{
            return "orderstatus0.png"
        } else if status == 1{
            return "orderstatus1.png"
        } else if status == 2{
            return "orderstatus2.png"
        } else if status == 3{
            return "orderstatus3.png"
        } else if status == 4{
            return "orderstatus4.png"
        } else if status == 5{
            return "orderstatus5.png"
        }
        return "error"
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            orderList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func insertNewObject(sender: AnyObject, index: Int) {
        //   orderList.insert(, atIndex: 0)
        _ = (forRow: index, inSection: 0)
        //      self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    
    /**********************************
     *
     * Got rid of this for now . . .
     **********************************/
     //alert box method
     //    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
     //
     //        let alert = UIAlertController(title: "Order Information", message: "You have tapped accessory for\n The current status of your order is: + orderStatus (something to be completed)", preferredStyle: .Alert)
     //        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
     //        self.presentViewController(alert, animated: true, completion: nil)
     //
     //    }
     
     
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showOrderDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let object = orderList[indexPath.row-1]
                let controller = segue.destinationViewController as! OrdersDetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.orderHeader = object.orderName
                controller.orderDescription = object.orderMessage
                controller.orderNumber = object.orderNumber
                controller.oStatus = object.orderStatus
            }
        }
    }
    
    @IBAction func AddNewRow(sender: UIButton) {
        insertNewObject(self, index: 0)
    }
    
    @IBAction func drawerMenuClicked(sender: UIBarButtonItem) {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
}