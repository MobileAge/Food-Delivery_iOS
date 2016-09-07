//
//  DriverOrder.swift
//  Capstone
//
//  Created by MobileAge Team on 12/15/15.
//  Copyright © 2015 MobileAge Team. All rights reserved.
//

import Foundation

//Similar to CustomerOrder with more fields added that are relevant to driver

class DriverOrder: NSObject {
    let orderName: String
    let orderNumber: String
    let pLocation: String
    let pName: String
    let dLocation: String
    var orderMessage: String
    var orderStatus: Int
    
    //var orderType: String
    
    /*
    Order Status Key:
    0: Order created - no driver assigned
    1: Driver has accepted order, but driver is not doing order
    2: Driver is now doing the order
    3: Order complete - pending delivery
    4: Order en route
    5: Order delivered / Complete
    */
    
    init(name: String, number: String, message: String, pickup: String, pName: String, deliver: String) {
        self.orderName = name
        self.orderNumber = number
        self.orderMessage = message
        self.pLocation = pickup
        self.pName = pName
        self.dLocation = deliver
        self.orderStatus = 0
    }
    
    func setStatus(status: Int){
        orderStatus = status
    }
}