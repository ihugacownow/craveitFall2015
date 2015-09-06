//
//  RequestDashboardViewController.swift
//  craveit
//
//  Created by Akash Subramanian on 9/1/15.
//  Copyright (c) 2015 Akash Subramanian. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps

class RequestDashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableDataSource = [PFObject]()
    let serverMan = ServerManager()
    var clock: NSTimer?
    @IBOutlet weak var requestDashboardTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        requestDashboardTableView.delegate = self
        requestDashboardTableView.dataSource = self
        self.clock = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "refreshListOfRequests", userInfo: nil, repeats: true)
        self.refreshListOfRequests()

        
        
    }
    
    func refreshListOfRequests() {
        println("Calling lists from server")
        if serverMan.fetchOnlyRequestsFromCurrentUser() == nil {
            tableDataSource = [PFObject]()
        } else {
            tableDataSource = serverMan.fetchOnlyRequestsFromCurrentUser()!
            requestDashboardTableView.reloadData()
        }
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "requestCell", forIndexPath: indexPath) as! RequestsDashboardTableViewCell
        println("cell is \(cell)")
        
        
        // Configure the cell...
        cell.textLabel!.numberOfLines = 0
        
        if cell.deliverFromLabel != nil {
            
        } else {
            
        }
        
        let row = indexPath.row
        
        let item = tableDataSource[row]
        populateCell(cell, item: item)
        
        //cost, createdAt, craver, name, startPoint, endPoint
        //        cell.textLabel!.text = item
        //        let selectedView = UIView()
        //        selectedView.backgroundColor = UIColor(red: 241, green: 196, blue: 15)
        //        cell.selectedBackgroundView = selectedView
        println("AKJHDFKSJDHFKSJDFHSKJDF")
        if cell.toggleMarketPlaceEntrySwitch.on {
            println("cell \(row) is on")
            if let user = AppDelegate.Location.currentUser {
                var query = PFQuery(className: "Request")
                var object = query.getObjectWithId(tableDataSource[row].objectId!)
                 println(tableDataSource[row].objectId!)
                object!.setObject(false, forKey: "isCompleted")
                object!.saveInBackground()
            }
        } else {
             if let user = AppDelegate.Location.currentUser {
                var query = PFQuery(className: "Request")
                var object = query.getObjectWithId(tableDataSource[row].objectId!)
            println(tableDataSource[row].objectId!)
                
                object!.setObject(true, forKey: "isCompleted")
                object!.saveInBackground()
            }

        }
        
        
        return cell
        
        
    }
    
    func populateCell(cell: RequestsDashboardTableViewCell, item: PFObject) {
        let fromGeoPointObject = item["startPoint"] as! PFObject
        fromGeoPointObject.fetchIfNeeded()
        let fromGeoPoint = fromGeoPointObject["startLocation"] as! PFGeoPoint
        let fromPointCoordinates = CLLocationCoordinate2DMake(fromGeoPoint.latitude, fromGeoPoint.longitude)
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(fromPointCoordinates) { response , error in
            //Add this line
            if let _ = response {
                if let address = response.firstResult() {
                    let lines = address.lines as! [String]
                    cell.deliverFromLabel.text = "\n".join(lines)
                }
            }
        }
        
        let toGeoPointObject = item["endPoint"] as! PFObject
        toGeoPointObject.fetchIfNeeded()
        let toGeoPoint = toGeoPointObject["endPoint"] as! PFGeoPoint
        let toPointCoordinates = CLLocationCoordinate2DMake(toGeoPoint.latitude, toGeoPoint.longitude)
        geocoder.reverseGeocodeCoordinate(toPointCoordinates) { response , error in
            //Add this line
            if let _ = response {
                if let address = response.firstResult() {
                    let lines = address.lines as! [String]
                    
                    cell.deliverToLabel.text = "\n".join(lines)
                }
            }
        }
        
        }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(tableDataSource.count)
        return tableDataSource.count
    }

}
