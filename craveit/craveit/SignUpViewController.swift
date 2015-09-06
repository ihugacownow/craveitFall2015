//
//  SignUpViewController.swift
//  craveit
//
//  Created by Akash Subramanian on 9/5/15.
//  Copyright (c) 2015 Akash Subramanian. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var serverMan = AppDelegate.Location.ServerMan
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self 

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUp(sender: UIButton) {
        let image = UIImage(named: "waichoong")
        let photoData = UIImageJPEGRepresentation(image, 0.500)
        
        // Just for testing
        
        
        serverMan.signUp(nameTextField.text, password: passwordTextField.text, email: emailTextField.text, photoData: photoData)
        
        performSegueWithIdentifier("signedUp", sender: nil)
    }


   
}
