//
//  EmptyJoltysView.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/27/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import UIKit
import BatteryView

class BatteryStatusView: UIView {
        
    @IBOutlet weak var infoLabel: UILabel!

    static var preferredHeight: Float { return 55 }
    
    override func awakeFromNib() {
        self.alpha = 0.9

        let littleBattery = BatteryView(frame: CGRect(x: 25, y: 5, width: 25, height: 45))
        
        littleBattery.highLevelColor = UIColor.greenColorBattery()
        littleBattery.lowLevelColor = UIColor.redColorBattery()
        
        littleBattery.level = CurrentBattery.batteryLevelPercentage()
        littleBattery.gradientThreshold = 70
        littleBattery.lowThreshold = 10

        self.addSubview(littleBattery)
        
        infoLabel.text  = "\("You have".localized()) \(CurrentBattery.batteryLevelPercentage())% \("you are".localized()) \(User.BatteryStr())"
        
        infoLabel.textColor = littleBattery.currentFillColor
    }
}

