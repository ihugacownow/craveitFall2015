//
//  RequestsDashboardTableViewCell.swift
//  craveit
//
//  Created by Akash Subramanian on 9/5/15.
//  Copyright (c) 2015 Akash Subramanian. All rights reserved.
//

import UIKit
import Parse

class RequestsDashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var deliverFromLabel: UILabel!
    let serverManager = ServerManager()
    @IBOutlet weak var deliverToLabel: UILabel!
    
    @IBAction func toggleEntryIntoMarketPlace(sender: UISwitch) {
        if sender.on {
            if let user = AppDelegate.Location.currentUser {
                var query = PFQuery(className: "Request")
                //var object = query.getObjectWithId(AppDelegate.Location.requestObjectID["Request"])
                
            }

        } else {
            
        }
    }
}
