//
//  BaseViewController.swift
//  craveit
//
//  Created by Wu Wai Choong on 9/5/15.
//  Copyright (c) 2015 Akash Subramanian. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UITextFieldDelegate {
    
    var originalCenter: CGPoint = CGPoint(x: 0.00, y: 0.00)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.originalCenter = CGPoint(x: self.view.center.x, y: self.view.center.y)
    }    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardWillShowNotification, object: nil)
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardWillHideNotification, object: nil)
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardDidShow(notification: NSNotification){
        // Assign new frame to your view
        self.view.center = CGPoint(x: self.originalCenter.x, y: self.originalCenter.y - 100);
    }
    
    func keyboardDidHide(notification: NSNotification) {
        self.view.center = self.originalCenter;
    }
}
