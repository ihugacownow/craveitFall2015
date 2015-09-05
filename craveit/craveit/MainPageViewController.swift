//
//  MainPageViewController.swift
//  craveit
//
//  Created by Akash Subramanian on 9/1/15.
//  Copyright (c) 2015 Akash Subramanian. All rights reserved.
//

import UIKit
import GoogleMaps

class MainPageViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate
{

    @IBOutlet weak var mapView: GMSMapView!
    let manager = AppDelegate.Location.Manager
    
    
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