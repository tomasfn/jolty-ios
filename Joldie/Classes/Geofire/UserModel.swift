//
//  UserModel.swift
//  Jolty
//
//  Created by MacMini03 on 05/09/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import FacebookCore
import ZAlertView

class UserModel: NSObject {
    
    //MARK: Properties
    let name: String
    let lastName: String
    let email: String
    let id: String
    let currentBatterylvl: String
    var profilePic: UIImage
    var selectedRange: Int = 200
    var latitude: String? = ""
    var longitude : String? = ""
    var qualification: Double = 0
    var credits: String = ""
    var currentFcmToken: String = ""
    var isChargerSharer: Bool = true
    
    
    //MARK: Methods
    class func registerUser(withName: String, withLastName: String, email: String, password: String, profilePic: UIImage, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error == nil {
                user?.user.sendEmailVerification(completion: nil)
                let storageRef = Storage.storage().reference().child("usersPics").child(user!.user.uid)
                let imageData = UIImageJPEGRepresentation(profilePic, 0.5)
                storageRef.putData(imageData!, metadata: nil, completion: { (metadata, err) in
                    if err == nil {
                        
                        var path: String = ""
                        // Fetch the download URL
                        storageRef.downloadURL { url, error in
                            if error != nil {
                                print("there was an error tho")
                            } else {
                                path = (url?.absoluteString)!
                                
                                // this is a maybe rustic update to upload profile pic url
                                let value = ["profilepic_url": path]
                                Database.database().reference().child("Users").child((user?.user.uid)!).child("user_details").updateChildValues(value, withCompletionBlock: { (errr, _) in
                                    if errr == nil {
                                        let userInfo = ["name": withName, "last_name": withLastName, "email": email, "profilepic_url": path]
                                        UserDefaults.standard.set(userInfo, forKey: "userDetails")
                                        completion(true)
                                    }
                                })
                            }
                        }
                        
                        let values = ["name": withName, "last_name": withLastName, "email": email, "profilepic_url": path, "current_batteryLvl": "\(CurrentBattery.batteryLevelPercentage())", "share_lightning": "true", "selected_range": "200", "qualification": "0", "credits": "25", "currentFcmToken" : FirebasePushNotificationsManager.currentToken()]
                        Database.database().reference().child("Users").child((user?.user.uid)!).child("user_details").updateChildValues(values, withCompletionBlock: { (errr, _) in
                            if errr == nil {
                                let userInfo = ["name": withName, "last_name": withLastName, "email": email, "profilepic_url": path]
                                UserDefaults.standard.set(userInfo, forKey: "userDetails")
                                completion(true)
                            }
                        })
                    }
                })
            }
            else {
                
                ZAlertView(title: "Oops...".localized(), message: error!.localizedDescription, closeButtonText: "Ok".localized()) { (alert) in
                    alert.dismissAlertView()
                    }.show()

                completion(false)
            }
        })
    }
    
    
    class func loginUserWithCredentials(credential: AuthCredential, completion: @escaping (Bool) -> Swift.Void) {
        
        let currentProvider = credential.provider
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                
                ZAlertView(title: "Oops...".localized(), message: error.localizedDescription, closeButtonText: "Ok".localized()) { (alert) in
                    alert.dismissAlertView()
                    }.show()
                
                completion(false)
            }
            
            if currentProvider.contains("google") {
                let currentGUser = GIDSignIn.sharedInstance().currentUser.profile
                saveNewUserDataIntoFirebase(name: currentGUser!.givenName, lastName: currentGUser!.familyName, email: currentGUser!.email, profilePicUrl: (currentGUser?.imageURL(withDimension: 400).absoluteString)!, userId: (Auth.auth().currentUser?.uid)!, completion: { (success) in
                    if success {
                        completion(true)
                    }
                })
            } else if currentProvider.contains("facebook") {
                
                let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,last_name,email, picture.type(large)"], tokenString: AccessToken.current?.authenticationToken, version: nil, httpMethod: "GET")
                
                req?.start(completionHandler: { (connection, result, error) in
                    if(error == nil)
                    {
                        if
                            let fields = result as? [String:Any],
                            let firstName = fields["first_name"] as? String,
                            let lastName = fields["last_name"] as? String,
                            let email = fields["email"] as? String
                        {
                            let imageUrl = "http://graph.facebook.com/\(FBSDKAccessToken.current().userID!)/picture?type=large"
                            saveNewUserDataIntoFirebase(name: firstName, lastName: lastName, email: email, profilePicUrl: imageUrl, userId: (Auth.auth().currentUser?.uid)!, completion: { (success) in
                                if success {
                                    completion(true)
                                }
                            })
                        }
                    }
                    else
                    {
                        
                        ZAlertView(title: "Oops...".localized(), message: error?.localizedDescription, closeButtonText: "Ok".localized()) { (alert) in
                            alert.dismissAlertView()
                            }.show()
                    }
                })
            }
        }
    }
    
    class func loginUser(withEmail: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            if error == nil {
                let userInfo = ["email": withEmail, "password": password]
                UserDefaults.standard.set(userInfo, forKey: "userDetails")
                completion(true)
            } else {
                
                ZAlertView(title: "Oops...".localized(), message: error!.localizedDescription, closeButtonText: "Ok".localized()) { (alert) in
                    alert.dismissAlertView()
                    }.show()

                completion(false)
            }
        })
    }
    
    class func logOutUser(completion: @escaping (Bool) -> Swift.Void) {
        do {
            GIDSignIn.sharedInstance()?.signOut()
            FBSDKLoginManager().logOut()
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "userDetails")
            UserDefaults.standard.removeObject(forKey: "guestDetails")
            UserDefaults.standard.removeObject(forKey: "guestId")
            completion(true)
        } catch _ {
            completion(false)
        }
    }
    
    class func isChargerSharer(newState: String) {
        
        if Auth.auth().currentUser != nil {
        Database.database().reference().child("Users").child((Auth.auth().currentUser!.uid)).child("user_details").child("share_lightning").setValue(newState)
            var userInfo = UserDefaults.standard.dictionary(forKey: "userDetails")
            userInfo?.updateValue(newState, forKey: "share_lightning")
            UserDefaults.standard.set(userInfo, forKey: "userDetails")
        }
    }
    
    class func info(forUserID: String, completion: @escaping (UserModel) -> Swift.Void) {
        Database.database().reference().child("Users").child(forUserID).child("user_details").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                
                
                //
                let name = data["name"] ?? ""
                let lastName = data["last_name"] ?? ""
                let email = data["email"] ?? ""
                let currentBatteryLvl = data["current_batteryLvl"] ?? ""
                let isChargerSharer = data["share_lightning"] ?? ""
                let selectedRange = data["selected_range"] ?? ""
                let qualification = data["qualification"] ?? ""
                let credits = data["credits"] ?? ""
                let currentFcmToken = data["currentFcmToken"] ?? ""
                let link = URL.init(string: data["profilepic_url"] ?? "")
                let latitude = data["current_latitude"]
                let longitude = data["current_longitude"]
                
                if forUserID == Auth.auth().currentUser?.uid {
                    UserDefaults.standard.set(data, forKey: "userDetails")
                }
                
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        let user = UserModel.init(name: name, lastName: lastName, email: email, currentBatterylvl: currentBatteryLvl, id: forUserID, profilePic: profilePic!, latitude: latitude , longitude:longitude, isChargerSharer: Bool(isChargerSharer)!, selectedRange: Int(selectedRange)!, qualification: Double(qualification)!, credits: credits, currentFcmToken: currentFcmToken)
                        completion(user)
                    }
                }).resume()
            }
        })
    }
    
    class func guestInfo(forGuestID: String, completion: @escaping (UserModel) -> Swift.Void) {
        Database.database().reference().child("Users").child(forGuestID).child("user_details").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let data = snapshot.value as? [String: String] {
                
                let name = data["name"] ?? ""
                let lastName = data["last_name"] ?? ""
                let email = data["email"] ?? ""
                let currentBatteryLvl = data["current_batteryLvl"] ?? ""
                let isChargerSharer = data["share_lightning"] ?? ""
                let selectedRange = data["selected_range"] ?? ""
                let qualification = data["qualification"] ?? ""
                let credits = data["credits"] ?? ""
                let currentFcmToken = data["currentFcmToken"] ?? ""
                let link = URL.init(string: data["profilepic_url"] ?? "")
                let latitude = data["current_latitude"]
                let longitude = data["current_longitude"]
                
                UserDefaults.standard.set(data, forKey: "guestDetails")
                UserDefaults.standard.set(forGuestID, forKey: "guestId")
                
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        let user = UserModel.init(name: name, lastName: lastName, email: email, currentBatterylvl: currentBatteryLvl, id: forGuestID, profilePic: profilePic!, latitude: latitude , longitude:longitude, isChargerSharer: Bool(isChargerSharer)!, selectedRange: Int(selectedRange)!, qualification: Double(qualification)!, credits: credits, currentFcmToken: currentFcmToken)
                        completion(user)
                    }
                }).resume()
            }
        })
    }
    
    class func downloadAllUsers(exceptID: String, completion: @escaping (UserModel) -> Swift.Void) {
        Database.database().reference().child("Users").observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            let data = snapshot.value as! [String: Any]
            let credentials = data["user_details"] as! [String: String]
            if id != exceptID {
                let name = credentials["name"]!
                let lastName = credentials["last_name"]!
                let currentBatteryLvl = credentials["current_batteryLvl"]!
                let isChargerSharer = credentials["sharing_lightning"]!
                let selectedRange = credentials["selected_range"]!
                let email = credentials["email"]!
                let qualification = credentials["qualification"]!
                let credits = credentials["credits"]!
                let latitude = credentials["current_latitude"]
                let longitude = credentials["current_longitude"]
                let currentFcmToken = credentials["currentFcmToken"]
                let link = URL.init(string: credentials["profilepic_url"]!)
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        let user = UserModel.init(name: name, lastName: lastName, email: email, currentBatterylvl: currentBatteryLvl, id: id, profilePic: profilePic!, latitude: latitude! , longitude:longitude!, isChargerSharer: Bool(isChargerSharer)!, selectedRange: Int(selectedRange)!, qualification: Double(qualification)!, credits: credits, currentFcmToken: currentFcmToken!)
                        completion(user)
                    }
                }).resume()
            }
        })
    }
    
    class func checkUserVerification(completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().currentUser?.reload(completion: { (_) in
            let status = (Auth.auth().currentUser?.isEmailVerified)!
            completion(status)
        })
    }
    
    class func saveNewUserDataIntoFirebase(name: String, lastName: String, email: String, profilePicUrl: String, userId: String, completion: @escaping (Bool) -> Swift.Void) {
        
        let values = ["name": name, "last_name": lastName, "email": email, "profilepic_url": profilePicUrl, "current_batteryLvl": "\(CurrentBattery.batteryLevelPercentage())", "share_lightning": "true", "selected_range": "200", "qualification": "0", "credits": "25", "currentFcmToken" : FirebasePushNotificationsManager.currentToken()]
        Database.database().reference().child("Users").child(userId).child("user_details").updateChildValues(values, withCompletionBlock: { (errr, _) in
            if errr == nil {
                completion(true)
            }
        })
    }

    
    //MARK: Inits
    init(name: String, lastName: String, email: String, currentBatterylvl: String, id: String, profilePic: UIImage , latitude:String?, longitude:String?, isChargerSharer: Bool, selectedRange: Int, qualification: Double, credits: String, currentFcmToken: String) {
        self.name = name
        self.lastName = lastName
        self.email = email
        self.currentBatterylvl = currentBatterylvl
        self.id = id
        self.profilePic = profilePic
        self.isChargerSharer = isChargerSharer
        self.selectedRange = selectedRange
        self.qualification = qualification
        self.currentFcmToken = currentFcmToken
        self.credits = credits
        self.latitude = latitude
        self.longitude = longitude
    }
}

class UserModelShared {
    
    class func saveGuestUserInfi() -> () {
        
    }
    
    class func currentGuestUser() -> [String: Any] {
        let userInfo = UserDefaults.standard.dictionary(forKey: "guestDetails")
        return userInfo!
    }
    
    class func currentUser() -> [String: Any] {
        let userInfo = UserDefaults.standard.dictionary(forKey: "userDetails")
        return userInfo!
    }
    class func currentUserData(attribute: String) -> String! {
        
        if Auth.auth().currentUser != nil {
        
        let userInfo = UserDefaults.standard.dictionary(forKey: "userDetails")
            
        switch attribute {
        case "name":
            return userInfo!["name"] as? String
        case "credits":
            return userInfo!["credits"] as? String
        case "last_name":
            return userInfo!["last_name"] as? String
        case "email":
            return userInfo!["email"] as? String
        case "current_batteryLvl":
            return userInfo!["current_batteryLvl"] as? String
        case "share_lightning":
            return userInfo!["share_lightning"] as? String
        case "selected_range":
            return userInfo!["selected_range"] as? String
        case "qualification":
            return userInfo!["qualification"] as? String
        case "profilepic_url":
            return userInfo!["profilepic_url"] as? String
        case "current_latitude":
            return userInfo!["current_latitude"] as? String
        case "current_longitude":
            return userInfo!["current_longitude"] as? String
        default:
            return " "
        }
            
        } else {
            
            switch attribute {
            case "credits":
                return "0"
            case "share_lightning":
                return "true"
            case "selected_range":
                return "200"
            case "profilepic_url":
                return ""
            default:
                return " "
            }
            
        }
    }
    
    class func currentGuestUserData(attribute: String) -> String! {
        
        if let userInfo = UserDefaults.standard.dictionary(forKey: "guestDetails") {
            
            switch attribute {
            case "name":
                return userInfo["name"] as? String
            case "credits":
                return userInfo["credits"] as? String
            case "last_name":
                return userInfo["last_name"] as? String
            case "email":
                return userInfo["email"] as? String
            case "current_batteryLvl":
                return userInfo["current_batteryLvl"] as? String
            case "share_lightning":
                return userInfo["share_lightning"] as? String
            case "selected_range":
                return userInfo["selected_range"] as? String
            case "qualification":
                return userInfo["qualification"] as? String
            case "profilepic_url":
                return userInfo["profilepic_url"] as? String
            case "current_latitude":
                return userInfo["current_latitude"] as? String
            case "current_longitude":
                return userInfo["current_longitude"] as? String
            default:
                return ""
            }
            
        } else {
            
            switch attribute {
            case "credits":
                return "0"
            case "share_lightning":
                return "true"
            case "selected_range":
                return "200"
            case "profilepic_url":
                return ""
            default:
                return ""
            }
            
        }
    }
}



