//
//  SocialNetworkLoginInfo.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/28/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation

class SNBasicLoginInfo {
    var userID: String!
    //  var accessToken: String!
    //  var accessTokenSecret: String?
    
    init(userID: String/*, accessToken: String, accessTokenSecret: String? = nil*/) {
        self.userID = userID
        //    self.accessToken = accessToken
        //    self.accessTokenSecret = accessTokenSecret
    }
}

