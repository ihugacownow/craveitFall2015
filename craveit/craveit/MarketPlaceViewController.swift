//
//  MarketPlaceViewController.swift
//  craveit
//
//  Created by Akash Subramanian on 9/1/15.
//  Copyright (c) 2015 Akash Subramanian. All rights reserved.
//

import UIKit
import Parse

class MarketPlaceViewController: UIViewController, UITableViewDataSource {
    
    var tableDataSource: [AnyObject]?
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
        tableDataSource = serverMan.fetchAllRequestsSortedByLocation()
    }
    
// MARK -- TABLE VIEW METHOD AKASH
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableDataSource == nil {
            return 0
        } else {
            return tableDataSource!.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
