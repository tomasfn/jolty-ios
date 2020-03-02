//
//  AuthenticationInfo.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/28/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit

class AuthenticationInfo: NSObject {
    
    var newUser: Bool? = false
    var access_token: String!
    var id_tw: String?
    var refresh_token: String!
    var expires_in: Double!
    
    init(json: [String : AnyObject]) {
        newUser = json["new_user"] as? Bool
        access_token = json["access_token"] as! String
        id_tw = json["id_tw"] as? String
        refresh_token = json["refresh_token"] as! String
        expires_in = (json["expires_in"] as! NSNumber).doubleValue
    }
    
}

