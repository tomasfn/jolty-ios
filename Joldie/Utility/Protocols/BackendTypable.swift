//
//  BackendType.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/28/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation

protocol BackendTypable {
    
    static var backendType: String { get }
    
}

extension BackendTypable {
    var backendType: String {
        return Self.backendType
    }
}
