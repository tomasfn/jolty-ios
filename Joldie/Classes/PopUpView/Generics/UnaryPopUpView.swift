//
//  UnaryPopUpView.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 26/09/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit

class UnaryPopUpView: BasicPopUpView {
    
    @IBOutlet private var confirmButton: CustomButton!
    
    private var confirmButtonTitle: String! {
        didSet {
            confirmButton.setTitle(confirmButtonTitle.localized().uppercased(), for: .normal)
            confirmButton.backgroundColor = AppInitSetConfig.appBackColor()
            setNeedsLayout()
        }
    }
    
    var confirmBlock: ButtonBlock?
    
    class func view(withTitle title: String? = nil, withDescription _description: String? = nil, whitConfirmButtonTitle confirmButtonTitle: String!) -> UnaryPopUpView {
        let unaryView = initFromNib() as! UnaryPopUpView
        unaryView.setTitle(title: title, andDescription: _description, andConfirmButtonTitle: confirmButtonTitle)
        return unaryView
    }
    
    private func setTitle(title: String? = nil, andDescription _description: String?, andConfirmButtonTitle confirmButtonTitle: String!) {
        self.title = title
        self._description = _description
        self.confirmButtonTitle = confirmButtonTitle
    }
    
    @IBAction func removePopUp(_ sender: Any) {
        confirmBlock?()
        remove()
    }
}

//MARK: - IBActions
extension UnaryPopUpView {
    
    @IBAction private func actionConfirmPressed() {
        confirmBlock?()
        remove()
    }
    
}
