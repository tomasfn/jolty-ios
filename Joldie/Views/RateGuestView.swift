//
//  rateGuestView.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 12/10/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import AvatarImageView
import Firebase

protocol RateGuestDelegate: class {
    func guestWasRated()
}

class RateGuestView: MapOverlayView {
    
    @IBOutlet weak var InfoView: UIView!
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var bad: UIImageView!
    @IBOutlet weak var veryGood: UIImageView!
    @IBOutlet weak var good: UIImageView!
    @IBOutlet weak var normal: UIImageView!
    
    @IBOutlet weak var guestProfileImgView: AvatarImageView! {
        didSet {
            guestProfileImgView.contentMode = .scaleAspectFit
            guestProfileImgView.layer.borderWidth = 1.5
            guestProfileImgView.layer.borderColor = UIColor.appMainGrayColor().cgColor
            guestProfileImgView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var ratePresentationText: UILabel!
    
    weak var delegate: RateGuestDelegate?
    
    var selectedRate: Int = 0
    
    func configureRateView() {
        
        let guestName = UserModelShared.currentGuestUserData(attribute: "name")
        
        ratePresentationText.text = "\("How was".localized()) \(guestName!)?"
        
        UIImage.currentGuestProfilePicImage(completionBlock: { (image) in
            self.guestProfileImgView.image = image
        })
    }
    
    func setCalificationImagesTaps() {
        
        bad.tag = 1
        normal.tag = 2
        good.tag = 3
        veryGood.tag = 4
        
        let tapToRateBad = UITapGestureRecognizer(target: self, action: #selector(ratedBad))
        
        let tapToRateNormal = UITapGestureRecognizer(target: self, action: #selector(ratedNormal))

        let tapToRateGood = UITapGestureRecognizer(target: self, action: #selector(ratedGood))
        
        let tapToRateVeryGood = UITapGestureRecognizer(target: self, action: #selector(ratedVeryGood))
        
        tapToRateBad.numberOfTapsRequired = 1
        tapToRateNormal.numberOfTapsRequired = 1
        tapToRateGood.numberOfTapsRequired = 1
        tapToRateVeryGood.numberOfTapsRequired = 1
        
        bad.addGestureRecognizer(tapToRateBad)
        normal.addGestureRecognizer(tapToRateNormal)
        good.addGestureRecognizer(tapToRateGood)
        veryGood.addGestureRecognizer(tapToRateVeryGood)
    }
    
    @objc func ratedBad() {
        ratedGuestUser(calificationSelected: bad.tag)
    }
    
    @objc func ratedNormal() {
        ratedGuestUser(calificationSelected: normal.tag)
    }
    
    @objc func ratedGood() {
        ratedGuestUser(calificationSelected: good.tag)
    }
    
    @objc func ratedVeryGood() {
        ratedGuestUser(calificationSelected: veryGood.tag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        InfoView.layer.cornerRadius = 8
        
        configureRateView()
        setElementColors()
        setCalificationImagesTaps()
        
        dimView.backgroundColor = .black
        dimView.alpha = 0.5
    }
    
    func setElementColors() {
        guestProfileImgView.roundView()
        
        bad.maskWith(color: AppInitSetConfig.appFontColor())
        normal.maskWith(color: AppInitSetConfig.appFontColor())
        good.maskWith(color: AppInitSetConfig.appFontColor())
        veryGood.maskWith(color: AppInitSetConfig.appFontColor())
        
        ratePresentationText.textColor = AppInitSetConfig.appFontColor()
        InfoView.backgroundColor = AppInitSetConfig.appBackColor()
    }
    
    @IBAction func closeView(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        })
    }
    
    func ratedGuestUser(calificationSelected: Int) {
        SVProgressHUD.show(withStatus: "Rating user".localized())
        
        let guestCurrentRate = Int(UserModelShared.currentGuestUserData(attribute: "qualification"))
        
        let sumRate = guestCurrentRate! + calificationSelected
        let sumRateStr = String(sumRate)
    Database.database().reference().child("Users").child((Auth.auth().currentUser!.uid)).child("user_details").child("qualification").setValue(sumRateStr)
        var userInfo = UserDefaults.standard.dictionary(forKey: "userDetails")
        userInfo?.updateValue(sumRateStr, forKey: "qualification")
        UserDefaults.standard.set(userInfo, forKey: "userDetails")

        delegate?.guestWasRated()
    }
}
