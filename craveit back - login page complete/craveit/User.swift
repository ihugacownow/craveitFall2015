//
//  User.swift
//  craveit
//
//  Created by Wu Wai Choong on 9/5/15.
//  Copyright (c) 2015 Akash Subramanian. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var objectID: String!
    var name: String!
    
    init(nam: String, objID: String) {
        objectID = objID
        name = nam
    }
}
