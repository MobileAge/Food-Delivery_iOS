//
//  GoogleRequest.swift
//  Capstone
//
//  Created by MobileAge Team on 11/5/15.
//  Copyright © 2015 MobileAge Team. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class GoogleRequest {
    
    var objects = [AnyObject]()
    
    func loadPlaces(coordinate: CLLocationCoordinate2D, searchDist: Int, searchStr: String, typeStr: String, completion: (([Place]) -> Void)) -> ()
    {
        
        // Get ready to fetch the list of dog videos from YouTube V3 Data API
        var url = NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=500&types=\(typeStr)&name=\(searchStr)&key=AIzaSyD6A3UC612PRvsyUIk_t5odUkVZveXjO0w")
        if(searchStr == "" && typeStr != ""){
            url = NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=500&types=\(typeStr)&key=AIzaSyD6A3UC612PRvsyUIk_t5odUkVZveXjO0w")
        }else if(searchStr != "" && typeStr == ""){
            url = NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=500&name=\(searchStr)&key=AIzaSyD6A3UC612PRvsyUIk_t5odUkVZveXjO0w")
        }
        
        print("REQUEST: \(url)")
        
        let session = NSURLSession.sharedSession()
        let task = session.downloadTaskWithURL(url!) {
            (loc:NSURL?, response:NSURLResponse?, error:NSError?) in
            if error != nil {
                return
            }
            
            // Parse the top level  JSON object.
            let parsedObject: AnyObject?
            let d = NSData(contentsOfURL: loc!)!
            do {
                parsedObject = try NSJSONSerialization.JSONObjectWithData(d,
                    options: NSJSONReadingOptions.AllowFragments)
            } catch _ as NSError {
                return
            } catch {
                fatalError()
            }
            
            // retrieve the individual places from the JSON document.
            if let topLevelObj = parsedObject as? Dictionary<String,AnyObject> {
                if let results = topLevelObj["results"] as? Array<Dictionary<String,AnyObject>> {
                    for i in results {
                        self.objects.append(i)
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        (UIApplication.sharedApplication().delegate as! AppDelegate).decrementNetworkActivity()
                        //self.tableView.reloadData()
                        
                    }
                }
            }
            
            var placesArray = [Place]()
            for var i = 0; i < self.objects.count; ++i {
                let place = Place(result: self.objects[i])
                placesArray.append(place)
            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(placesArray)
            }
        }
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).incrementNetworkActivity()
        task.resume()
    }
    
}
