//
//  DisputeCenterSubmitViewController.swift
//  Capstone
//
//  Created by MobileAge Team on 12/15/15.
//  Copyright © 2015 MobileAge Team. All rights reserved.
//

import UIKit
import Parse

class DisputeCenterSubmitViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var disputeDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func saveDispute(sender: UIButton) {
        if disputeDescription.text == "" {
            let allFieldsRequiredAlert = UIAlertController(title: "Fields Required", message: "Dispute description cannot be left blank.", preferredStyle: .Alert)
            allFieldsRequiredAlert.addAction(UIAlertAction(title:"Ok", style: .Default, handler: nil))
            self.presentViewController(allFieldsRequiredAlert, animated: true, completion: nil)
            
            return
        }
        
        let disputeClaim = PFObject(className:"DisputeClaims")
        disputeClaim["User"] = PFUser.currentUser()
        disputeClaim["Date"] = datePicker.date
        disputeClaim["DisputeMessage"] = disputeDescription.text
        disputeClaim["Status"] = "Pending"
        disputeClaim.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                let didNotSaveAlert = UIAlertController(title: "Error Saving", message: "Something went wrong processing your dispute. Please try again.", preferredStyle: .Alert)
                didNotSaveAlert.addAction(UIAlertAction(title:"Ok", style: .Default, handler: nil))
                self.presentViewController(didNotSaveAlert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func dismissViewController(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}