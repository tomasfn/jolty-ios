//
//  PopUpHelper.swift
//  AppGeneric
//
//  Created by Tomás Fernández on 29/10/17.
//  Copyright © 2017 Tomás Fernández Nuñez. All rights reserved.
//

import Foundation
import UIKit
import ZAlertView

class PopUpHelper {
    
    class func showCustomLoginAlert(closeAction: UIAlertAction? = nil, confirmAction : UIAlertAction? = nil) -> UIAlertController {
        
        let alerController = UIAlertController(title: "Jolty", message: "You must be logged in order to fully use the App".localized(), preferredStyle: .alert)
        
        alerController.addAction(closeAction!)
        alerController.addAction(confirmAction!)
        
        return alerController
    }
    
    class func showForgotPasswordPopUp() -> ForgotPasswordPopUpView {
        return (ForgotPasswordPopUpView.initFromNib() as! ForgotPasswordPopUpView).popUp()
    }
        
    class func showLogOutAlertPopUp(leftButtonBlock: ZAlertView.TouchHandler? = nil, rightButtonBlock: ZAlertView.TouchHandler? = nil) -> ZAlertView {
        
        let dialog = ZAlertView(title: "Log Out".localized(), message: "Do you want to log out?".localized(), isOkButtonLeft: false, okButtonText: "Yes".localized(), cancelButtonText: "No".localized(), okButtonHandler: leftButtonBlock, cancelButtonHandler: rightButtonBlock)
        
        dialog.height = 300
        dialog.width = 300
            
        return dialog
    }
    
    class func showNearPlacesPopUp(leftButtonBlock: ButtonBlock? = nil, rightButtonBlock: ButtonBlock? = nil) {
        let descriptionMessage = "Select yes if you want to choose a place, select no if you want to use your exact location".localized()
        let suggestedPlacesPopUp = BinaryPopUpView.view(withTitle: "Are you inside a place?".localized(), withDescription: descriptionMessage, whitLeftButtonTitle: "No".localized(), withRightButtonTitle: "Yes".localized()).popUp()
        
        suggestedPlacesPopUp.leftOptionBlock = leftButtonBlock
        suggestedPlacesPopUp.rightOptionBlock = rightButtonBlock
    }
    
    class func didFoundGuestPopUp(leftButtonBlock: ZAlertView.TouchHandler? = nil, rightButtonBlock: ZAlertView.TouchHandler? = nil) -> ZAlertView  {
        let guestName = UserModelShared.currentGuestUserData(attribute: "name")
        var descriptionMessage = "Have you found".localized()
        descriptionMessage.append(" \(String(describing: guestName!))?")
        
        let dialog = ZAlertView(title: guestName, message: descriptionMessage.localized(), isOkButtonLeft: false, okButtonText: "Yes".localized(), cancelButtonText: "No".localized(), okButtonHandler: leftButtonBlock, cancelButtonHandler: rightButtonBlock)
        
        dialog.height = 300
        dialog.width = 300
        
        return dialog
        
    }
}


