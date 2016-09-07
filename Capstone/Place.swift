//
//  Place.swift
//  Capstone
//
//  Created by MobileAge Team on 11/5/15.
//  Copyright © 2015 MobileAge Team. All rights reserved.
//

import UIKit

class Place{
    var name: String = ""
    var address: String = ""
    var placeid: String = ""
    var open: Bool = false
    var iconURL: String = ""
    var icon: UIImage = UIImage()
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var lat: Double = 0
    var lng: Double = 0
    
    init(result: AnyObject?){
        if let object = result as? Dictionary<String, AnyObject> {
            
            address = (object["vicinity"] as? String)!
            
            print(address)
            name = (object["name"] as? String)!
            placeid = (object["place_id"] as? String)!
            iconURL = (object["icon"] as? String)!
            
            if let url = NSURL(string: iconURL) {
                let request = NSURLRequest(URL: url)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                    (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                    if let imageData = data as NSData? {
                        self.icon = UIImage(data: imageData)!
                    }
                }
            }
            
            if let openHrs = object["opening_hours"] as? Dictionary<String, AnyObject> {
                open = (openHrs["open_now"] as? Bool)!
            }
            if let geo = object["geometry"] as? Dictionary<String, AnyObject> {
                if let loc = geo["location"] as? Dictionary<String, AnyObject> {
                    lat = (loc["lat"] as? Double)!
                    lng = (loc["lng"] as? Double)!
                    coordinate = CLLocationCoordinate2DMake(lat, lng)
                    
                }
            }
        }
    }
    
}
