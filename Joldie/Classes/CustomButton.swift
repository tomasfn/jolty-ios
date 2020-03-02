//
//  CustomButton.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 26/09/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    convenience init() {
        self.init(frame: CGRect.zero)
        customization()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customization()
    }
    
    private func customization() {
        isExclusiveTouch = true
        setTitleColor(AppInitSetConfig.appFontColor(), for: .normal)
        titleLabel!.numberOfLines = 1
        titleLabel!.adjustsFontSizeToFitWidth = true
        
        //    titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        
    }
    
}
