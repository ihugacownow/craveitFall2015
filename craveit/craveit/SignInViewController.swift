//
//  SignInViewController.swift
//  craveit
//
//  Created by Akash Subramanian on 9/1/15.
//  Copyright (c) 2015 Akash Subramanian. All rights reserved.
//

import UIKit
import Parse

class SignInViewController: UIViewController {

    let serverMan = AppDelegate.Location.ServerMan
    
    // WC Testing stuff
    var randomNumber = 0
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Akash drag the sign up botton here and edit func
    @IBAction func signUp() {
        let image = UIImage(named: "waichoong")
        let photoData = UIImageJPEGRepresentation(image, 0.500)
        
        // Just for testing
        randomNumber = randomNumber + 1
        
        serverMan.signUp("username", password: "ilovewaichoong\(randomNumber)", email: "waichoong\(randomNumber)@gmail.com", photoData: photoData)
    }
    
    // Akash
    @IBAction func logIn() {
        PFUser.logInWithUsernameInBackground("myname", password:"mypass") {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Akash segue to next vc
            } else {
                // Akash print to UIView
            }
        }

    }
    
    
    // If needed in future 
    @IBAction func logOut() {
        PFUser.logOut()
        println("user is now \(PFUser.currentUser())")
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
