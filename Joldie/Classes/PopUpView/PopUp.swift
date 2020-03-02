//
//  PopUp.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 26/09/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import SnapKit

class PopUpView: UIView {
    
    @IBInspectable var dimBackground: Bool = true
    @IBInspectable var tapToRemove: Bool = true
    
    private var backgroundButton: CustomButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = dimBackground == true ? UIColor(white: 0, alpha: 0.7) : UIColor.clear
        
        if tapToRemove == true {
            addBackgroundButton()
        }
        
    }
    
    private func addBackgroundButton() {
        backgroundButton = CustomButton(type: .custom)
        backgroundButton!.addTarget(self, action: #selector(backgroundTapped), for: .touchUpInside)
        insertSubview(backgroundButton!, at: 0)
        
        backgroundButton!.snp.makeConstraints { (make) in
            make.margins.equalTo(backgroundButton!.superview!)
        }
        
    }
    
    @objc private func backgroundTapped() { remove() }
}

extension PopUpView: PopUpPresentable {
    
    func popUp(animated: Bool = true) -> Self {
        guard let keyWindow = UIApplication.shared.keyWindow else { return self }
        
        keyWindow.addSubview(self)
        snp.makeConstraints({ (make) in
            make.margins.equalTo(superview!)
        })
        
        if animated == true {
            alpha = 0
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.alpha = 1
            })
        }
        
        return self
        
    }
    
    func remove(animated: Bool = true) {
        
        if animated == true {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.alpha = 0
                }, completion: { [weak self] (_) in
                    self?.removeFromSuperview()
            })
            
        } else {
            removeFromSuperview()
        }
    }
    
}
