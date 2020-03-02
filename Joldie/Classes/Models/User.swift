//
//  User.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/22/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import RealmSwift

typealias UserJSON = [String : AnyObject]

enum UserStatus: String {
    case Free = "free"
    case Requested = "requested"
    case Committed = "committed"
    case Busy = "busy"
}

enum CurrentBatteryMode {
    case perfect
    case veryGood
    case ok
    case alive
    case dying
    case none
}

class User: Object {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var email: String?
    @objc dynamic var temporalPassword: String?
    @objc dynamic var name: String?
    @objc dynamic var lastName: String?
    @objc dynamic var gender: String = ""
    @objc dynamic var birthdate: String = ""
    @objc dynamic var currentAddress: String = ""
    @objc dynamic var selectedRange: Int = -1
    @objc dynamic var lastLocation: Location!
    @objc dynamic var receivePush: Bool = false
    @objc dynamic var qualification: Double = -1
    @objc dynamic var isChargerSharer: Bool = false
    
    //add Joltys here
    
    convenience init(JSON: [String : AnyObject]) {
        self.init()
        
        id = (JSON["id"] as! NSNumber).intValue
        email = JSON["username"] as? String
        temporalPassword = JSON["temporal_password"] as? String
        name = JSON["name"] as? String
        gender = JSON["gender"] as! String
        
        if let birth = (JSON["birth"] as? String) {
            birthdate = birthdate.convertFormatOfDate(date: birth, originalFormat: "yyyy-MM-dd", destinationFormat: "dd/MM/yy")
        }
        
        if let sRange = (JSON["age_range"] as? NSNumber)?.intValue {
            selectedRange = sRange
        }
        
        if let qualific = (JSON["qualification"] as? NSNumber)?.doubleValue {
            qualification = qualific
        }
        
        
        if let rPush = JSON["receivePush"] as? Bool {
            receivePush = rPush
        }
        
        if let chargerSharer = JSON["isChargerSharer"] as? Bool {
            isChargerSharer = chargerSharer
        }
        
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    class var isLogged: Bool {
        return currentUser != nil ? true : false
    }
    
    
    class var BatteryState: CurrentBatteryMode {
        
        let batteryPercentage =  CurrentBattery.batteryLevelPercentage()
        
        switch batteryPercentage {
        case 90...100:
            return .perfect
        case 60...90:
            return .veryGood
        case 30...60:
            return .ok
        case 15...30:
            return .alive
        case 0...15:
            return .dying
        default:
            print("Out of the range")
        }
        
        
        return .none
    }
    
    class func BatteryStr() -> String {
        let batteryPercentage =  CurrentBattery.batteryLevelPercentage()
            let state: String!
            switch batteryPercentage {
            case 90...100:
                state = "perfect".localized()
            case 60...90:
                state = "great".localized()
            case 50...60:
                state = "very good".localized()
            case 30...50:
                state = "good".localized()
            case 15...30:
                state = "normal".localized()
            case 0...15:
                state = "running out of battery".localized()
            default:
                state = ""
            }
            
            return state
    }
    
    class func logout() -> Bool {
        guard isLogged == true else {
            debugPrint("No logged user")
            return false
        }
        
        CredentialManager.shared.currentCredential = nil
        //   currentUser?.socialNetwork?.logout()
        currentUser = nil
        
        do {
            try RealmHelper.logOutRoutine()
        } catch {
            return false
        }
        
        return true
    }
    
    fileprivate static var sharedUser: User?
    static var currentUser: User? {
        get {
            if sharedUser == nil {
                sharedUser = try! Realm().objects(User.self).first
            }
            
            return sharedUser
        }
        
        set {
            
            let realm = try! Realm()
            try! realm.write({
                if let newUser = newValue {
                    realm.add(newUser, update: true)
                } else {
                    realm.delete(realm.objects(User.self))
                }
            })
            
            sharedUser = newValue
        }
    }
    
}
