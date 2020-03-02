//
//  Address.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 6/19/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import RealmSwift

typealias LocationJSON = [String : AnyObject]

class Location: Object {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var latitude: Double = -1
    @objc dynamic var longitude: Double = -1
    @objc dynamic var street: String = ""
    @objc dynamic var number: Double = -1
    @objc dynamic var floor: String?
    @objc dynamic var department: String = ""
    @objc dynamic var zipCode: String = ""
    @objc dynamic var city: Int = -1
    
    convenience init(JSON: LocationJSON?) {
        self.init()
        
        if JSON == nil { return }
        
        id = (JSON?["id"] as! NSNumber).intValue
        latitude = JSON?["latitude"] as! Double
        longitude = JSON?["longitude"] as! Double
        street = JSON?["street"] as! String
        number = JSON?["number"] as! Double
        floor = JSON?["floor"] as? String
        department = JSON?["department"] as! String
        zipCode = JSON?["zip_code"] as! String
        city = (JSON?["city"] as! NSNumber).intValue
    }
    
}

extension Location: ArrayInstanciable {
    
    static func instancesFromJSONArray(jsonArray: [[String : AnyObject]]) -> [Location]? {
        
        var Locations = [Location]()
        
        for aJSON in jsonArray {
            let aLocation = Location(JSON: aJSON)
            Locations.append(aLocation)
        }
        
        return Locations
    }
    
}


