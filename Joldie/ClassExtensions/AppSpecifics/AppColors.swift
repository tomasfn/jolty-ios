//
//  AppColors.swift
//  Jolty
//
//  Created by Tomás Fernández on 28/4/17.
//  Copyright © 2017 Tomás Fernández Nuñez. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func appMainColor() -> UIColor! {
        return UIColor(red:0.96, green:0.73, blue:0.20, alpha:1.0)
    }
    
    class func appMainGreenColor() -> UIColor! {
        return UIColor.init(hexString: "#b2f713")
    }
    
    class func appMainGrayColor() -> UIColor! {
        return UIColor.init(hexString: "#D5D5D5")
    }
    
    class func appFacebookBtnColor() -> UIColor {
        return UIColor(red:0.11, green:0.29, blue:0.65, alpha:1.0)
    }
    
    class func greenColorBattery() -> UIColor {
        return UIColor.init(hexString: "#57d38b")
    }
    
    class func yellowColorBattery() -> UIColor {
        return UIColor.init(hexString: "#F9F871")
    }
    
    class func redColorBattery() -> UIColor {
        return UIColor.init(hexString: "#d36357")
    }
}
