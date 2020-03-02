//
//  MessageManager.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 03/09/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit

class MessageManager: NSObject {
    
    static var sharedManager = MessageManager()
    
    @objc dynamic var newTextMessage: Bool = false
    @objc dynamic var newAudioMessage: Bool = false
    
    func clear() {
        newTextMessage = false
        newAudioMessage = false
    }
    
}

