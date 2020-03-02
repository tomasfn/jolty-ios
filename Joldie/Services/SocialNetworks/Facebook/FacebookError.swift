//
//  FacebookError.swift
//  Mostaza
//
//  Created by Tomás Fernández on 31/7/17.
//  Copyright © 2017 Tomás Fernández Nuñez. All rights reserved.
//


import Foundation

enum FacebookError: ErrorProtocol {
    case LoginError
    case LoginCancelled
    case Unknown
    
    var code: Int {
        switch self {
        case .LoginError: return 701
        case .LoginCancelled: return 702
        case .Unknown: return -799
        }
    }
    
    var userInfo: [NSObject : AnyObject] {
        switch self {
        case .LoginError:
            return [NSLocalizedDescriptionKey as NSObject : "Error al loguearse por Facebook" as AnyObject]
        case .LoginCancelled:
            return [NSLocalizedDescriptionKey as NSObject : "Login de Facebook cancelado" as AnyObject]
        case .Unknown:
            return [NSLocalizedDescriptionKey as NSObject : "Error de Facebook desconocido" as AnyObject]
        }
    }
}

