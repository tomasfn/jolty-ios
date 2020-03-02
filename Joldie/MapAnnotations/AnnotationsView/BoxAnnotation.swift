//
//  BoxAnnotation.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 07/12/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

class BoxAnnotation: NSObject, MKAnnotation {
    var box : Box!
    
    var coordinate : CLLocationCoordinate2D {
        get {
            let latitude = box.latitude
            let longitude = box.longitude
            let coords = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            return coords
        }
    }
    
    var title : String? {
        get { return box.name }
    }
    
    var subtitle : String? {
        get { return box.name }
    }
    
    init?(box: Box!) {
        super.init()
        
        self.box = box
    }
    
    override init() {
        assertionFailure("init() not implemented, use init('box')")
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary as? [String : String])
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
}
