//
//  CurrentBattery.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 26/08/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import UIKit

class CurrentBattery {
    class func batteryLevelPercentage() -> Int {
        return Int(UIDevice.current.batteryLevel * 100)
    }
    
    class func batteryState() -> String {
        if UIDevice.current.batteryState == UIDeviceBatteryState.unplugged {
            return "Unplugged"
        }
        if UIDevice.current.batteryState == UIDeviceBatteryState.charging {
            return "Charging"
        }
        if UIDevice.current.batteryState == UIDeviceBatteryState.full {
            return "Full"
        }
        return "Unknown"
    }
    
    class func batteryCharging() -> Bool {
        return UIDevice.current.batteryState == UIDeviceBatteryState.charging
    }
    
    class func batteryFull() -> Bool {
        return UIDevice.current.batteryState == UIDeviceBatteryState.full
    }
    
    class func batteryLowPowerModeEnabled() -> Bool {
        if ProcessInfo.processInfo.isLowPowerModeEnabled == false {
            return false
        } else {
            return true
        }
    }
    
    class func currentColor() -> UIColor? {
        switch CurrentBattery.batteryLevelPercentage() {
        case 90...100:
            return .greenColorBattery()
        case 60...90:
            return .greenColorBattery()
        case 30...60:
            return .greenColorBattery()
        case 16...30:
            return .greenColorBattery()
        case 0...15:
            return .redColorBattery()
        default: break
        }
        
        return UIColor.blue
    }
}

