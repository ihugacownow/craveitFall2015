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

class MainPageViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate
{

    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOut()
        AppDelegate.Location.currentUser = nil
        performSegueWithIdentifier("loggedOut", sender: nil)
        
    }
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var deliverToTextField: UITextField!
    @IBOutlet weak var deliverFromTextField: UITextField!
    @IBOutlet var testServerButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    var routePolyline: GMSPolyline!
    var origin: String?
    var destination: String?
    var originLongitude: Double?
    var originLatitude: Double?
    var destinationLongitude: Double?
    var destinationLatitude: Double?
    var deliverFromCoordinates: CLLocationCoordinate2D?
    var deliverToCoordinates: CLLocationCoordinate2D?
    let manager = AppDelegate.Location.Manager
    let serverMan = AppDelegate.Location.ServerMan
    let mapTasks = MapTasks()
    var deliverFromMarker: GMSMarker!
    var deliverToMarker: GMSMarker!
    let defaults = NSUserDefaults.standardUserDefaults()
    var originCoordinate: CLLocationCoordinate2D?

    
    @IBAction func testServer() {
        println("Pressing test server")
        let location = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0)
        //let user = User()
        let money: CGFloat = 10.0
        serverMan.sendRequestToServer("test", money: money, start: location, end: location, user: PFUser.currentUser()!)
    }
    
  
    @IBAction func nextButtonAction(sender: UIButton) {
        
        performSegueWithIdentifier("createRequest", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        deliverFromTextField.delegate = self
        deliverToTextField.delegate = self
        
        nextButton.hidden = true
        
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        mapView.myLocationEnabled = true
        manager.startUpdatingLocation()
        mapView.settings.myLocationButton = true
        if let currentLocation = manager.location {
            AppDelegate.Location.currentLocation = currentLocation
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
        
        if let _ = defaults.valueForKey("fromLatitude") {
            println("origin finding")
            originLatitude = defaults.valueForKey("fromLatitude") as? Double
            originLongitude = defaults.valueForKey("fromLongitude") as? Double
            //deliverFromMarker = GMSMarker(position: CLLocationCoordinate2DMake(originLatitude!, originLongitude!))
        }
        
        if let _ = defaults.valueForKey("toLatitude") {
            println("destination finding")
            destinationLatitude = defaults.valueForKey("toLatitude") as? Double
            destinationLongitude = defaults.valueForKey("toLongitude") as? Double
        }
        
        if let fromAddress = origin {
            deliverFromTextField.text = fromAddress
        }
        if let toAddress = destination {
            deliverToTextField.text = toAddress
        }
        
    }
    
   
    func showNextIfBothTextFieldsFull() {
        if self.deliverToTextField.text != nil && self.deliverFromTextField.text != nil {
            nextButton.hidden = false
        } else {
            nextButton.hidden = true
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
        
        self.showNextIfBothTextFieldsFull()
        
        if originLatitude != nil && originLongitude != nil {
            
            defaults.setValue(originLatitude, forKey: "fromLatitude")
            defaults.setValue(originLongitude, forKey: "fromLongitude")
            //println("should show marker")
            //deliverFromMarker = GMSMarker(position: CLLocationCoordinate2DMake(locationLatitude!, locationLongitude!))
            //self.mapView.camera = GMSCameraPosition.cameraWithTarget(CLLocationCoordinate2DMake(originLatitude!, originLongitude!), zoom: 17.0)
            if let _ = deliverToMarker {
                deliverFromMarker = GMSMarker(position: CLLocationCoordinate2DMake(originLatitude!, originLongitude!))
            deliverFromMarker.map = mapView
            deliverFromMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
            //deliverFromMarker.title = origin!
            }
        }
        if destinationLatitude != nil && destinationLongitude != nil {
            defaults.setValue(destinationLatitude, forKey: "toLatitude")
            println("the tolatitude is \(destinationLatitude!)")
            defaults.setValue(destinationLongitude, forKey: "toLongitude")
            if destinationLatitude != nil && destinationLongitude != nil && originLatitude != nil && originLongitude != nil {
            createRoute(mapTasks, origin: CLLocationCoordinate2DMake(originLatitude!, originLongitude!), destination: destination)
                self.mapView.camera = GMSCameraPosition.cameraWithTarget(CLLocationCoordinate2DMake(destinationLatitude!, destinationLongitude!), zoom: 17.0)
                destinationLatitude = nil
                destinationLongitude = nil
                
//                defaults.setValue(nil, forKey: "fromLatitude")
//                defaults.setValue(nil, forKey: "fromLongitude")
//                defaults.setValue(nil, forKey: "toLatitude")
//                defaults.setValue(nil, forKey: "toLongitude")
//                defaults.setValue(nil, forKey: "deliverFrom")
//                defaults.setValue(nil, forKey: "deliverTo")
            }
           
            
            //deliverToMarker = GMSMarker(position: CLLocationCoordinate2DMake(locationLatitude!, locationLongitude!))
                        if let _ = deliverToMarker {
            deliverToMarker.map = mapView
            deliverToMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
            deliverToMarker.title = destination
            }
            
        }

    }
    
    func createRoute(mapTasks: MapTasks, origin: CLLocationCoordinate2D?, destination: String?) {
        println(origin)
        println(destination)
        if destination != nil && origin != nil {
            
            mapTasks.getDirections(origin, destination: destination, waypoints: nil, travelMode: nil, completionHandler: { (status, success) -> Void in
                if success {
                    //self.configureMapAndMarkersForRoute()
                   
                    self.drawRoutes()
                    //self.displayRouteInfo()
                }
                else {
                    println(status)
                    //self.showAlertWithMessage("Unable to find any routes. Sorry about that!")
                }
            })
            
        }
    }
    
    func configureMapAndMarkersForRoute() {
        self.mapView.camera = GMSCameraPosition.cameraWithTarget(mapTasks.originCoordinate!, zoom: 15.0)
        //deliverFromMarker = GMSMarker(position: mapTasks.originCoordinate!)
        deliverFromMarker.map = mapView
        deliverFromMarker!.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
        deliverFromMarker!.title = mapTasks.originAddress
        
        deliverToMarker = GMSMarker(position: self.mapTasks.destinationCoordinate)
        deliverToMarker.map = self.mapView
        deliverToMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        deliverToMarker.title = self.mapTasks.destinationAddress
    }
    
    
    func drawRoutes() {
        
        
            let route = mapTasks.overviewPolyline["points"] as! String
            let path: GMSPath = GMSPath(fromEncodedPath: route)
            routePolyline = GMSPolyline(path: path)
        routePolyline.strokeWidth = 5
            routePolyline.map = mapView
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier  = segue.identifier {
            switch identifier {
            case "createRequest" :
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
    
