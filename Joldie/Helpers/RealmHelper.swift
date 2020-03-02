//
//  RealmHelper.swift
//  MyWorldCup
//
//  Created by Tomás Fernández on 9/1/18.
//  Copyright © 2018 Tomás Fernández Nuñez. All rights reserved.
//

import UIKit
import RealmSwift

private let realmDataBaseName = "Jolty.realm"

class RealmHelper: NSObject {
    
    class func removeNotification( notificationToken: inout NotificationToken?) {
        guard notificationToken != nil else { return }
        
        notificationToken!.invalidate()
        notificationToken = nil
    }
    
    class func customConfiguration() {
        
        var config = Realm.Configuration(
            schemaVersion: currentSchemaVersion,
            migrationBlock: migrationBlock)
        
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent(realmDataBaseName)
        
        Realm.Configuration.defaultConfiguration = config
        
        _ = try! Realm()
    }
    
}

//MARK: Migrations
extension RealmHelper {
    
    static var currentSchemaVersion: UInt64 {
        return 1
    }
    
    static var migrationBlock: MigrationBlock {
        return { (migration, oldSchemaVersion) in
            if (oldSchemaVersion < currentSchemaVersion) { }
        }
    }
    
}

//MARK: Writters
extension RealmHelper {
    class func write(object: Object!, update: Bool = true) throws {
        let realm = try Realm()
        try realm.write({
            realm.add(object, update: update)
        })
    }
    
    class func writeObjects(objects: [Object], update: Bool = true) throws {
        let realm = try Realm()
        try realm.write({
            realm.add(objects, update: update)
        })
    }
    
    class func delete(object: Object!) throws {
        let realm = try Realm()
        try realm.write({
            realm.delete(object)
        })
    }
    
    class func deleteAllFromClass<T: Object>(objectClass: T.Type) throws {
        let realm = try Realm()
        try realm.write({
            let allObjects = realm.objects(objectClass)
            realm.delete(allObjects)
        })
    }
    
}

//MARK: Readers
extension RealmHelper {
    
    class func getObject<T: Object>(objectClass: T.Type, withID id: String!) throws -> T? {
        let filteredObject = try getObjects(objectClass: objectClass, withFilterPredicate: NSPredicate(format: "id = %@", id)).first
        return filteredObject
    }
    
    class func getObjects<T: Object>(objectClass: T.Type, withFilterPredicate predicate: NSPredicate? = nil) throws -> Results<T> {
        let allObjects = try Realm().objects(objectClass)
        
        if let predicate = predicate {
            return allObjects.filter(predicate)
        } else {
            return allObjects
        }
    }
}

//MARK: Logout
extension RealmHelper {
    class func logOutRoutine() throws {
        let realm = try Realm()
        try realm.write {
            realm.deleteAll()
        }
    }
}

//MARK: Readers
extension RealmHelper {
    
//    class func getCurrentCountry() throws -> Country? {
//        return try getCountries().first
//    }
}

//MARK: Custom writer
extension RealmHelper {
//
//    class func writeCountry(_ country: Country?) throws {
//        let realm = try Realm()
//
//        if let country = country {
//            try realm.write({ () -> Void in
//                realm.add(country, update: true)
//            })
//
//        } else {
//            try realm.write({ () -> Void in
//                realm.delete(realm.objects(Country.self))
//                print("Country erased")
//            })
//        }
//    }
}


