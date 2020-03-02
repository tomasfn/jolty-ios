//
//  GuestInfoView.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 12/10/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import SVProgressHUD
import AvatarImageView
import SDWebImage
import BatteryView

protocol GuestInfoViewDelegate: class {
    func jobStarted()
}

class GuestInfoView: MapOverlayView {
    
    @IBOutlet weak var batteryViewContainer: UIView!
    @IBOutlet weak var InfoView: UIView!
    @IBOutlet weak var dimView: UIView!

    @IBOutlet weak var guestProfileImgView: AvatarImageView! {
        didSet {
            guestProfileImgView.contentMode = .scaleAspectFit
            guestProfileImgView.layer.borderWidth = 1.5
            guestProfileImgView.layer.borderColor = UIColor.appMainGrayColor().cgColor
            guestProfileImgView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var yourRescuerLbl: UILabel!
    @IBOutlet weak var guestFullNameLbl: UILabel!

    var isSaviour = false
    
    @IBOutlet weak var okBtn: UIButton!
    
    weak var delegate: GuestInfoViewDelegate?
    
    func configureGuestInfoView() {
        
        let guestName = UserModelShared.currentGuestUserData(attribute: "name")
        let guestLastName = UserModelShared.currentGuestUserData(attribute: "last_name")
        let guestCurrentBatteryLvl = Int(UserModelShared.currentGuestUserData(attribute: "current_batteryLvl"))
        
        guestFullNameLbl.text = "\(String(describing: guestName!)) \(String(describing: guestLastName!))"
        
        yourRescuerLbl.text = "Find quick!".localized()
        
        let littleBattery = BatteryView(frame: CGRect(x: 0, y: 0, width: 25, height: 45))
        
        littleBattery.highLevelColor = UIColor.greenColorBattery()
        littleBattery.lowLevelColor = UIColor.redColorBattery()
        littleBattery.level = guestCurrentBatteryLvl!
        batteryViewContainer.addSubview(littleBattery)
        
        UIImage.currentGuestProfilePicImage(completionBlock: { (image) in
            self.guestProfileImgView.image = image
        })
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        InfoView.layer.cornerRadius = 8
        setElementColors()
        configureGuestInfoView()
    }
    
    func setElementColors() {
        yourRescuerLbl.textColor = AppInitSetConfig.appFontColor()
        guestFullNameLbl.textColor = AppInitSetConfig.appFontColor()
        InfoView.backgroundColor = AppInitSetConfig.appBackColor()
        guestProfileImgView.roundView()
        okBtn.roundView()
        
        okBtn.setTitleColor(UIColor.lightGray, for: .normal)
        okBtn.backgroundColor = AppInitSetConfig.appFontColor()
    }
    
    @IBAction func closeView(_ sender: AnyObject) {
        delegate?.jobStarted()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        })
    }
}
