//
//  DriverTableViewCell.swift
//  Capstone
//
//  Created by MobileAge Team on 12/15/15.
//  Copyright © 2015 MobileAge Team. All rights reserved.
//

import UIKit
import Parse


class DriverTableViewCell : UITableViewCell {
    
    var isObserving = false

    @IBOutlet weak var orderTitle: UILabel!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var deliverLabel: UILabel!
    @IBOutlet weak var pLocation: UILabel!
    @IBOutlet weak var dLocation: UILabel!
    @IBOutlet weak var descripLabel: UILabel!
    @IBOutlet weak var oDescription: UITextView!
    @IBOutlet weak var pickUpName: UILabel!
    @IBOutlet weak var oStatus: UILabel!
    @IBOutlet weak var orderID: UILabel!
    @IBOutlet weak var oID: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    
    
    
    //Allows use of constants
    class var expandedHeight: CGFloat { get { return 200 } }
    class var defaultHeight: CGFloat  { get { return 44  } }
    
    func checkHeight() {
        let hide = (frame.size.height < DriverTableViewCell.expandedHeight)
        
        incrementButton.hidden = hide
        pickupLabel.hidden = hide
        deliverLabel.hidden = hide
        pLocation.hidden = hide
        dLocation.hidden = hide
        descripLabel.hidden = hide
        oDescription.hidden = hide
        oStatus.hidden = hide
        orderID.hidden = hide
        oID.hidden = hide
    }
    
    func watchFrameChanges() {
        if !isObserving {
            addObserver(self, forKeyPath: "frame", options: [NSKeyValueObservingOptions.New, NSKeyValueObservingOptions.Initial], context: nil)
            isObserving = true;
        }
    }
    
    func ignoreFrameChanges() {
        if isObserving {
            removeObserver(self, forKeyPath: "frame")
            isObserving = false;
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    
    
    @IBAction func updateStatus(sender: AnyObject) {
     
        updateOrderStatus(self.oID.text!)
    }
    
    
    @IBAction func acceptOrder(sender: AnyObject) {
        updateOrderStatus(self.oID.text!)
        
    }
    
    func updateOrderStatus(orderID: String) {
        let query = PFQuery(className: "Order")
        
        query.getObjectInBackgroundWithId(orderID){
            (accepted: PFObject?, error: NSError?) -> Void in
            if error != nil {
            } else if let accepted = accepted {
                accepted.incrementKey("orderStatus")
                let status = accepted["orderStatus"] as! Int
                accepted.saveInBackground()
                self.updateOrderLabel(status)
            }
        }
        
    }
    
    func updateOrderLabel(oStatus: Int) {
        let orderStatus = ["Accept", "Complete", "Deliver", "Dropped", "Done"]
        
        if oStatus > 4 {
            self.oStatus.text = "Done"
            return
        }
        
        self.oStatus.text = orderStatus[oStatus-1]
    }
    
}
