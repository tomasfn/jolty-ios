//
//  ForgotPasswordPopUpView.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 26/09/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import ZAlertView

class ForgotPasswordPopUpView: PopUpView {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var textField: CustomTextField!
    @IBOutlet private var sendButton: CustomButton!
    
    var emailBlock: ((_ email: String) -> (Void))?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = "Okay, forgetful".localized()
        
        descriptionLabel.text = "Enter your email".localized()
        textField.placeholder = "example@Jolty.com".localized()
        
        sendButton.setTitleColor(AppInitSetConfig.appBackColor(), for: .normal)
        sendButton.setTitle("Send".localized().uppercased(), for: .normal)
    }
    
    
    @IBAction func removePopUpView(_ sender: Any) {
        remove()
    }
    
    @IBAction private func actionSendPressed() {
        
        guard let email = textField.text, !email.isEmpty else {
            
            ZAlertView(title: "Empty field".localized(), message: "Mail field is empty".localized(), closeButtonText: "Ok".localized()) { (alert) in
                alert.dismissAlertView()
                }.show()
            
            return
        }
        
        textField.resignFirstResponder()
        
        emailBlock?(email)
        remove()
    }
    
    deinit {
        textField.resignFirstResponder()
    }
    
}

extension ForgotPasswordPopUpView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
