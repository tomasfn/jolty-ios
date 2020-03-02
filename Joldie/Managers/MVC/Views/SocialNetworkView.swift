//
//  SocialNetworkView.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/28/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit

typealias SocialNetworkBlock = (SocialNetwork) -> ()

class SocialNetworkView: UIView {
    
    @IBInspectable var buttonBackgroundColor: UIColor?
    
    @IBOutlet var button: UIButton?
    
    var socialNetwork: SocialNetwork! {
        didSet { configureForSocialNetwork() }
    }
    
    var selectedBlock: (SocialNetworkBlock)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let button = button {
            
            button.contentVerticalAlignment = .fill
            button.contentMode = .center
            button.imageView?.contentMode = .scaleAspectFit
            button.adjustsImageWhenHighlighted = false
            
            button.setBackgroundColor(color: UIColor.appFacebookBtnColor(), forState: .highlighted)
            button.layer.cornerRadius = 8
            button.clipsToBounds = true
            
            button.addTarget(self, action: #selector(actionPressed), for: .touchUpInside)
            
            if let buttonBackgroundColor = buttonBackgroundColor {
                button.setBackgroundImage(UIImage.imageWithColor(color: buttonBackgroundColor), for: .normal)
            }
            
        }
        
    }
    
    private func configureForSocialNetwork() {
        
        //    if let titleLabel = titleLabel {
        //      titleLabel.text = socialNetwork.name
        //    }
        //
        //    if let imageView = imageView {
        //      imageView.image = socialNetwork.image
        //    }
        
    }
    
    @objc private func actionPressed() {
        selectedBlock?(socialNetwork)
    }
    
}
