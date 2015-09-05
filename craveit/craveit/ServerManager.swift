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
    
    // Sign Up User 
    func signUp(username: String, password: String, email: String, photoData: NSData) {
        var user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        
        let imageFile = PFFile(name: "placeholder.jpg", data: photoData)
        user.setObject(imageFile, forKey: "profilePicture")             
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                println("\(errorString)")
            } else {
                println("user saved to parse, can use app now")
            }
        }
    }
   
    
    
    //  When submit request button is pressed
    func sendRequestToServer(name: String, money: CGFloat, start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, user: PFUser) {
        let newRequest = PFObject(className: "Request")
        newRequest.setObject(name, forKey: "name")
        newRequest.setObject(money, forKey: "cost")
        newRequest.setObject(false, forKey: "isCompleted")
        
        // Setting craver
        newRequest.setObject(user, forKey: "craver")
        
        // Setting coordinates
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
    
    // Vicky check out https://parse.com/docs/ios/guide#queries.
    
    // Fetching all records  --> to show in marketplace --> Should show only those which are not marked completed
    func fetchAllRequests() -> [AnyObject]? {
        let query = PFQuery(className: "Request")
        query.whereKey("isCompleted", equalTo: false)
        let results = query.findObjects()
        return results
    }
    
    // To Do: 
    // Sort records (not sure if need to do during server fetch or do later when populating table)
    func fetchAllRequestsSortedByLocation() -> [AnyObject]? {
        let query = PFQuery(className: "Request")
        query.whereKey("isCompleted", equalTo: false)
        let results = query.findObjects()
        return results
    }
    
    // To populate admin dashboard 
    func fetchOnlyRequestsFromCurrentUser() -> [AnyObject]? {
        let query = PFQuery(className: "Request")
        query.whereKey("craver", equalTo: PFUser.currentUser()!)
        let results = query.findObjects()
        return results
    }
    

    
    
    
    
    
 
    

    
    
    
    // Helper functions
    func convertCLLocationToGeoPoint(location: CLLocationCoordinate2D) -> PFGeoPoint {
        return PFGeoPoint(latitude: location.latitude, longitude: location.longitude)
    }
    
    
}
