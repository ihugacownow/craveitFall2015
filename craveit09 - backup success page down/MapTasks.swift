//
//  MapTasks.swift
//  PocketMeter
//
//  Created by Akash Subramanian on 7/28/15.
//  Copyright (c) 2015 Akash Subramanian. All rights reserved.
//

import UIKit
import CoreLocation

class MapTasks: NSObject
{
    let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"
    let baseURLPlaces = "https://maps.googleapis.com/maps/api/place/textsearch/json?"
    
    var lookupAddressResults = [Dictionary<NSObject, AnyObject>]()
    
    var fetchedFormattedAddressList = [String]()
    
    var fetchedAddressLongitudeList = [Double]()
    
    var fetchedAddressLatitudeList = [Double]()
    
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    
    var selectedRoute: Dictionary<NSObject, AnyObject>!
    
    var overviewPolyline: Dictionary<NSObject, AnyObject>!
    
    var possibleRoutes = [Dictionary<NSObject, AnyObject>]()
    
    var overviewPolylineForRoute = [Dictionary<NSObject, AnyObject>]()
    
    var originCoordinate: CLLocationCoordinate2D?
    
    var destinationCoordinate: CLLocationCoordinate2D!
    
    var originAddress: String!
    
    var destinationAddress: String!
    
    var totalDistanceInMeters: UInt = 0
    
    var totalDistance: String!
    
    var totalDurationInSeconds: UInt = 0
    
    var totalDuration: String!
    
    //var meterBrain = MeterBrain()
    
    override init() {
        super.init()
    }
    
    func geocodeAddress(address: String!, withCompletionHandler completionHandler: ((status: String, success: Bool) -> Void)) {
        if let lookupAddress = address {
            var geocodeURLString = baseURLGeocode + "address=" + lookupAddress
            geocodeURLString = geocodeURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            let geocodeURL = NSURL(string: geocodeURLString)
            
            var placesURLString = baseURLPlaces + "query=" + lookupAddress + "&key=AIzaSyDoZUG8swN8bpSs9mT72Q960ChHmOWXjGM"
            placesURLString = placesURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            let placesURL = NSURL(string: placesURLString)
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let geocodingResultsData = NSData(contentsOfURL: geocodeURL!)
                let placesResultsData = NSData(contentsOfURL: placesURL!)
                
                let error: NSError? = nil
                let dictionary: Dictionary<NSObject, AnyObject> = NSJSONSerialization.JSONObjectWithData(geocodingResultsData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as!Dictionary<NSObject, AnyObject>
                let placesDictionary: Dictionary<NSObject, AnyObject> = NSJSONSerialization.JSONObjectWithData(placesResultsData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as!Dictionary<NSObject, AnyObject>
                
                if (error != nil) {
                    println(error)
                    completionHandler(status: "", success: false)
                }
                else {
                    // Get the response status.
                    let status = dictionary["status"] as!String
                    
                    if status == "OK" {
                        self.lookupAddressResults = dictionary["results"] as!Array<Dictionary<NSObject, AnyObject>>
                        self.lookupAddressResults += placesDictionary["results"] as!Array<Dictionary<NSObject, AnyObject>>
                        
                        
                        // Keep the most important values.
                        for result in self.lookupAddressResults {
                            self.fetchedFormattedAddressList.append(result["formatted_address"] as! String)
                            let geometry = result["geometry"] as! Dictionary<NSObject, AnyObject>
                            self.fetchedAddressLongitudeList.append( ((geometry["location"] as!Dictionary<NSObject, AnyObject>)["lng"] as! NSNumber).doubleValue )
                            self.fetchedAddressLatitudeList.append( ((geometry["location"] as!Dictionary<NSObject, AnyObject>)["lat"] as!NSNumber).doubleValue )
                        }
                        
                        
                        completionHandler(status: status, success: true)
                    }
                    else {
                        completionHandler(status: status, success: false)
                    }
                    
                    let status2 = placesDictionary["status"] as!String
                    
                    if status2 == "OK" {
                        
                        self.lookupAddressResults += placesDictionary["results"] as!Array<Dictionary<NSObject, AnyObject>>
                        
                        
                        // Keep the most important values.
                        for result in self.lookupAddressResults {
                            if !contains(self.fetchedFormattedAddressList, (result["formatted_address"] as! String)) {
                                self.fetchedFormattedAddressList.append(result["formatted_address"] as! String)
                                let geometry = result["geometry"] as! Dictionary<NSObject, AnyObject>
                                self.fetchedAddressLongitudeList.append( ((geometry["location"] as!Dictionary<NSObject, AnyObject>)["lng"] as! NSNumber).doubleValue )
                                self.fetchedAddressLatitudeList.append( ((geometry["location"] as!Dictionary<NSObject, AnyObject>)["lat"] as!NSNumber).doubleValue )
                            
                            }
                            
                            
                        }
                        
                        
                        completionHandler(status: status, success: true)
                    }
                    else {
                        completionHandler(status: status, success: false)
                    }
                    
                }
            })
        }
        else {
            completionHandler(status: "No valid address.", success: false)
        }
    }
    
    
//    func getDirections(origin: CLLocationCoordinate2D!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((status: String, success: Bool) -> Void)) {
//        
//       // var legs = [Dictionary<NSObject, AnyObject>]()
//        
//        if let originLocation = origin {
//            if let destinationLocation = destination {
//               // var directionsURLString = baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&units=imperial&alternatives=true&sensor=false"
//                var directionsURLString = baseURLDirections + "origin=" + "\(origin.latitude)" + "," + "\(origin.longitude)" + "&destination=" + destinationLocation + "&units=imperial&alternatives=true&sensor=false"
//                
//                directionsURLString = directionsURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
//                
//                let directionsURL = NSURL(string: directionsURLString)
//                
//                
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    let directionsData = NSData(contentsOfURL: directionsURL!)
//                    
//                    let error: NSError? = nil
//                    let dictionary: Dictionary<NSObject, AnyObject> = NSJSONSerialization.JSONObjectWithData(directionsData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! Dictionary<NSObject, AnyObject>
//
//                    
//                    if (error != nil) {
//                        println(error)
//                        completionHandler(status: "", success: false)
//                    }
//                    else {
//                        let status = dictionary["status"] as! String
//                        
//                        if status == "OK" {
//                            
//                            for route in dictionary["routes"] as! Array<Dictionary<NSObject, AnyObject>> {
//                                
//                                self.possibleRoutes.append(route)
//                                self.overviewPolylineForRoute.append(route["overview_polyline"] as! Dictionary<NSObject, AnyObject>)
//                                let legs = route["legs"] as! Array<Dictionary<NSObject, AnyObject>>
//                                let startLocationDictionary = legs[0]["start_location"] as! Dictionary<NSObject, AnyObject>
//                                
//                                    self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
//                                
//                                let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<NSObject, AnyObject>
//                                self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
//                                
//                                self.originAddress = legs[0]["start_address"] as! String
//                                self.destinationAddress = legs[legs.count - 1]["end_address"] as! String
//                                
//                                //self.calculateTotalDistanceAndDuration()
//                                
//                            }
//                            
//                            
//        
//                            
//                            
//                            
//                           
//                            
//                            completionHandler(status: status, success: true)
//                        }
//                        else {
//                            completionHandler(status: status, success: false)
//                             
//                        }
//                    }
//                })
//            }
//            else {
//                completionHandler(status: "Destination is nil.", success: false)
//            }
//        }
//        else {
//            completionHandler(status: "Origin is nil", success: false)
//        }
//    }
    
    
       func getDirections(origin: CLLocationCoordinate2D!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((status: String, success: Bool) -> Void)) {
        if let originLocation = origin {
            if let destinationLocation = destination {
                var directionsURLString = baseURLDirections + "origin=" + "\(origin.latitude)" + "," + "\(origin.longitude)" + "&destination=" + destinationLocation + "&units=imperial&alternatives=true&sensor=false"


                
                directionsURLString = directionsURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                
                let directionsURL = NSURL(string: directionsURLString)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let directionsData = NSData(contentsOfURL: directionsURL!)
                    
                    var error: NSError?
                    let dictionary: Dictionary<NSObject, AnyObject> = NSJSONSerialization.JSONObjectWithData(directionsData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! Dictionary<NSObject, AnyObject>
                    
                    if (error != nil) {
                        println(error)
                        completionHandler(status: "", success: false)
                    }
                    else {
                        let status = dictionary["status"] as! String
                        
                        if status == "OK" {
                            self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<NSObject, AnyObject>>)[0]
                            self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<NSObject, AnyObject>
                            
                            let legs = self.selectedRoute["legs"] as! Array<Dictionary<NSObject, AnyObject>>
                            
                            let startLocationDictionary = legs[0]["start_location"] as! Dictionary<NSObject, AnyObject>
                            self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                            
                            let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<NSObject, AnyObject>
                            self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                            
                            self.originAddress = legs[0]["start_address"] as! String
                            self.destinationAddress = legs[legs.count - 1]["end_address"] as! String
                            
                            self.calculateTotalDistanceAndDuration()                        
                            
                            completionHandler(status: status, success: true)
                        }
                        else {
                            completionHandler(status: status, success: false)
                        }
                    }
                })
            }
            else {
                completionHandler(status: "Destination is nil.", success: false)
            }
        }
        else {
            completionHandler(status: "Origin is nil", success: false)
        }
    }
    
    
    
    func calculateTotalDistanceAndDuration() {
        let legs = self.selectedRoute["legs"] as! Array<Dictionary<NSObject, AnyObject>>
        
        totalDistanceInMeters = 0
        totalDurationInSeconds = 0
        
        for leg in legs {
            totalDistanceInMeters += (leg["distance"] as! Dictionary
                
                <NSObject, AnyObject>)["value"] as! UInt
            totalDurationInSeconds += (leg["duration"] as! Dictionary<NSObject, AnyObject>)["value"] as! UInt
        }
        
        
        let distanceInKilometers: Double = Double(totalDistanceInMeters / 1000)
        totalDistance = "Total Distance: \(distanceInKilometers) Km"
        
        
        let mins = totalDurationInSeconds / 60
        let hours = mins / 60
        let days = hours / 24
        let remainingHours = hours % 24
        let remainingMins = mins % 60
        let remainingSecs = totalDurationInSeconds % 60
        
        totalDuration = "Duration: \(days) d, \(remainingHours) h, \(remainingMins) mins, \(remainingSecs) secs"
    }
    
    
    
    
   
}
