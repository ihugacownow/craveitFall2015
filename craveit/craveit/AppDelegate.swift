//
//  AppDelegate.swift
//  craveit
//
//  Created by Akash Subramanian on 9/1/15.
//  Copyright (c) 2015 Akash Subramanian. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import CoreLocation

//import Parse packages
import Parse
import Bolts



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    
    // Akash hope im not corrupting your struc, but im seeing it more like a way of holding your global classes
    struct Location {
        static let Manager = CLLocationManager()
        static let ServerMan = ServerManager()
        static var currentUser: PFUser?
        static var loggedInUser: PFUser?
        static var currentLocation: CLLocation?
        
    }
    
    let googleMapsApiKey = "AIzaSyBPKqF8F9XzFM_ZSP6WbirLbaJgN9vGB5I"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject:
        AnyObject]?) -> Bool {
            
            // [Optional] Power your app with Local Datastore. For more info, go to
            // https://parse.com/docs/ios_guide#localdatastore/iOS
            Parse.enableLocalDatastore()
            
            // Initialize Parse.
            Parse.setApplicationId("iNoTiRs00J5w5QLHo8pEvfCOy2gjMdhCNWRhkVHG",
                clientKey: "1zBY9EHbdRZ8QDFvYjDEBgamCB5d2OdBMt16TUhK")
            
            // [Optional] Track statistics around application opens.
            PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            
            GMSServices.provideAPIKey(googleMapsApiKey)
            
            
            //Login Logic 
            Location.currentUser = PFUser.currentUser()
            
            
            if Location.currentUser != nil {
                println("User name is \(Location.currentUser!.username)")
                  var storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                window?.rootViewController = storyboard.instantiateViewControllerWithIdentifier("mainPage") as? UIViewController
                let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                let rootViewController:UIViewController = storyboard.instantiateViewControllerWithIdentifier("mainPage") as! UIViewController
                navigationController.viewControllers = [rootViewController]
                self.window?.rootViewController = navigationController
                
            } else {
                // Akash show the signup or login screen
                var storyboard = UIStoryboard(name: "Main", bundle: nil)
                //window?.rootViewController = storyboard.instantiateViewControllerWithIdentifier("logIn") as? UIViewController
                let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                let rootViewController:UIViewController = storyboard.instantiateViewControllerWithIdentifier("logIn") as! UIViewController
                navigationController.viewControllers = [rootViewController]
                self.window?.rootViewController = navigationController
            }
            self.window?.makeKeyAndVisible()
    
            return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Me.craveit" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("craveit", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("craveit.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

