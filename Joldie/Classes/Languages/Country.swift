//
//  Country.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 6/19/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit

class Country {
    class func currentLanguageCode() -> String? {
        let languageCode = Locale.current.languageCode
        return languageCode
    }
}
