//
//  AppInitSetConfig.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/27/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit

class AppInitSetConfig {
    
    class func appTitle() -> String? {
        let appTitle = InitSet.currentInitSet?.appTitle
        return appTitle
    }
    
    class func appBackColor() -> UIColor {
        //TODO: Set default color correctly
        var backColor = UIColor.init(hexString: "#57A0D3")
        if let setting = InitSet.currentInitSet {
            backColor = hexStringToUIColor(hex: setting.backHexaColor)
        }
        return backColor
    }
    
    class func appFontColor() -> UIColor {
        var fontColor = UIColor.white
        if let setting = InitSet.currentInitSet {
            fontColor = hexStringToUIColor(hex: setting.fontHexaColor)
        }
        return fontColor
    }
        
    class func appLogoImage() -> UIImage {
        //returns PNG
        let image: UIImage!
        
        if InitSet.currentInitSet != nil {
            let logoUrl = InitSet.currentInitSet!.logoUrl
            let url = URL(string: logoUrl)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            image = UIImage(data: data!)
        }
        else {
            image = UIImage.init()
        }
        
        return image
    }
    
    class func appLogoUrl() -> String? {
        //returns PNG
        var str : String?
        
        if InitSet.currentInitSet != nil {
            if let settings = InitSet.currentInitSet {
                str = SharedInfo.apiURL +  settings.logoUrl
            }
        }
        
        return str
    }
    
    class func appIconUrl() -> UIImage {
        //returns SVG
        
        let iconUrl = SharedInfo.apiURL + InitSet.currentInitSet!.iconUrl
        let image: UIImage!
        
        let url = URL(string: iconUrl)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        image = UIImage(data: data!)
        
        return image
        
    }
}

//class CustomPlacerPicker: TCPickerViewThemeType {
//
//    var doneBackgroundColor: UIColor
//    var titleColor: UIColor
//    var headerBackgroundColor: UIColor
//    var titleFont: UIFont
//    var closeText: String
//    var doneText: String
//
//    required init() {
//
//        doneBackgroundColor = AppInitSetConfig.appBackColor()
//        headerBackgroundColor = AppInitSetConfig.appBackColor()
//        titleColor = AppInitSetConfig.appFontColor()
//        titleFont = UIFont.OpenSansRegular(fontSize: 18)
//        doneText = "Done".localized()
//        closeText = "Close".localized()
//
//    }
//
//}
