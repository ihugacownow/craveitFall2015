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
    var randomNumber: Int = 0
    
    
    @IBAction func resignusername(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func resignPassword(sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBOutlet weak var usernameTextField: UITextField!
    
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
  
    
    // Akash
    @IBAction func logIn() {
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password:passwordTextField.text) {
            
            (user: PFUser?, error: NSError?) -> Void in
            println("username is \(self.usernameTextField.text) and password is \(self.passwordTextField.text)")
            if user != nil {
                AppDelegate.Location.currentUser = user 
                // Akash segue to next vc
                self.performSegueWithIdentifier("signedIn", sender: nil)
                
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
