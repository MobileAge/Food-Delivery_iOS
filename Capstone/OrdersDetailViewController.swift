//
//  OrdersDetailViewController.swift
//  Capstone
//
//  Created by MobileAge Team on 10/22/15.
//  Copyright © 2015 MobileAge Team. All rights reserved.
//
import UIKit
import Parse

class OrdersDetailViewController: UIViewController {
    
    var orderHeader: String = "detailTestHeader"
    var orderNumber: String = "negative 10"
    var orderDescription: String = "detailTestDescription"
    var orderStatus: String = "negative 0"
    var oStatus: Int = -1
    var detailItem: AnyObject? {
        didSet {
            self.configureView()
        }
    }
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!

    func configureView() {
        //        if let detail = self.detailItem as! NSArray? {
        //
        //        }
    }
    
    func statusMessage(status: Int) -> String {
        if status == 0 {
            orderStatus = "Order created - no driver."
        } else if status == 1 {
            orderStatus = "Order accepted by driver."
        } else if status == 2 {
            orderStatus = "Order in progress by driver."
        } else if status == 3 {
            orderStatus = "Order completed by driver."
        } else if status == 4 {
            orderStatus = "Order en route to location."
        } else if status == 5 {
            orderStatus = "Order Completed"
        }
        return orderStatus
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        
        if orderHeader != ""{
            headerLabel.text = orderHeader
            numberLabel.text = "\(orderNumber)"
            descriptionLabel.text = orderDescription
            statusLabel.text = statusMessage(oStatus)
        }
    }
    
    @IBAction func deleteOrderPressed(sender: AnyObject) {
        let alert = UIAlertController(title: "Deleter Order", message: "Are you sure you want to delete your order? This can only be done if your order has not been accepted by a driver.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (alertAction: UIAlertAction!) -> Void in
            
            let alert2 = UIAlertController(title: "Deleter Order", message: "Are you sure you want to delete this order?", preferredStyle:  .Alert)
            alert2.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (alertAction: UIAlertAction!) -> Void in
                
                let query = PFQuery(className: "Order")
                query.whereKey("orderNumber", containsString: self.numberLabel.text)
                query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
                    if error == nil {
                        let pfobjects = objects
                        if objects != nil {
                            for object in pfobjects! {
                                object.deleteInBackground()
                                self.headerLabel.text = "Order Deleted"
                                self.numberLabel.text = "Order Deleted"
                                self.descriptionLabel.text = "Order Deleted"
                            }
                        }
                    }
                }
            }))

            alert2.addAction(UIAlertAction(title: "No", style: .Default, handler: { (alertAction: UIAlertAction!) -> Void in
                //dont do anything
            }))
            
            self.presentViewController(alert2, animated: true) { () -> Void in
                
            }

            }))
            
            
            
            alert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (alertAction: UIAlertAction!) -> Void in
                //dont do anything
            }))
            
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (alertAction: UIAlertAction!) -> Void in
                //still dont do anything
            }))
        
            //necessary for alert box to show
            self.presentViewController(alert, animated: true) { () -> Void in
                
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}