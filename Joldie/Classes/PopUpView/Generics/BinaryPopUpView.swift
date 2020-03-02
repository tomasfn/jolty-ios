//
//  BinaryPopUpView.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 29/09/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit

class BinaryPopUpView: BasicPopUpView {
    
    @IBOutlet fileprivate var leftButton: CustomButton!
    @IBOutlet fileprivate var rightButton: CustomButton!
    
    fileprivate var leftButtonTitle: String! {
        didSet {
            leftButton.setTitle(leftButtonTitle.localized().uppercased(), for: UIControlState())
            leftButton.backgroundColor = AppInitSetConfig.appBackColor()
            setNeedsLayout()
        }
    }
    fileprivate var rightButtonTitle: String! {
        didSet {
            rightButton.setTitle(rightButtonTitle.localized().uppercased(), for: UIControlState())
            rightButton.backgroundColor = AppInitSetConfig.appBackColor()
            setNeedsLayout()
        }
    }
    
    var leftOptionBlock: ButtonBlock?
    var rightOptionBlock: ButtonBlock?
    
    class func view(withTitle title: String? = nil, withDescription _description: String? = nil, whitLeftButtonTitle leftButtonTitle: String!, withRightButtonTitle rightButtonTitle: String!) -> BinaryPopUpView {
        let binaryView = initFromNib() as! BinaryPopUpView
        binaryView.setTitle(title, andDescription: _description, andLeftButtonTitle: leftButtonTitle, andRightButtonTitle: rightButtonTitle)
        return binaryView
    }
    
    fileprivate func setTitle(_ title: String? = nil, andDescription _description: String?, andLeftButtonTitle leftButtonTitle: String!, andRightButtonTitle rightButtonTitle: String!) {
        self.title = title
        self._description = _description
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
    }
    
}

//MARK: - IBActions
extension BinaryPopUpView {
    
    @IBAction fileprivate func actionLeftPressed() {
        leftOptionBlock?()
        remove()
    }
    
    @IBAction fileprivate func actionRightPressed() {
        rightOptionBlock?()
        remove()
    }
    
}
