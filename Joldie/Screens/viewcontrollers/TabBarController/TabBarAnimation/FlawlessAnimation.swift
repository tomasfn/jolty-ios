//
//  FlawlessAnimation.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 19/09/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import RAMAnimatedTabBarController
import UIKit

class FlawlessAnimation : RAMItemAnimation {
    
    override func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        playBounceAnimation(icon)
        textLabel.textColor = textSelectedColor
    }
    
    override func deselectAnimation(_ icon: UIImageView, textLabel: UILabel, defaultTextColor: UIColor, defaultIconColor: UIColor) {
        textLabel.textColor = defaultTextColor
    }
    
    override func selectedState(_ icon: UIImageView, textLabel: UILabel) {
        textLabel.textColor = textSelectedColor
    }
    
    func playBounceAnimation(_ icon : UIImageView) {
        
    }
}

