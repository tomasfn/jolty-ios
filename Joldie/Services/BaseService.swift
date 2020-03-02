//
//  BaseServices.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/28/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import Alamofire

enum Result<T> {
    case Success(T)
    case Failure(ErrorProtocol)
}

typealias CollectionBlock = (Result<[AnyObject]>) -> Void

class BaseService {
    
    static var headers: [String : String]? {
        return SharedInfo.authHeader
    }
    
    static func showNetworkActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    static func hideNetworkActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
