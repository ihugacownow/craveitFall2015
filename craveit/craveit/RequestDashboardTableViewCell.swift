//
//  RequestDashboardTableViewCell.swift
//  craveit
//
//  Created by Akash Subramanian on 9/6/15.
//  Copyright (c) 2015 Akash Subramanian. All rights reserved.
//

import UIKit

class RequestDashboardTableViewCell: UITableViewCell
{
    @IBOutlet weak var deliverFromLabel: UILabel!
    let serverManager = ServerManager()
    @IBOutlet weak var deliverToLabel: UILabel!
    
    @IBOutlet weak var toggleMarketPlaceEntrySwitch: UISwitch!
        
}
