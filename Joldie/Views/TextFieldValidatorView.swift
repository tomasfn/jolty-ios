//
//  TextFieldValidatorView.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/27/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit

class TextFieldValidatorView: UIView {
    
    static var preferredHeight: Float { return 55 }
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    override func awakeFromNib() {

        backgroundColor = AppInitSetConfig.appFontColor()
        descriptionLbl.textColor = AppInitSetConfig.appBackColor()
    }
    
}

