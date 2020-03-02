//
//  Facebook.swift
//  Mostaza
//
//  Created by Tomás Fernández on 31/7/17.
//  Copyright © 2017 Tomás Fernández Nuñez. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class Facebook: SocialNetwork {
    
    var identifier: SNIdentifier { return .Facebook}
    var name: String { return "Facebook" }
    var image: UIImage { return UIImage.facebook() }
    
    func login(completion: @escaping SNLoginResultBlock) {
        
        LoginManager().logIn(readPermissions: [ .publicProfile, .email, .custom("user_birthday")], viewController: nil) { (loginResult) in
            
            switch loginResult {
            case .failed(_):
                completion(.Failure(FacebookError.LoginError))
                
            case .cancelled:
                completion(.Failure(FacebookError.LoginCancelled))
                
            case .success(_, _, let accessToken):
                
                let params = ["fields" : "email, gender, age_range, birthday"]
                let graphRequest = GraphRequest(graphPath: "me", parameters: params)
                graphRequest.start {
                    (urlResponse, requestResult) in
                    
                    switch requestResult {
                    case .failed(let error):
                        print("error in graph request:", error)
                        break
                    case .success(let graphResponse):
                        if let responseDictionary = graphResponse.dictionaryValue {
                            
                            let email = responseDictionary["email"] as! String
                            let gender = responseDictionary["gender"] as! String
                            let birthDate = responseDictionary["birthday"] as? String
                            
                            let ageRange = 21
                            
                            let facebookLoginInfo = FacebookLoginInfo(userID: accessToken.userId!, accessToken: accessToken.authenticationToken, email: email, gender: gender, ageRange: String(ageRange), birth: birthDate)
                            
                            completion(.Success(facebookLoginInfo))
                        }
                    }
                }
            }
        }
    }
    
    func logout() {
        LoginManager().logOut()
    }
    
}

extension Facebook: BackendTypable {
    
    static var backendType: String {
        return "facebook"
    }
    
}

