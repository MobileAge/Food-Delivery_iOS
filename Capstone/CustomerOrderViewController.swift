//
//  CustomerOrderViewController.swift
//  Capstone
//
//  Created by MobileAge Team  on 10/22/15.
//  Copyright © 2015 MobileAge Team . All rights reserved.
//
import Foundation
import UIKit
import Parse

class CustomerOrderViewController:  UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let classNameKey: String = "Order"
    let numberNameKey: String = "OrderNumberClass"
    let orderNumberColumnKey: String = "orderNumber"
    let orderNameKey: String = "OrderHeader"
    let orderDescriptionKey: String = "OrderDescription"
    
    @IBOutlet weak var headerField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var adressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var zipField: UITextField!

    @IBOutlet weak var deliveryField: UITextField!
    @IBOutlet weak var pickUpNameField: UITextField!
    @IBOutlet weak var pickUpAddressField: UITextField!
    
    var pickUpNameText: String = ""
    var pickUpAddressText: String = ""
    
    var orderType: String = ""
 
    @IBOutlet weak var picker: UIPickerView!
    var pickerData: [String] = [String]()
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row == 0 {
            orderType = "Food/Fast Food"
        } else if row == 1 {
            orderType = "Restaurant"
        } else if row == 2 {
            orderType = "Grocery Store"
        } else if row == 3 {
            orderType = "Convenience Store"
        } else if row == 4 {
            orderType = "Liquor Store"
        }
        
        return pickerData[row]
    }
    
    func displayOrderFeedbackPrompt(){
        let simpleAlert = UIAlertController(title: "Ordered Succesfully Placed", message: "Your order has been succesfully placed and will now be viewable for drivers to accept. ", preferredStyle: .Alert)
        simpleAlert.addAction(UIAlertAction(title:"Ok", style: .Default, handler: nil))
        self.presentViewController(simpleAlert, animated: true, completion: nil)
    }
    
    func validOrder() -> Bool {
        
        if (headerField.text == "" || descriptionField.text == "" || pickUpNameField.text! == "" || pickUpAddressField.text! == "" || deliveryField.text! == ""){
            let simpleAlert = UIAlertController(title: "Order Save Error", message: "All fields are mandatory. ", preferredStyle: .Alert)
            simpleAlert.addAction(UIAlertAction(title:"Ok", style: .Default, handler: nil))
            self.presentViewController(simpleAlert, animated: true, completion: nil)
            return false;
        }
        return true
        
    }
    
    /**********************************
     * SAVES order into the database
     **********************************/
    var myDebugCounter: Int = 0
    @IBAction func orderCompleteButton(sender: AnyObject) {
        if !validOrder(){
            return
        }
        
        let oHead: String = headerField.text!
        let oDesc: String = descriptionField.text
        var orNum: String = ""

        let insertOrder = PFObject(className: classNameKey)
        insertOrder[orderNameKey] = oHead
        insertOrder[orderDescriptionKey] = oDesc
        insertOrder["orderType"] = orderType
        insertOrder["orderCreator"] = PFUser.currentUser()!.username
        insertOrder["pickUpName"] = pickUpNameField.text!
        insertOrder["pickUpAddress"] = pickUpAddressField.text!
        insertOrder["deliveryAddress"] = deliveryField.text!
        insertOrder["orderStatus"] = 0 //order created, not yet assigned

        do {
            try insertOrder.save()
            orNum = insertOrder.objectId!
            insertOrder["orderNumber"] = orNum
            
            do {
                try insertOrder.save()
            }
        }
        catch _ {
        }
        headerField.text = ""
        headerField.placeholder = "Order Title"
        descriptionField.text = "Enter order information here."
        
       // self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
       navigationController!.popViewControllerAnimated(true)
        
//        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {
//            let secondPresentingVC = self.presentingViewController?.presentingViewController;
//            secondPresentingVC?.dismissViewControllerAnimated(true, completion: {});
//        });
        
    }
    
    
    /**********************************
     *   textView.layer.cornerRadius = 5
     textView.layer.borderColor = UIColor.purpleColor().CGColor
     textView.layer.borderWidth = 1
     *
     **********************************/
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)

        self.picker.delegate = self
        self.picker.dataSource = self

        pickerData = ["Food/Fast Food", "Restaurant", "Grocery Store", "Convenience Store", "Liquor Store"]
        descriptionField.layer.borderColor = UIColor.purpleColor().CGColor
        descriptionField.layer.borderWidth = 1
        
        self.pickUpNameField.text = self.pickUpNameText
        self.pickUpAddressField.text = self.pickUpAddressText
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
}