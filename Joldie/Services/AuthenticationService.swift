//
//  AuthenticationService.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/28/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import Alamofire

typealias AuthenticationCompletionBlock = (Result<AuthenticationInfo>) -> Void
typealias AuthenticationStepBlock = (AuthenticationStep) -> Void
enum AuthenticationStep {
    case SocialNetwork
    case Server
}

var afManager = SessionManager()

final class AuthenticationService: BaseService {
    
    class func authenticateWithSocialNetwork(socialNetwork: SocialNetwork, stepBlock: AuthenticationStepBlock?, completionBlock: @escaping AuthenticationCompletionBlock) {
        stepBlock?(.SocialNetwork)
        
        socialNetwork.login(completion: { (loginResult) in
            
            let authBlock: AuthenticationCompletionBlock = { (authenticationResult) in
                switch(authenticationResult) {
                case .Success(let authInfo):
                    // Create and Store the credential
                    let credential = Credential(userId: "", accessToken: authInfo.access_token, refreshToken: authInfo.refresh_token, expiresIn: authInfo.expires_in)
                    CredentialManager.shared.currentCredential = credential
                    
                    AnswersHelper.logAuthenticationResult(authInfo: authInfo, fromSocialNetwork: socialNetwork)
                    
                case .Failure(_):
                    AnswersHelper.logAuthenticationResult(authInfo: nil, fromSocialNetwork: socialNetwork)
                }
                
                completionBlock(authenticationResult)
            }
            
            switch loginResult {
            case .Failure(let errorProtocol):
                completionBlock(Result.Failure(errorProtocol))
                
            case .Success(let loginInfo):
                stepBlock?(.Server)
                
                switch socialNetwork.identifier {
                case .Facebook:
                    guard let facebookLoginInfo = loginInfo as? FacebookLoginInfo else {
                        debugPrint("'loginInfo' is not a FacebookLoginInfo")
                        completionBlock(.Failure(NetworkControllerError.LoginError))
                        return
                    }
                    
                    authenticateWithFacebook(loginInfo: facebookLoginInfo, completionBlock: authBlock)
                }
            }
        })
    }
    
    class func authenticateWithFacebook(loginInfo: FacebookLoginInfo, completionBlock: @escaping AuthenticationCompletionBlock) {
        let endpoint = SharedInfo.apiURL + "login/facebook/"
        
        let genderLetter: String
        if loginInfo.gender == "male" {
            genderLetter = "M"
        } else {
            genderLetter = "F"
        }
        
        let params = [
            "userID" : loginInfo.userID,
            "userToken" : loginInfo.accessToken,
            "email" : loginInfo.email,
            "gender" : genderLetter,
            "ageRange" : loginInfo.ageRange
        ]
        
        authenticate(endpoint: endpoint, parameters: params as [String : AnyObject], completionBlock: completionBlock)
    }
    
    
    class func authenticate(endpoint: String, parameters: [String : AnyObject], completionBlock: @escaping AuthenticationCompletionBlock) {
        showNetworkActivityIndicator()
        
        afManager.request(endpoint, method: .post, parameters: parameters)
            .validate()
            .responseJSON { (response) in
                hideNetworkActivityIndicator()
                
                switch(response.result) {
                case .success(let value):
                    
                    // be aware, bad practice of userID and userToken significance
                    let authenticationInfoJSON = [
                        "access_token":"\(parameters["email"]!)",
                        "refresh_token":"\(parameters["userToken"]!)",
                        "expires_in" : Double(0)
                        ] as [String : Any]
                    
                    let authenticationInfo = AuthenticationInfo(json: authenticationInfoJSON as [String : AnyObject])
                    
                    completionBlock(.Success(authenticationInfo))
                    
                case .failure(_):
                    completionBlock(.Failure(NetworkControllerError.LoginError))
                }
        }
    }
    
    class func refreshAccessToken(credentials: Credential, invalidateOldToken invalidate: Bool, completionBlock: @escaping (Credential?) -> Void) {
        
        let refreshToken = CredentialManager.shared.currentCredential?.refreshToken
        
        let parameters: [String: Any] = [
            "refresh_token" : "\(refreshToken!)",
            "grant_type" : "refresh_token"]
        
        let url = SharedInfo.baseURL + "/oauth/token"
        
        showNetworkActivityIndicator()
        
        let basicHeader = [
            "Authorization": "Basic \(base64Credentials)",
            "X-TenantID" : SharedInfo.appId]
        
        afManager.request(url, method: .post, parameters: parameters, headers: basicHeader)
            .validate()
            .responseJSON { (response) in
                hideNetworkActivityIndicator()
                
                switch response.result {
                case .success(let value):
                    
                    if let dict = value as? [String : AnyObject],
                        let newAccessToken = dict["access_token"] as? String,
                        let newExpiresIn = dict["expires_in"] as? NSNumber  {
                        
                        credentials.accessToken = newAccessToken
                        credentials.expiresIn = TimeInterval(newExpiresIn.doubleValue)
                        
                        completionBlock(credentials)
                        
                    } else {
                        completionBlock(nil)
                    }
                    
                case .failure(_):
                    completionBlock(nil)
                    
                    CredentialManager.shared.currentCredential = nil
                    User.currentUser = nil
                    
                }
                
        }
        
    }
}
