//
//  EmptyJoltysView.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/27/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import UIKit

class EmptyJoltysView: UIView {
    
    @IBOutlet weak var noCouponsTitleLbl: UILabel!
    @IBOutlet weak var noCouponssubtitleLbl: UILabel!
    @IBOutlet weak var JoltyCurrentLogoImgView: UIImageView!
    
    override func awakeFromNib() {
        
        backgroundColor = AppInitSetConfig.appFontColor()
        
        JoltyCurrentLogoImgView.image = AppInitSetConfig.appLogoImage().maskWithColor(color: AppInitSetConfig.appBackColor())
        noCouponsTitleLbl.textColor = AppInitSetConfig.appBackColor()
        noCouponssubtitleLbl.textColor = AppInitSetConfig.appBackColor()
        
        noCouponsTitleLbl.text = "No activity by now".localized()
        noCouponssubtitleLbl.text = ""
    }
    
}

