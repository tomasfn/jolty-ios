//
//  EmptyJoltysView.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/27/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import UIKit
import TransitionButton

protocol SendHelpViewDelegate {
    func sendHelpTouched()
}

class SendHelpView: UIView {
    
    var delegate: SendHelpViewDelegate?
    
    @IBOutlet weak var sendHelpBtn: TransitionButton!
    
    static var preferredHeight: Float { return 75 }

    override func awakeFromNib() {
        
        sendHelpBtn.titleLabel?.tintColor = AppInitSetConfig.appFontColor()
        sendHelpBtn.titleLabel?.font = UIFont.OpenSansBold(fontSize: 16)
        
        sendHelpBtn.backgroundColor = AppInitSetConfig.appBackColor()
        
        sendHelpBtn.layer.borderWidth = 1
        sendHelpBtn.layer.borderColor = UIColor.appMainGrayColor().cgColor
        
        sendHelpBtn.roundCorners(radius: 16)
        
        sendHelpBtn.contentMode = .scaleAspectFit
        sendHelpBtn.isMultipleTouchEnabled = false
        
        //Add shadow to button
        sendHelpBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        sendHelpBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        sendHelpBtn.layer.shadowOpacity = 1.0
        sendHelpBtn.layer.shadowRadius = 10.0
        sendHelpBtn.layer.masksToBounds = false
        
        sendHelpBtn.titleLabel?.numberOfLines = 0
        sendHelpBtn.titleLabel!.adjustsFontSizeToFitWidth = true
        
        sendHelpBtn.setImage(UIImage.lightningCable()?.maskWithColor(color: AppInitSetConfig.appFontColor()), for: .normal)
        //sendHelpBtn.setTitle("Find a charger sharer!".localized(), for: .normal)
        sendHelpBtn.titleLabel?.textAlignment = .center
        sendHelpBtn.roundView()
        sendHelpBtn.sizeToFit()
        
        //sendHelpBtn.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func sendHelpBtnTouched(_ sender: Any) {
        delegate?.sendHelpTouched()
    }
}

