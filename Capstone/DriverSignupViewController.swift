//
//  DriverSignupViewController.swift
//  Capstone
//
//  Created by MobileAge Team on 11/6/15.
//  Copyright © 2015 MobileAge Team. All rights reserved.
//

import Parse

class DriverSignupViewController: UIViewController {
    
    @IBOutlet weak var checkBox: UIImageView!

    var checked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func checkBoxClicked(sender: UITapGestureRecognizer) {
        if checked {
            checkBox.image = UIImage(named: "Unchecked Checkbox-100")
            checked = false
        } else {
            checkBox.image = UIImage(named: "Checked Checkbox 2-100")
            checked = true
        }
    }
    
    @IBAction func cancelClicked(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func submitClicked(sender: UIButton) {
        if checked {
            PFUser.currentUser()?.setValue(true, forKey: "Driver")
            PFUser.currentUser()?.saveEventually()
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            let checkBoxAlert = UIAlertController(title: "Terms and Conditions", message: "Please agree to the terms and conditions by selecting the checkbox", preferredStyle: .Alert)
            checkBoxAlert.addAction(UIAlertAction(title:"Ok", style: .Default, handler: nil))
            self.presentViewController(checkBoxAlert, animated: true, completion: nil)
        }
    }
    
}