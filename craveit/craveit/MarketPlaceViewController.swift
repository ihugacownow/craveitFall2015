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

class MarketPlaceViewController: UIViewController, UITableViewDelegate {
    
    var tableDataSource = [PFObject]()
    var serverMan = AppDelegate.Location.ServerMan
    
    @IBOutlet weak var marketPlaceTableView: UITableView!
    // This is a hack 
    var clock: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        marketPlaceTableView.delegate = self
       
        self.clock = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "refreshListOfRequests", userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
        
    }


   
    func refreshListOfRequests() {
        println("Calling lists from server")
        if serverMan.fetchAllRequestsSortedByLocation() == nil {
            tableDataSource = [PFObject]()
        } else {
            tableDataSource = serverMan.fetchAllRequestsSortedByLocation()!
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
        
        // Configure the cell...
        cell.textLabel!.font = UIFont.systemFontOfSize(14)
        cell.textLabel!.numberOfLines = 0
        
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
        let fromGeoPoint = item["startPoint"] as! PFGeoPoint
        let fromPointCoordinates = CLLocationCoordinate2DMake(fromGeoPoint.latitude, fromGeoPoint.longitude)
        let fromAddress = reverseGeocodeCoordinate(fromPointCoordinates)
        cell.fromAddressLabel.text = fromAddress
        let toGeoPoint = item["endPoint"] as! PFGeoPoint
        let toPointCoordinates = CLLocationCoordinate2DMake(toGeoPoint.latitude, toGeoPoint.longitude)
        let toAddress = reverseGeocodeCoordinate(toPointCoordinates)
        cell.toAddressLabel.text = toAddress
        let fee = item["cost"] as? CGFloat
        cell.deliveryFeeLabel.text = "\(fee)"
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
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) -> String {
        var textAddress: String = ""
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            
            //Add this line
            if let _ = response {
                if let address = response.firstResult() {
                    let lines = address.lines as! [String]
                    
                    textAddress = lines.first!
                }
            }
            
            
        }
        return textAddress
    }

  
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
