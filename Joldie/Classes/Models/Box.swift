//
//  Box.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 07/12/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import Firebase

class Box: FIRDataObject {
    
    var id: Int = -1
    var name: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    
    required init (snapshot: DataSnapshot) {
        super.init(snapshot: snapshot)
        
        if let data = snapshot.value as? [String: AnyObject] {
            self.id = data["id"] as! Int
            self.name = data["name"] as! String
            self.latitude = data["lat"]! as! Double
            self.longitude = data["lng"]! as! Double
        }
    }
}

extension Box {
    var annotation : BoxAnnotation? {
        get {
            return BoxAnnotation(box: self)
        }
    }
}
