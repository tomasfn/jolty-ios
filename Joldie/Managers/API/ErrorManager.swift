//
//  ErrorManager.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/30/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation

class ErrorManager {
    
    static let APIErrorDomain = "ar.com.candoit.APIError"
    
    class func unknownError() -> NSError {
        return apiErrorWithCode(code: -999, andLocalizedDescription: "Ups algo falló, intentá cerrando el app y volviendola a abrir, gracias")
    }
    
    class func noConnectionError() -> String {
        return "Comprueba tu conexión a Internet y vuelve a intentarlo"
    }
    
    class func serverError() -> NSError {
        return apiErrorWithCode(code: -999, andLocalizedDescription: "Comprueba tu conexión a Internet y vuelve a intentarlo")
    }
    
    class func downloadCouponLimitReachError() -> NSError {
        return apiErrorWithCode(code: 226, andLocalizedDescription: "Has alcanzado tu límite diario de descarga de este cupón.")
    }
    
    class func apiErrorWithCode(code: Int, andLocalizedDescription localizedDescription: String) -> NSError {
        return NSError(domain: APIErrorDomain, code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription.localized()])
    }
}

