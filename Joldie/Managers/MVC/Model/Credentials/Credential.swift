//
//  Credentia.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/28/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation

class Credential {
    
    var userId: String
    var accessToken: String
    var refreshToken: String
    var validFrom: NSDate
    var validUntil: NSDate
    
    var expiresIn: TimeInterval {
        get {
            return self.validUntil.timeIntervalSince(NSDate() as Date)
        }
        
        set {
            self.validFrom = NSDate()
            self.validUntil = NSDate(timeIntervalSinceNow: newValue)
        }
    }
    
    init(userId: String, accessToken: String, refreshToken: String, expiresIn: TimeInterval) {
        self.userId = userId
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.validFrom = NSDate()
        self.validUntil = NSDate(timeIntervalSinceNow: expiresIn)
    }
    
    init(userId: String, accessToken: String, refreshToken: String, validFrom: NSDate, validUntil: NSDate) {
        self.userId = userId
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.validFrom = validFrom
        self.validUntil = validUntil
    }
    
    var dictionary:[String : AnyObject] {
        return [
            "userId" : userId as AnyObject,
            "accessToken" : accessToken as AnyObject,
            "refreshToken" : refreshToken as AnyObject,
            "validFrom" : validFrom,
            "validUntil" : validUntil
        ]
    }
    
    class func fromDict(dict: [String : AnyObject]) -> Credential? {
        guard let userId = dict["userId"] as? String,
            let accessToken = dict["accessToken"] as? String,
            let refreshToken = dict["refreshToken"] as? String,
            let validFrom = dict["validFrom"] as? NSDate,
            let validUntil = dict["validUntil"] as? NSDate else {
                return nil
        }
        
        let credential = Credential(userId: userId, accessToken: accessToken, refreshToken: refreshToken, validFrom: validFrom, validUntil: validUntil)
        return credential
    }
    
}

extension Credential {
    
    var basicAuth: String {
        let base64Encoded = "\(userId):\(accessToken)".base64Encoded
        return "Basic \(base64Encoded)"
    }
    
}

extension Credential {
    
    func refreshAccessToken(completionBlock: @escaping (Bool) -> Void) {
        AuthenticationService.refreshAccessToken(credentials: self, invalidateOldToken: true) { (credential) in
            completionBlock(credential != nil)
        }
    }
}
