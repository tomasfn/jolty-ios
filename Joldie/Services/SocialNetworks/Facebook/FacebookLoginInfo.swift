//
//  FacebookLoginInfo.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/30/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation

class FacebookLoginInfo: SNBasicLoginInfo {
    
    var accessToken: String
    
    var email: String
    var gender: String
    var ageRange: String
    var birth: String?
    
    
    init(userID: String, accessToken: String, email: String, gender: String, ageRange: String, birth: String?) {
        self.accessToken = accessToken
        self.email = email
        self.gender = gender
        self.ageRange = ageRange
        self.birth = birth
        
        super.init(userID: userID)
    }
}

