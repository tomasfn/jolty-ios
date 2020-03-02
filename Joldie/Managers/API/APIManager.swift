//
//  APIManager.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/30/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Firebase
import Alamofire
import AlamofireImage
import UIKit
import AlamofireOauth2

typealias APIManagerErrorBlock = (NSError?) -> Void
typealias APIManagerCompletionBlock = (AnyObject?, NSError?) -> Void

typealias APIManagerLoginBlock = (AuthenticationInfo?, NSError?) -> Void

typealias AlamofireCompletionBlock = (AnyObject?, NSError?) -> Void
typealias AlamofireCompletionDataBlock = (Data?, NSError?) -> Void

typealias APIManagerGetUserBlock = (User?, NSError?) -> Void
typealias APIManagerGetBoxesBlock = ([Box]?, NSError?) -> Void

typealias APIManagerGetUserJoltysBlock = ([Jolty]?, NSError?) -> Void

typealias APIManagerGetUserProfileImageBlock = (NSData?, NSError?) -> Void

typealias APIManagerGetImageErrorBlock = (UIImage?, NSError?) -> Void

typealias APIManagerGetDownloadedCouponBlock = (User?, NSError?) -> Void


class APIManager: NSObject {
    
    
    class func getCurrentUserJoltys(completionBlock: @escaping APIManagerGetUserJoltysBlock) {
        
        var Joltys: [Jolty] = []
        
        
        let currentUserId = Auth.auth().currentUser?.uid
//        let ref = Database.database().reference().child("Jolty").queryOrdered(byChild: "helpedUser").queryEqual(toValue: currentUserId)
        
        
        let ref2 = Database.database().reference().child("Jolty").queryOrderedByKey().queryStarting(atValue: currentUserId).queryEnding(atValue: currentUserId)
        
//        queryOrdered(byChild: "saviorUser").queryEqual(toValue: currentUserId)
        
        
//
//        var ref = new Firebase("https://example.firebaseio.com/");
//        ref.orderByKey().startAt("b").endAt("b\uf8ff").on("child_added", function(snapshot) {
//            console.log(snapshot.key());
//        });
        
            // Get Joltys when user was the helped
//            ref.observe(.value, with:{ (snapshot: DataSnapshot) in
//
//                for snap in snapshot.children {
//                    if let dict = snap as? DataSnapshot {
//                        let Jolty = Jolty(snapshot: dict)
//                        Joltys.append(Jolty)
//                    }
//                    firstCallFinish = true
//                }
//
//                if firstCallFinish == true && secondCallFinish == true {
//                    completionBlock?(Joltys, nil)
//                }
//            })
        
            // Get Joltys when user was the saviour
            ref2.observe(.value, with:{ (snapshot: DataSnapshot) in
                
                for snap in snapshot.children {
                    if let dict = snap as? DataSnapshot {
                        let jolty = Jolty(snapshot: dict)
                        Joltys.append(jolty)
                    }
                }
            })
    }
        
    
    class func logInWithUsername(username: String!, password: String!, completionBlock: @escaping APIManagerLoginBlock) {
        
        let basicHeader = [
            "Authorization": "Basic \(base64Credentials)",
            "X-TenantID" : SharedInfo.appId]
        
        let parameters: [String: Any] = [
            "username" : "\(username!)",
            "password" : "\(password!)",
            "grant_type" : "password"]
        
        let url = SharedInfo.baseURL + "/oauth/token"
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: parameters, headers: basicHeader)
            .responseJSON { response in
                
                
                if response.result.error != nil {
                    completionBlock(nil, ErrorManager.serverError())
                    return
                }
                
                let code = response.response?.statusCode
                if code == 200, let value = response.result.value {
                    
                    
                    if let authenticationInfoJSON = value as? [String : AnyObject] {
                        let authenticationInfo = AuthenticationInfo(json: authenticationInfoJSON)
                        completionBlock(authenticationInfo, nil)
                    }
                    
                } else if code == 400 {
                    completionBlock(nil, ErrorManager.apiErrorWithCode(code: code!, andLocalizedDescription: "Email o contraseña inválida"))
                } else {
                    completionBlock(nil, ErrorManager.unknownError())
                }
        }
    }
    
    class func signUp(email: String, password: String, birthdate: String, gender: String, completionBlock: @escaping APIManagerGetUserBlock) {
        
        let parameters = [
            "username" : email,
            "password" : password,
            "birth" : birthdate,
            "gender" : gender,
            ] as [String : Any]
        
        let url = SharedInfo.apiURL + "users/create/"
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: parameters, headers: SharedInfo.tenantHeader )
            .responseJSON { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                guard let code = response.response?.statusCode else {
                    completionBlock(nil, ErrorManager.serverError())
                    return
                }
                
                switch code {
                case 200:
                    if let value = response.result.value {
                        completionBlock(User(JSON: value as! UserJSON), nil)
                    } else {
                        completionBlock(nil, ErrorManager.unknownError())
                    }
                case 402:
                    completionBlock(nil, ErrorManager.apiErrorWithCode(code: code, andLocalizedDescription: "Este usuario ya existe".localized()))
                default:
                    completionBlock(nil, ErrorManager.unknownError())
                }
                
        }
    }
    
    class func logoutCurrentUser(completionBlock: APIManagerCompletionBlock?) {
        
        getFromEndpoint(endpoint: "oauth/revoke-token") { (responseObject, error) in
            if error == nil {
                completionBlock?(responseObject, nil)
            } else {
                completionBlock?(nil, error)
            }
        }
    }
    
    class func getUser(completionBlock: APIManagerGetUserBlock?) {
        
        getFromEndpoint(endpoint: "users/me/") { (responseObject, error) in
            
            if error == nil {
                let user = User(JSON: responseObject as! UserJSON)
                completionBlock?(user, nil)
            } else {
                completionBlock?(nil, error)
            }
        }
    }
    
    class func getJoltyBoxes(fromCity: String, completionBlock: @escaping APIManagerGetBoxesBlock) {
        
        var boxes = [Box]()
        
        let ref = Database.database().reference().child("Boxes").queryOrdered(byChild: "city").queryEqual(toValue: fromCity)
        
        ref.observe(.value, with:{ (snapshot: DataSnapshot) in
            
            for snap in snapshot.children {
                if let dict = snap as? DataSnapshot {
                    let box = Box(snapshot: dict)
                    boxes.append(box)
                }
            }
            
            completionBlock(boxes, nil)
        })

    }
    
    class func updateUser(updateParameters: [String : AnyObject], completionBlock: APIManagerGetUserBlock?) {
        
        patchToEndpoint(endpoint: "users/me/", parameters: updateParameters) { (responseObject, error) in
            
            if error == nil {
                let user = User(JSON: responseObject as! [String : AnyObject])
                completionBlock?(user, nil)
            } else {
                completionBlock?(nil, error)
            }
        }
    }
    
    class func removeUserCoupon(promoCode: String, completionBlock: APIManagerCompletionBlock?) {
        
        let parameters = [
            "promoCode" : promoCode
            ] as [String : Any]
        
        postToEndpoint(endpoint: "coupons/remove/", parameters: parameters as [String : AnyObject]?) { (responseObject, error) in
            
            if error == nil {
                completionBlock?(responseObject, nil)
            } else {
                completionBlock?(nil, error)
            }
        }
    }
    
    class func setPushNotification(receivePush: Bool, completionBlock: APIManagerCompletionBlock?) {
        
        let parameters = [
            "receivePush" : receivePush
            ] as [String : Any]
        
        postToEndpoint(endpoint: "device/subscribe/", parameters: parameters as [String : AnyObject]?) { (responseObject, error) in
            
            if error == nil {
                completionBlock?(responseObject, nil)
            } else {
                completionBlock?(nil, error)
            }
        }
    }
}

extension APIManager {
    class func postToEndpoint(endpoint: String!, parameters: [String : AnyObject]? = nil, showActivityIndicator: Bool = true, completionBlock: AlamofireCompletionBlock?) {
        makeRequestWithMethod(method: .post, toEndpoint: endpoint, withParameters: parameters, showActivityIndicator: showActivityIndicator, completionBlock: completionBlock)
    }
    
    class func patchToEndpoint(endpoint: String!, parameters: [String : AnyObject]? = nil, showActivityIndicator: Bool = true, completionBlock: AlamofireCompletionBlock?) {
        makeRequestWithMethod(method: .patch, toEndpoint: endpoint, withParameters: parameters, showActivityIndicator: showActivityIndicator, completionBlock: completionBlock)
    }
    
    class func getFromEndpoint(endpoint: String!, parameters: [String : AnyObject]? = nil, showActivityIndicator: Bool = true, completionBlock: AlamofireCompletionBlock?) {
        makeRequestWithMethod(method: .get, toEndpoint: endpoint, withParameters: parameters, showActivityIndicator: showActivityIndicator, completionBlock: completionBlock)
    }
    
    /* Edit */
    class func getFromEndpointData(
        endpoint: String!,
        parameters: [String : AnyObject]? = nil,
        showActivityIndicator: Bool = true,
        completionBlock: AlamofireCompletionDataBlock?) {
        
        makeRequestWithMethodData(
            method: .get,
            toEndpoint: endpoint,
            withParameters: parameters,
            showActivityIndicator: showActivityIndicator,
            completionBlock: completionBlock
        )
    }
    
    private class func makeRequestWithMethodData(
        method: Alamofire.HTTPMethod,
        toEndpoint endpoint: String!,
        withParameters parameters: [String : AnyObject]? = nil,
        andHeaders headers: [String : String]? = nil,
        showActivityIndicator: Bool,
        completionBlock: AlamofireCompletionDataBlock?
        ) {
        let url = SharedInfo.apiURL + endpoint
        
        let acceptedContentTypes = [
            "audio/mp3",
            "audio/mpeg",
            "image/png",
            "image/jpeg",
            "application/json",
            "text/html"
        ]
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = showActivityIndicator
        
        Alamofire.request(url, method: method, parameters: parameters, headers: nil).validate(contentType: acceptedContentTypes).responseData { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if response.result.error != nil {
                completionBlock?(nil, ErrorManager.serverError())
                return
            }
            
            if let code = response.response?.statusCode, let value = response.result.value, code == 200 {
                completionBlock?(value, nil)
            } else {
                completionBlock?(nil, ErrorManager.unknownError())
            }
        }
    }
    
    /* End Edit */
    
    private class func makeRequestWithMethod(method: Alamofire.HTTPMethod, toEndpoint endpoint: String!, withParameters parameters: [String : AnyObject]? = nil, andHeaders headers: [String : String]? = nil, showActivityIndicator: Bool, completionBlock: AlamofireCompletionBlock?) {
        
        
        let url = SharedInfo.apiURL + endpoint
        
        let acceptedContentTypes = ["audio/mp3", "audio/mpeg", "image/png", "image/jpeg", "application/json", "text/html"]
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = showActivityIndicator
        print("Alamofire \(url) \(parameters)")
        Alamofire.request(url, method: method, parameters: parameters, headers: nil).validate(contentType: acceptedContentTypes).responseJSON { response in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if response.result.error != nil {
                completionBlock?(nil, ErrorManager.serverError())
                return
            }
            
            if let code = response.response?.statusCode, let value = response.result.value, code == 200 {
                completionBlock?(value as AnyObject?, nil)
            } else {
                completionBlock?(nil, ErrorManager.unknownError())
            }
        }
    }
}
