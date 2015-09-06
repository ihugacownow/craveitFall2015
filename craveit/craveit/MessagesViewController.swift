//
//  MessagesViewController.swift
//  craveit
//
//  Created by Akash Subramanian on 9/1/15.
//  Copyright (c) 2015 Akash Subramanian. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController {

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var requestLabel: UILabel!
    var from: String?
    var to: String?
    var what: String?
    var fee: String?
    var username: String?
    
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fromLabel.text = from
        toLabel.text = to
        feeLabel.text = fee
        requestLabel.text = what
        nameLabel.text = username
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
