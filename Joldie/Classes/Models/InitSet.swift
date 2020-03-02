//
//  InitSet.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/27/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import RealmSwift

typealias InitSetJSON = [String : AnyObject]

class InitSet: Object {
    
    @objc dynamic var appTitle: String = ""
    @objc dynamic var backHexaColor: String = ""
    @objc dynamic var fontHexaColor: String = ""
    @objc dynamic var logoUrl: String = ""
    @objc dynamic var iconUrl: String = ""
    
    @objc dynamic var aboutDescription: String = ""

    convenience init(JSON: [String : AnyObject]) {
        self.init()
        
        appTitle = JSON["appTitle"] as! String
        backHexaColor = JSON["backHexaColor"] as! String
        fontHexaColor = JSON["fontHexaColor"] as! String
        logoUrl = JSON["logoUrl"] as! String
        iconUrl = JSON["iconUrl"] as! String
        
        if Country.currentLanguageCode() == "es" {
            aboutDescription = JSON["description_es"] as! String
        } else {
            aboutDescription = JSON["description_en"] as! String
        }
        
    }
    
    override class func primaryKey() -> String? {
        return "appTitle"
    }
}

extension InitSet: StandaloneCopiable {
    
    func standaloneCopy() -> InitSet! {
        
        let standaloneCity = InitSet()
        standaloneCity.appTitle = appTitle
        standaloneCity.backHexaColor = backHexaColor
        standaloneCity.fontHexaColor = fontHexaColor
        standaloneCity.logoUrl = logoUrl
        standaloneCity.iconUrl = iconUrl
        
        return standaloneCity
    }
}

extension InitSet: ArrayInstanciable {
    
    fileprivate static var sharedInitSet: InitSet?
    static var currentInitSet: InitSet? {
        get {
            if sharedInitSet == nil {
                
                do {
                    sharedInitSet = try Realm().objects(InitSet.self).first
                } catch {
                    // handle exception
                }
            }
            
            return sharedInitSet
        }
        
        set {
            
            do {
                let realm = try Realm()
                
                try realm.write({
                    if let newInitSet = newValue {
                        realm.add(newInitSet, update: true)
                    } else {
                        realm.delete(realm.objects(InitSet.self))
                    }
                })
                
                sharedInitSet = newValue
                
            } catch {
                // handle exception
            }
        }
    }
    
    static func instancesFromJSONArray(jsonArray: [[String : AnyObject]]) -> [InitSet]? {
        
        var InitialSettings = [InitSet]()
        
        for aJSON in jsonArray {
            let aInitSet = InitSet(JSON: aJSON)
            InitialSettings.append(aInitSet)
        }
        
        return InitialSettings
    }
    
}
