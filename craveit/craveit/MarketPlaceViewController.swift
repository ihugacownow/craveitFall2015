//
//  MarketPlaceViewController.swift
//  craveit
//
//  Created by Akash Subramanian on 9/1/15.
//  Copyright (c) 2015 Akash Subramanian. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps

class MarketPlaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableDataSource = [PFObject]()
    var serverMan = AppDelegate.Location.ServerMan
    
    @IBOutlet weak var marketPlaceTableView: UITableView!
    // This is a hack 
    var clock: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        marketPlaceTableView.delegate = self
        marketPlaceTableView.dataSource = self
       
        self.clock = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "refreshListOfRequests", userInfo: nil, repeats: true)
        self.refreshListOfRequests()

        // Do any additional setup after loading the view.
        
//        println("tabledatasource is \(self.tableDataSource)")
    }


   
    func refreshListOfRequests() {
        println("Calling lists from server")
        if serverMan.fetchAllRequestsSortedByLocation() == nil {
            tableDataSource = [PFObject]()
        } else {
            tableDataSource = serverMan.fetchAllRequestsSortedByLocation()!
            marketPlaceTableView.reloadData()
        }
    }
    
// MARK -- TABLE VIEW METHOD AKASH
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "marketPlaceCell", forIndexPath: indexPath) as! MarketPlaceTableViewCell
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
        
        
        
        return cell
        
        
    }
    
    func populateCell(cell: MarketPlaceTableViewCell, item: PFObject) {
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
        
        let fee = item["cost"] as? CGFloat
        cell.feeLabel.text = "\(fee!)"
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(tableDataSource.count)
        return tableDataSource.count
    }
        
}
    
