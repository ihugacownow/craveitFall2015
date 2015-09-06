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
        AppDelegate.Location.requestObjectID.append(newRequest.objectId!)
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
    func fetchAllRequests() -> [PFObject]? {
        let query = PFQuery(className: "Request")
        query.whereKey("isCompleted", equalTo: false)
        let results = query.findObjects()
        
        return results as! [PFObject]?
    }
    
    // To Do: 
    // Sort records (not sure if need to do during server fetch or do later when populating table)
    func fetchAllRequestsSortedByLocation() -> [PFObject]? {
        let query = PFQuery(className: "Request")
        query.whereKey("isCompleted", equalTo: false)
        let results = query.findObjects()
        return results as! [PFObject]?
    }
    
    // To populate admin dashboard 
    func fetchOnlyRequestsFromCurrentUser() -> [AnyObject]? {
        let query = PFQuery(className: "Request")
        query.whereKey("craver", equalTo: PFUser.currentUser()!)
        
        //AppDelegate.Location.requestObjectID.append(<#newElement: T#>)
        let results = query.findObjects()
        return results
    }
    

    // Fetch Chat Messages 
//    func loadLocalChat(chats: [AnyObject], chatTable: UITableView) {
//        
//        var chatData = chats
//        let query = PFQuery(className: "Messages")
//        
//        query.orderByAscending("createdAt")
//        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
//            if error == nil {
//                chatData.removeAll(keepCapacity: false)
//                chatTable.reloadData()
//            } else {
//                println(error!.userInfo)
//            }
//        }
//       
//        query.orderByAscending("createdAt")
//        
//        var totalNumberOfEntries = 0
//        query.countObjectsInBackgroundWithBlock{ (numberOfEntries, error) -> Void in
//            if error == nil {
//                println("currently \(numberOf) entries")
//                totalNumberOfEntries = numb
//            } else {
//                println(error!.userInfo)
//            }
//        }
//
//        __block int totalNumberOfEntries = 0;
//        [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
//        if (!error) {
//        // The count request succeeded. Log the count
//        NSLog(@"There are currently %d entries", number);
//        totalNumberOfEntries = number;
//        if (totalNumberOfEntries > [chatData count]) {
//        NSLog(@"Retrieving data");
//        int theLimit;
//        if (totalNumberOfEntries-[chatData count]>MAX_ENTRIES_LOADED) {
//        theLimit = MAX_ENTRIES_LOADED;
//        }
//        else {
//        theLimit = totalNumberOfEntries-[chatData count];
//        }
//        query.limit = [NSNumber numberWithInt:theLimit];
//        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//        // The find succeeded.
//        NSLog(@"Successfully retrieved %d chats.", objects.count);
//        [chatData addObjectsFromArray:objects];
//        NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
//        for (int ind = 0; ind < objects.count; ind++) {
//        NSIndexPath *newPath = [NSIndexPath indexPathForRow:ind inSection:0];
//        [insertIndexPaths addObject:newPath];
//        }
//        [chatTable beginUpdates];
//        [chatTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
//        [chatTable endUpdates];
//        [chatTable reloadData];
//        [chatTable scrollsToTop];
//        } else {
//        // Log details of the failure
//        NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//        }];
//        }
//        
//        } else {
//        // The request failed, we'll keep the chatData count?
//        number = [chatData count];
//        }
//        }];
//    }
//    
//    
//    
//    
//    
 
    

    
    
    
    // Helper functions
    func convertCLLocationToGeoPoint(location: CLLocationCoordinate2D) -> PFGeoPoint {
        return PFGeoPoint(latitude: location.latitude, longitude: location.longitude)
    }
    
    
}
