//
//  SharedInfo.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/28/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation

enum SharedInfo {
    
    // Choose AppId here
    static let appId: String = "4"
    
    static let firebaseFcmSendUrl = "https://fcm.googleapis.com/fcm/send"
    
    static let firebaseWebApiKey = "AAAAex4zfIc:APA91bH2OjfI7wa2hcjaJcgIObVjS51vFETD9-6AN1L7eRVI8xKKeFZSLMQwxCZy56CKOenBo85sTwxyXWCLrDasVzp5V8ADKpVOMA13bNZbqST6CLmpXzJt3iLvaHATXlEN9h_sgKMn"
    
    static let clientSecret: String = "0IdXyCicbjzWslWKN8cb5yLQegYMM1ZalHTS9XeqNA6O1Pm6jNQMKATFrSkAHrmoCxPQlAYf0HPy9vmiUNE6Bql3wZlAb8rlnHy7O88hp7JeWR7TEkQXD45cUVf3c9ZA"
    
    static let baseURL: String = {
        switch environment {
        case .TEST:
            return "https://joldie-tlm.firebaseio.com/"
        case .PROD:
            return "https://joldie-tlm.firebaseio.com/"
        }
    }()
    
    static let apiURL = baseURL //+ "api/"
    
    static var tenantHeader: [String : String]? {
        return ["X-TenantID" : appId]
    }
    
    static var authHeader: [String : String]? {
        if let credential = CredentialManager.shared.currentCredential, let base64Encoded = "\(credential.userId):\(credential.accessToken)".base64 {
            return ["Authorization" : ("Basic " + base64Encoded),
                    "X-TenantID" : appId]
        } else {
            return nil
        }
    }
    
    static var tokenHeader: [String : String]? {
        if let credential = CredentialManager.shared.currentCredential {
            return ["Authorization" : ("Bearer " + credential.accessToken),
                    "X-TenantID" : appId]
        } else {
            return nil
        }
    }
}
