//
//  SearchResultsTableViewController.swift
//  
//
//  Created by Akash Subramanian on 8/19/15.
//
//

import UIKit
import GoogleMaps

class SearchResultsTableViewController: UITableViewController
{

    var searchQuery: String!
    var mapTasks = MapTasks()
    var matchingAddresses = [String]()
    var destinationFormattedAddress: String!
    var destinationLatitude: Double!
    var destinationLongitude: Double!
    var sender: String?
    let defaults = NSUserDefaults.standardUserDefaults()
   
    
    @IBOutlet var searchResultsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.allowsSelection = true
        //searchResultsTableView.tableFooterView = UIView()
       // println(searchQuery)
        performSearch()
    }
    
    func performSearch() {
        matchingAddresses.removeAll(keepCapacity: false)
        self.mapTasks.fetchedFormattedAddressList.removeAll(keepCapacity: false)
        self.mapTasks.fetchedAddressLongitudeList.removeAll(keepCapacity: false)
        self.mapTasks.fetchedAddressLatitudeList.removeAll(keepCapacity: false)
        self.mapTasks.lookupAddressResults.removeAll(keepCapacity: false)
        let address = searchQuery
        self.mapTasks.geocodeAddress(address, withCompletionHandler: { (status, success) -> Void in
            if !success {
                println(status)
                
                if status == "ZERO_RESULTS" {
                    println("here")
                    self.showAlertWithMessage("Unable to find the location you're looking for :( Try searching a Point of Interest nearby.")
                }
            }
            else {
                for item in self.mapTasks.fetchedFormattedAddressList {
                    if !contains(self.matchingAddresses, item) {
                        self.matchingAddresses.append(item)
                    }
                    
                    //println(item)
                }
                self.searchResultsTableView.reloadData()
            }
        })
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "resultCell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        cell.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.font = UIFont.systemFontOfSize(UIFont.systemFontSize())
        
        
        let row = indexPath.row
        
        let item = matchingAddresses[row]
        cell.textLabel!.text = item
        //        let selectedView = UIView()
        //        selectedView.backgroundColor = UIColor(red: 241, green: 196, blue: 15)
        //        cell.selectedBackgroundView = selectedView
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        //println(matchingAddresses.count)
        //resultsTableViewHeightConstraint.constant = CGFloat(50 * matchingAddresses.count)
        //mapResultsTableView.contentSize = preferredContentSize
        
        return matchingAddresses.count
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = indexPath.row
        //selectedRow = row
        let item = matchingAddresses[row]
       // println(item)
        destinationFormattedAddress = item
        println(destinationFormattedAddress)
        
        destinationLatitude = self.mapTasks.fetchedAddressLatitudeList[row]
        // println("\(destinationLatitude)")
        destinationLongitude = self.mapTasks.fetchedAddressLongitudeList[row]
        performSegueWithIdentifier("returnDestination", sender: nil)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "returnDestination":
                if let mvc = segue.destinationViewController as? MainPageViewController {
                    println(self.sender!)
                    mvc.manager.startUpdatingLocation()
                    //mvc.destination = destinationFormattedAddress
                    
                    if self.sender! == "from" {
                        mvc.origin = destinationFormattedAddress
                        mvc.originLongitude = destinationLongitude
                        mvc.originLatitude = destinationLatitude
                         println(CLLocationCoordinate2DMake(destinationLatitude!, destinationLongitude!))
                        
                        defaults.setValue(destinationFormattedAddress, forKey: "deliverFrom")
                        println("\(destinationFormattedAddress)")
                        defaults.setValue(destinationLatitude, forKey: "fromLatitude")
                           defaults.setValue(destinationLongitude, forKey: "fromLongitude")
                        mvc.originCoordinate = CLLocationCoordinate2DMake(destinationLatitude, destinationLongitude)
                        mvc.deliverFromMarker = GMSMarker(position: CLLocationCoordinate2DMake(destinationLatitude, destinationLongitude))
                    } else if self.sender! == "to" {
                        mvc.destination = destinationFormattedAddress
                        mvc.destinationLongitude = destinationLongitude
                        mvc.destinationLatitude = destinationLatitude
                        defaults.setValue(destinationFormattedAddress, forKey: "deliverTo")
                        defaults.setValue(destinationLatitude, forKey: "toLatitude")
                        defaults.setValue(destinationLongitude, forKey: "toLongitude")
                        //mvc.deliverToTextField.text = destinationFormattedAddress
                        mvc.deliverToMarker = GMSMarker(position: CLLocationCoordinate2DMake(destinationLatitude, destinationLongitude))
                    } else {
                        
                    }
                    
                    
                    
                    
                    
                }
            default : break
            }
        }
    }
    
    func showAlertWithMessage(message: String) {
        let alertController = UIAlertController(title: "craveit", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            
        }
        alertController.addAction(closeAction)
        
        presentViewController(alertController, animated: true, completion: nil)

    }

}
