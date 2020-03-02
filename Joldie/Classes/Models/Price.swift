//
//  Price.swift
//  Joldie
//
//  Created by Tomás Fernandez Nuñez on 6/19/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import RealmSwift

typealias PriceJSON = [String : AnyObject]

class Price: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = ""

    convenience init(JSON: [String : AnyObject]) {
        self.init()
        
        name = JSON["name"] as! String

    }
}


extension Price: StandaloneCopiable {
    
    func standaloneCopy() -> Price! {
        
        let standalonePrice = Price()
        standalonePrice.name = name
        
        return standalonePrice
    }
}

extension Price: ArrayInstanciable {
    
    static func instancesFromJSONArray(jsonArray: [[String : AnyObject]]) -> [Price]? {
        
        var prices = [Price]()
        
        for aJSON in jsonArray {
            let aPrice = Price(JSON: aJSON)
            prices.append(aPrice)
        }
        
        return prices
    }
    
}
