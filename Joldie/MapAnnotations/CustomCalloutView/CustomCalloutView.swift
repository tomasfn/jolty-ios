//
//  CustomCalloutView.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 07/12/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit

class CustomCalloutView: UIView {
    
    @IBOutlet var lblTitle: UILabel!
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    override func awakeFromNib() {
        backgroundColor = AppInitSetConfig.appFontColor()
        lblTitle.textColor = AppInitSetConfig.appBackColor()
        roundCorners(radius: 8)
    }

}
