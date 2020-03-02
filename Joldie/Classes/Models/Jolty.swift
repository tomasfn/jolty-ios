//
//  Jolty.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 6/19/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import Firebase

class Jolty: FIRDataObject {
    
    var start: String = ""
    var end: String? = ""
    var helpedUserId: String = ""
    var saviourUserId: String = ""
    
    required init (snapshot: DataSnapshot) {
        super.init(snapshot: snapshot)
        
        if let data = snapshot.value as? [String: AnyObject] {
            self.start = data["start"] as! String
            //            self.end = data["end"]! as String
            self.helpedUserId = data["helpedUser"]! as! String
            self.saviourUserId = data["saviourUser"]! as! String
        }
    }
}
