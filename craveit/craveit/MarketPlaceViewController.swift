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
//    var clock: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        marketPlaceTableView.delegate = self
        marketPlaceTableView.dataSource = self
       
//        self.clock = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "refreshListOfRequests", userInfo: nil, repeats: true)
        self.refreshListOfRequests()

        // Do any additional setup after loading the view.
        
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
        
        if cell.fromAddressLabel != nil {
            
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
                    cell.fromAddressLabel.text = lines.last
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
                    
                    cell.toAddressLabel.text = "\n".join(lines)
                }
            }
        }
        
//        let fee = item["cost"] as? CGFloat
//        cell.deliveryFeeLabel.text = "\(fee)"
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(tableDataSource.count)
        return tableDataSource.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        let row = indexPath.row
//        selectedRow = row
//        let item = matchingAddresses[row]
//        println(item)
//        destinationFormattedAddress = item
//        destinationLatitude = self.mapTasks.fetchedAddressLatitudeList[row]
//        // println("\(destinationLatitude)")
//        destinationLongitude = self.mapTasks.fetchedAddressLongitudeList[row]
        
    }
    
//    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
//        let geocoder = GMSGeocoder()
//        var isQueryDone = false
//        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
//            
//            //Add this line
//            if let _ = response {
//                if let address = response.firstResult() {
//                    let lines = address.lines as! [String]
//                    
//                    textAddress = "\n".join(lines)
//                    isQueryDone = true
//                }
//            }
//        }
//        if isQueryDone {
//            return textAddress
//        }
//        return textAddress
//    }
    
//    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) -> String {
//        var textAddress: String = ""
//        let geocoder = GMSGeocoder()
//        var isQueryDone = false
//        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
//            
//            //Add this line
//            if let _ = response {
//                if let address = response.firstResult() {
//                    let lines = address.lines as! [String]
//                    
//                    textAddress = "\n".join(lines)
//                    isQueryDone = true
//                }
//            }
//        }
//        if isQueryDone {
//            return textAddress
//        }
//        return textAddress
//    }

  
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
