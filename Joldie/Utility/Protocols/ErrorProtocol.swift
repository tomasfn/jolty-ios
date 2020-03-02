//
//  ErrorProtocol.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/28/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit

protocol ErrorProtocol {
    var userInfo: [NSObject : AnyObject] { get }
    var code: Int { get }
}

extension ErrorProtocol {
    var domain: String { return Bundle.main.bundleIdentifier! + ".\(String(describing: self))" }
    
    var error: NSError {
        return NSError(domain: domain, code: code, userInfo: userInfo as! [String : Any])
    }
}
