//
//  MainTabBarController.swift
//  Capstone
//
//  Created by MobileAge Team on 10/22/15.
//  Copyright © 2015 MobileAge Team. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ParseTwitterUtils
import ParseFacebookUtilsV4
import MMDrawerController

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func loginButtonClicked(sender: UIButton) {
        let username = self.usernameTextField.text
        let password = self.passwordTextField.text
        
        if username!.characters.count < 5 {
            let alert = UIAlertController(title: "Invalid", message: "Username must be at least 5 characters", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            presentViewController(alert, animated: true, completion: nil)
            
        } else if password!.characters.count < 8 {
            let alert = UIAlertController(title: "Invalid", message: "Password must be at least 8 characters", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            presentViewController(alert, animated: true, completion: nil)
            
        } else {
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in                
                if ((user) != nil) {                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.loadMainView()
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                    
                } else {
                    let alert = UIAlertController(title: "Error", message: "Incorrect username or password", preferredStyle: UIAlertControllerStyle.Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(defaultAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
    }

    @IBAction func loginWithFacebook(sender: UITapGestureRecognizer) {
        let permissions = ["public_profile"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.getUserDataFromFacebookProfile(user!)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.loadMainView()
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signupSegue" {
            let controller = segue.destinationViewController as! SignupViewController
            controller.username = self.usernameTextField.text
        }
    }

    
    func getUserDataFromFacebookProfile(user: PFUser) {
        var username  : String?
        var userEmail : String?

        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email, name"] )
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) == nil) {
                userEmail = result.valueForKey("email") as? String
                username = result.valueForKey("name") as? String
            }
            
            let thisUser: PFUser = user
            
            if let uName = username {
                thisUser.username = uName
            }
            
            if let uEmail = userEmail {
                thisUser.email = uEmail
            }
            thisUser.saveInBackground()
        })
    }

}