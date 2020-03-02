//
//  AnswersHelper.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/30/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import Crashlytics

private let onlyLogForProd = true

enum AnswersHelper {
    
    private static func shouldLog() -> Bool {
        if onlyLogForProd && environment != .PROD {
            return false
        }
        return true
    }
    
    
    static func logAuthenticationResult(authInfo: AuthenticationInfo?, fromSocialNetwork socialNetwork: SocialNetwork) {
        guard shouldLog() == true else { return }
        
        if let authInfo = authInfo {
            
            let attributes = [
                "Social network" : socialNetwork.name.uppercased()
            ]
            
            if authInfo.newUser != nil && authInfo.newUser == true {
                Answers.logSignUp(
                    withMethod: "Social Network",
                    success: true,
                    customAttributes: attributes
                )
            } else {
                Answers.logLogin(
                    withMethod: "Social Network",
                    success: true,
                    customAttributes: attributes
                )
            }
            
        } else {
            Answers.logCustomEvent(
                withName: "Authentication",
                customAttributes: [
                    "Method" : "Social Network",
                    "Social network" : socialNetwork.name.uppercased(),
                    "Success" : false
                ]
            )
        }
        
    }
}
