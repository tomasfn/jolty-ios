//
//  BatteryHelper.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 31/08/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import UIKit

class AlertControllerHelper {
    
    class func presentLowPowerModeAlert() -> UIAlertController {
        
        let alertController = UIAlertController (title: "Let's save battery".localized(), message: "Go to Settings, then go to Battery and activate Low Power Mode".localized(), preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Go To Settings".localized(), style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .default, handler: nil)
        alertController.addAction(cancelAction)
        

        return alertController
    }
    
    class func presentRequestLocationAlert() -> UIAlertController {
            let alertController = UIAlertController(title: "Location Access Requested".localized(),
                                                    message: "The location permission was not authorized. Please enable it in Settings to continue.".localized(),
                                                    preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings".localized(), style: .default) { (alertAction) in
                
                // THIS IS WHERE THE MAGIC HAPPENS!!!!
                if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(appSettings as URL)
                }
            }
            alertController.addAction(settingsAction)
            
            let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            return alertController
    }
    
    class func presentRegisterLoginMessage() -> UIAlertController {
        let alertController = UIAlertController(title: "Login required".localized(),
                                                message: "To fully use Jolty you must be signed in. Is very fast tho".localized(),
                                                preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print("OK Pressed")
        }
        alertController.addAction(okAction)
        
        
        return alertController
    }
}
