//
//  ServerManager.swift
//  craveit
//
//  Created by Wu Wai Choong on 9/5/15.
//  Copyright (c) 2015 Akash Subramanian. All rights reserved.
//

import UIKit
import Parse

class ServerManager: NSObject {    
   
    //  When submit request button is pressed
    func sendRequestToServer(name: String, money: CGFloat, start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, user: User) {
        let newRequest = PFObject(className: "Request")
        newRequest.setObject(name, forKey: "name")
        newRequest.setObject(money, forKey: "cost")
        newRequest.setObject(user, forKey: "craver")
        
        let startGeopoint = PFObject(className: "StartPoint")
        startGeopoint.setObject(convertCLLocationToGeoPoint(start), forKey: "startLocation")
        let endGeopoint = PFObject(className: "EndPoint")
        endGeopoint.setObject(convertCLLocationToGeoPoint(end), forKey: "endPoint")
        newRequest.setObject(startGeopoint, forKey: "startPoint")
        newRequest.setObject(endGeopoint, forKey: "endPoint")
        
        newRequest.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                println("Object created with id: \(newRequest.objectId)")
            } else {
                println("\(error)")
            }

        }
      
    }
    
    // Fetching records 
    
    
    
    // Helper functions 
    func convertCLLocationToGeoPoint(location: CLLocationCoordinate2D) -> PFGeoPoint {
        return PFGeoPoint(latitude: location.latitude, longitude: location.longitude)
    }
    
    
}
