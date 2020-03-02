//
//  UserAnnotation.swift
//  Jolty
//
//  Created by MacMini03 on 17/09/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

class UserAnnotation: NSObject, MKAnnotation {
    var user : User!
    
    var coordinate : CLLocationCoordinate2D {
        get {
            let latitude = user.lastLocation.latitude
            let longitude = user.lastLocation.longitude
            let coords = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            return coords
        }
    }
    
    var title : String? {
        get { return user.name }
    }
    
    var subtitle : String? {
        get { return user.lastName }
    }
    
    init?(user: User!) {
        super.init()
        
        self.user = user
    }
    
    override init() {
        assertionFailure("init() not implemented, use init('attraction')")
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary as? [String : String])
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
}
