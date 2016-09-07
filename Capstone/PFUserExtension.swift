//
//  PFUserExtension.swift
//  Capstone
//
//  Created by MobileAge Team on 11/25/15.
//  Copyright © 2015 MobileAge Team. All rights reserved.
//

import Parse

extension PFUser {
    
    func isDriver() -> Bool {
        var driver = false
        PFUser.currentUser()!.fetchIfNeededInBackgroundWithBlock { (result, error) -> Void in
            driver = ((PFUser.currentUser()!.objectForKey("Driver") as? Bool) == nil) ? false : PFUser.currentUser()!.objectForKey("Driver") as! Bool
        }
        
        return driver
    }
    
    func getSearchDistance() -> Float {
        var distance: Float = 15.0
        PFUser.currentUser()!.fetchIfNeededInBackgroundWithBlock { (result, error) -> Void in
            distance = ((PFUser.currentUser()!.objectForKey("SearchDistance") as? Float) == nil) ? 15 : PFUser.currentUser()!.objectForKey("SearchDistance") as! Float
        }
        return distance
    }
    
    func setSearchDistance(searchDistance: Float) {
        PFUser.currentUser()!["SearchDistance"] = searchDistance
        PFUser.currentUser()?.saveEventually()
    }
}