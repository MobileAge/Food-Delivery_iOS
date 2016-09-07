//
//  PlaceMarker.swift
//  Capstone
//
//  Created by MobileAge Team on 11/5/15.
//  Copyright © 2015 MobileAge Team. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import GoogleMaps

class PlaceMarker: GMSMarker {

    let place: Place
    
    init(place: Place) {
        self.place = place
        super.init()
        
        position = place.coordinate
        groundAnchor = CGPoint(x: 0.5, y: 1)
    }
}