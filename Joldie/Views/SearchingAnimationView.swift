//
//  EmptyJoltysView.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/27/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import Lottie
import UIKit

protocol SearchingAnimationViewDelegate {
    func cancelSearchingCable()
}

class SearchingAnimationView: UIView {
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var lightningImageView: UIImageView!
    @IBOutlet weak var cancelSearchingBtn: UIButton!
    @IBOutlet weak var JoltyrsFoundLbl: UILabel!
    
    var delegate: SearchingAnimationViewDelegate!
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    static var preferredHeight: Float { return Float(UIScreen.main.bounds.height) }

    override func awakeFromNib() {
        
        cancelSearchingBtn.setTitle("Cancel".localized(), for: .normal)
        cancelSearchingBtn.setTitleColor(AppInitSetConfig.appFontColor(), for: .normal)
        //cheap red color from idk where but looks good
        cancelSearchingBtn.backgroundColor = UIColor.init(hexString: "#FF6C66")
        cancelSearchingBtn.roundView()
        
        //Add shadow to button
        cancelSearchingBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        cancelSearchingBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        cancelSearchingBtn.layer.shadowOpacity = 1.0
        cancelSearchingBtn.layer.shadowRadius = 10.0
        cancelSearchingBtn.layer.masksToBounds = false
        
        JoltyrsFoundLbl.textColor = AppInitSetConfig.appBackColor()
        descriptionLbl.textColor = AppInitSetConfig.appBackColor()
        descriptionLbl.text = "Alerting to walking distance users that you need a charger".localized()
        
        let templateImage = lightningImageView.image?.withRenderingMode(.alwaysTemplate)
        lightningImageView.image = templateImage
        lightningImageView.tintColor = AppInitSetConfig.appBackColor()
        
        let dimView = UIView()
        dimView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        dimView.frame.size = CGSize(width: screenSize.width, height: screenSize.height)
        dimView.center.y = self.center.y

        self.addSubview(dimView)
        
        let animationView = LOTAnimationView(name: "searchinganimation")
        
        animationView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 400)
        animationView.contentMode = .scaleAspectFit
        //animationView.center.x = self.center.x
        animationView.center.y = self.center.y

        self.addSubview(animationView)
        
        self.bringSubview(toFront: descriptionLbl)
        self.bringSubview(toFront: lightningImageView)
        self.bringSubview(toFront: cancelSearchingBtn)
        self.bringSubview(toFront: JoltyrsFoundLbl)
        
        animationView.animationProgress = 50
        animationView.loopAnimation = true
        animationView.play{ (finished) in
            dimView.removeFromSuperview()
        }
    }
    
    @IBAction func cancelSearchingAction(_ sender: Any) {
        delegate.cancelSearchingCable()
    }
    
}

