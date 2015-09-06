//
//  RequestViewController.swift
//  craveit
//
//  Created by Akash Subramanian on 9/1/15.
//  Copyright (c) 2015 Akash Subramanian. All rights reserved.
//

import UIKit
import CoreLocation

class CreateRequestViewController: UIViewController {

    @IBOutlet weak var requestTextField: UITextField!
    
    @IBOutlet weak var deliveryFeeTextField: UITextField!
    
    @IBOutlet weak var deliverFromAddressLabel: UILabel!
    @IBOutlet weak var deliverToAddressLabel: UILabel!
    var deliverFromAddress: String?
    var deliverToAddress: String?
    let serverManager = ServerManager()
    var startCoordinates: CLLocationCoordinate2D?
    var endCoordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let from = deliverFromAddress {
            deliverFromAddressLabel.text = from
        }
        if let to = deliverToAddress {
            deliverToAddressLabel.text = to
        }
        
    }
    
    
    @IBAction func resignResponder(sender: UITextField) {
        sender.resignFirstResponder()
        requestTextField.resignFirstResponder()
        deliveryFeeTextField.resignFirstResponder()
    }
    
    @IBAction func submitRequest(sender: UIButton) {
       if let user = AppDelegate.Location.currentUser {
        
        serverManager.sendRequestToServer(user.username!, money: CGFloat(NSNumberFormatter().numberFromString(deliveryFeeTextField.text)!.floatValue), start: startCoordinates!, end: endCoordinates!, user: user)
            println("user is logged in!")
        }
        performSegueWithIdentifier("submittedRequest", sender: nil)
    }

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let identifier  = segue.identifier {
//            switch identifier {
//            case "submittedRequest":
//                if let svc = segue.destinationViewController as? SuccessViewController {
//                    
//                }
//            }
//        }
//    }

    
}
