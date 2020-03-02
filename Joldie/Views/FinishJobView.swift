//
//  FinishJobView.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 06/11/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol FinishJobViewDelegate: class {
    func jobFinished()
}

class FinishJobView: UIView {
    
    @IBOutlet weak var finishJobBtn: UIButton!
    
    weak var delegate: FinishJobViewDelegate?
    
    static var preferredHeight: Float { return 85 }

    override func awakeFromNib() {
        configureButton()
    }
    
    func configureButton() {
        
        finishJobBtn.setTitleColor(AppInitSetConfig.appFontColor(), for: .normal)
        finishJobBtn.backgroundColor = UIColor.appMainGrayColor()
        finishJobBtn.roundView()
        
        let guestName = UserModelShared.currentGuestUserData(attribute: "name")
        
        var buttonTitle = "\("I just found ".localized())"
        buttonTitle.append(guestName!)
        
        //"\(String(describing: guestName!)"
        
        finishJobBtn.setTitle(buttonTitle, for: .normal)
        finishJobBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        //Add shadow to button
        finishJobBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        finishJobBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        finishJobBtn.layer.shadowOpacity = 1.0
        finishJobBtn.layer.shadowRadius = 10.0
        finishJobBtn.layer.masksToBounds = false
    }
    
    @IBAction func finishJobAction(_ sender: AnyObject) {
        delegate?.jobFinished()
    }    
}
