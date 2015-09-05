//
//  MarketPlaceViewController.swift
//  craveit
//
//  Created by Akash Subramanian on 9/1/15.
//  Copyright (c) 2015 Akash Subramanian. All rights reserved.
//

import UIKit
import Parse

class MarketPlaceViewController: UIViewController {
    
    var tableDataSource = [PFObject]()
    var serverMan = AppDelegate.Location.ServerMan
    
    // This is a hack 
    var clock: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clock = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "refreshListOfRequests", userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshListOfRequests() {
        if serverMan.fetchAllRequestsSortedByLocation() == nil {
            tableDataSource = [PFObject]()
        } else {
            tableDataSource = serverMan.fetchAllRequestsSortedByLocation()!
        }
    }
    
// MARK -- TABLE VIEW METHOD AKASH
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // Return the number of sections.
//        return 1
//    }
//
//    
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier(
//            "resultCell", forIndexPath: indexPath) as! UITableViewCell
//        
//        // Configure the cell...
//        cell.textLabel!.font = UIFont.systemFontOfSize(14)
//        cell.textLabel!.numberOfLines = 0
//        
//        let row = indexPath.row
//        
//        let item = matchingAddresses[row]
//        cell.textLabel!.text = item
//        //        tableHeight += cell.frame.size.height
//        //        println(tableHeight)
//        //        resultsTableViewHeightConstraint.constant = tableHeight
//        let selectedView = UIView()
//        selectedView.backgroundColor = UIColor(red: 241, green: 196, blue: 15)
//        cell.selectedBackgroundView = selectedView
//        
//        
//        
//        return cell
//    }
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableDataSource.count
//    }
//    
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let row = indexPath.row
//        selectedRow = row
//        let item = matchingAddresses[row]
//        println(item)
//        destinationFormattedAddress = item
//        destinationLatitude = self.mapTasks.fetchedAddressLatitudeList[row]
//        // println("\(destinationLatitude)")
//        destinationLongitude = self.mapTasks.fetchedAddressLongitudeList[row]
//        
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
