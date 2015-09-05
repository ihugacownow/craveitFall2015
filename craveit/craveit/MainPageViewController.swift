//
//  MainPageViewController.swift
//  craveit
//
//  Created by Akash Subramanian on 9/1/15.
//  Copyright (c) 2015 Akash Subramanian. All rights reserved.
//

import UIKit
import GoogleMaps
import Parse

class MainPageViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate
{

    @IBOutlet var testServerButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    
    let manager = AppDelegate.Location.Manager
    let serverMan = AppDelegate.Location.ServerMan

    
    @IBAction func testServer() {
        println("Pressing test server")
        let location = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0)
        let user = User()
        let money: CGFloat = 10.0
        serverMan.sendRequestToServer("test", money: money, start: location, end: location, user: PFUser.currentUser()!)
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        manager.requestWhenInUseAuthorization()
        mapView.myLocationEnabled = true
        manager.startUpdatingLocation()
        mapView.settings.myLocationButton = true
        if let currentLocation = manager.location {
            self.mapView.camera = GMSCameraPosition.cameraWithTarget(currentLocation.coordinate, zoom: 17.0)
            
        }
        

        
    }
    
}