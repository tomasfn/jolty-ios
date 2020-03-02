//
//  SocialNetworks.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/28/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit

typealias SNLoginResultBlock = (Result<SNBasicLoginInfo>) -> Void

enum SNIdentifier {
    case Facebook
}

// Factory Method, acording to: https://github.com/ochococo/Design-Patterns-In-Swift
class SNFactory {
    class func socialNetworkForIdentifier(identifier: SNIdentifier) -> SocialNetwork {
        
        switch identifier {
        case .Facebook: return Facebook()
        }
    }
}

protocol SocialNetwork {
    var identifier: SNIdentifier { get }
    var name: String { get }
    var image: UIImage { get }
    
    func login(completion: @escaping SNLoginResultBlock)
    func logout()
}
