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
import CoreLocation

class MainPageViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate
{

    @IBOutlet weak var deliverToTextField: UITextField!
    @IBOutlet weak var deliverFromTextField: UITextField!
    @IBOutlet var testServerButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    
    var destination: String?
    var locationLongitude: Double?
    var locationLatitude: Double?
    var deliverFromCoordinates: CLLocationCoordinate2D?
    var deliverToCoordinates: CLLocationCoordinate2D?
    let manager = AppDelegate.Location.Manager
    let serverMan = AppDelegate.Location.ServerMan
    let mapTasks = MapTasks()
    var deliverFromMarker: GMSMarker!
    var deliverToMarker: GMSMarker!
    let defaults = NSUserDefaults.standardUserDefaults()

    
    @IBAction func testServer() {
        println("Pressing test server")
        let location = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0)
        //let user = User()
        let money: CGFloat = 10.0
        serverMan.sendRequestToServer("test", money: money, start: location, end: location, isCompleted: false, user: PFUser.currentUser()!)
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        mapView.myLocationEnabled = true
        manager.startUpdatingLocation()
        mapView.settings.myLocationButton = true
        if let currentLocation = manager.location {
            self.mapView.camera = GMSCameraPosition.cameraWithTarget(currentLocation.coordinate, zoom: 17.0)

        }
        println("before")
        if let fromAddress = defaults.valueForKey("deliverFrom") as? String {
            deliverFromTextField.text = fromAddress
            println("after")
        }
        if let toAddress = defaults.valueForKey("deliverTo") as? String {
            deliverToTextField.text = toAddress
        }
        
    }
    

    @IBAction func searchFromLocationAddress(sender: UITextField) {
        sender.resignFirstResponder()
        self.performSegueWithIdentifier("lookUpFromAddress", sender: nil)
    }
   
    @IBAction func searchToLocationAddress(sender: UITextField) {
        sender.resignFirstResponder()
        self.performSegueWithIdentifier("lookUpToAddress", sender: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
            //println("did update location")
        if let fromMarker = deliverFromMarker {
            defaults.setValue(locationLatitude, forKey: "fromLatitude")
            defaults.setValue(locationLongitude, forKey: "fromLongitude")
            //println("should show marker")
            //deliverFromMarker = GMSMarker(position: CLLocationCoordinate2DMake(locationLatitude!, locationLongitude!))
            self.mapView.camera = GMSCameraPosition.cameraWithTarget(CLLocationCoordinate2DMake(locationLatitude!, locationLongitude!), zoom: 17.0)
            fromMarker.map = mapView
            fromMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
            fromMarker.title = destination
        }
        if let toMarker = deliverToMarker {
            defaults.setValue(locationLatitude, forKey: "toLatitude")
            defaults.setValue(locationLongitude, forKey: "toLongitude")
            //deliverToMarker = GMSMarker(position: CLLocationCoordinate2DMake(locationLatitude!, locationLongitude!))
            self.mapView.camera = GMSCameraPosition.cameraWithTarget(CLLocationCoordinate2DMake(locationLatitude!, locationLongitude!), zoom: 17.0)
            toMarker.map = mapView
            toMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
            toMarker.title = destination
            
        }

    }
    
//    func configureMapAndMarkersForRoute() {
//        self.mapView.camera = GMSCameraPosition.cameraWithTarget(mapTasks.originCoordinate!, zoom: 15.0)
//        originMarker = GMSMarker(position: mapTasks.originCoordinate!)
//        originMarker.map = mapView
//        originMarker!.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
//        originMarker!.title = mapTasks.originAddress
//        
//        destinationMarker = GMSMarker(position: self.mapTasks.destinationCoordinate)
//        destinationMarker.map = self.mapView
//        destinationMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
//        destinationMarker.title = self.mapTasks.destinationAddress
//    }
    
    @IBAction func openDeliverPage(sender: UIButton) {
        performSegueWithIdentifier("deliver", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier  = segue.identifier {
            switch identifier {
            case "request" :
                if let rvc = segue.destinationViewController as? CreateRequestViewController {
                    rvc.deliverFromAddress = deliverFromTextField.text
                    rvc.deliverToAddress = deliverToTextField.text
                    rvc.startCoordinates = CLLocationCoordinate2DMake(defaults.valueForKey("fromLatitude") as! Double, defaults.valueForKey("fromLongitude") as! Double)
                    rvc.endCoordinates = CLLocationCoordinate2DMake(defaults.valueForKey("toLatitude") as! Double, defaults.valueForKey("toLongitude") as! Double)
                        
            }
            case "lookUpFromAddress" :
                if let srvc = segue.destinationViewController as? SearchResultsTableViewController {
                    srvc.searchQuery = deliverFromTextField.text
                    deliverFromTextField.resignFirstResponder()
                    srvc.sender = "from"
                    println(srvc.sender)
                    
                }
            case "lookUpToAddress" :
                if let srvc = segue.destinationViewController as? SearchResultsTableViewController {
                    srvc.searchQuery = deliverToTextField.text
                    deliverToTextField.resignFirstResponder()
                    srvc.sender = "to"
                }

            default: break
                
            }
        }
    }
}
    
