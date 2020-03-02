//
//  SignUpViewController.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/22/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import SVProgressHUD
import IQDropDownTextField
import FirebaseDatabase
import FirebaseAuth
import GeoFire
import TransitionButton
import AvatarImageView
import SkyFloatingLabelTextField

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailInputTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var passInputTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPassInputTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var nameInputTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var lastnameInputTxt: SkyFloatingLabelTextField!
    
    @IBOutlet weak var withyourEmailLbl: UILabel!
    @IBOutlet weak var accessBtn: TransitionButton!
    @IBOutlet weak var closeSignUpBtn: UIButton!
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet var profilePicImgView: UIImageView!
    
    var geoFireRef: DatabaseReference?
    var geoFire: GeoFire?
    
    var imagePicker = UIImagePickerController()
    
    weak var emailValidatorView: TextFieldValidatorView! {
        didSet{
            setCloseSignUpBtnTop()
        }
    }
    weak var passwordValidatorView: TextFieldValidatorView! {
        didSet{
            setCloseSignUpBtnTop()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldsInView()
        configureTextFieldsInView()
        setAccessBtn()
        
        profilePicImgView.roundView()
        badgeView.backgroundColor = AppInitSetConfig.appBackColor()
        withyourEmailLbl.text = "Sign up with your email".localized()
        
        geoFireRef = Database.database().reference().child("Geolocs")
        geoFire = GeoFire(firebaseRef: geoFireRef!)
    }
    
    func setAccessBtn() {
        accessBtn.setTitleColor(AppInitSetConfig.appBackColor(), for: .normal)
        accessBtn.spinnerColor = AppInitSetConfig.appBackColor()
        accessBtn.cornerRadius = 8
    }
    
    
    func configureTextFieldsInView() {
        
        emailInputTxt.delegate = self
        nameInputTxt.delegate = self
        lastnameInputTxt.delegate = self
        passInputTxt.delegate = self
        confirmPassInputTxt.delegate = self
        
        
        emailInputTxt.addTarget(self, action: #selector(textFieldDidChangeText(_:)), for: .editingChanged)
        nameInputTxt.addTarget(self, action: #selector(textFieldDidChangeText(_:)), for: .editingChanged)
        lastnameInputTxt.addTarget(self, action: #selector(textFieldDidChangeText(_:)), for: .editingChanged)
        passInputTxt.addTarget(self, action: #selector(textFieldDidChangeText(_:)), for: .editingChanged)
        confirmPassInputTxt.addTarget(self, action: #selector(textFieldDidChangeText(_:)), for: .editingChanged)
    }
    
    func setTextFieldsInView() {
        
        emailInputTxt.placeholderColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        passInputTxt.placeholderColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        confirmPassInputTxt.placeholderColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        nameInputTxt.placeholderColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        lastnameInputTxt.placeholderColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        
        emailInputTxt.placeholder = "Email".localized()
        passInputTxt.placeholder = "Password".localized()
        confirmPassInputTxt.placeholder = "Confirm password".localized()
        nameInputTxt.placeholder = "Name".localized()
        lastnameInputTxt.placeholder = "Last name".localized()
        
        
        emailInputTxt.selectedLineColor = AppInitSetConfig.appFontColor()
        passInputTxt.selectedLineColor = AppInitSetConfig.appFontColor()
        confirmPassInputTxt.selectedLineColor = AppInitSetConfig.appFontColor()
        nameInputTxt.selectedLineColor = AppInitSetConfig.appFontColor()
        lastnameInputTxt.selectedLineColor = AppInitSetConfig.appFontColor()
        
        emailInputTxt.textColor = AppInitSetConfig.appFontColor()
        passInputTxt.textColor = AppInitSetConfig.appFontColor()
        confirmPassInputTxt.textColor = AppInitSetConfig.appFontColor()
        nameInputTxt.textColor = AppInitSetConfig.appFontColor()
        lastnameInputTxt.textColor = AppInitSetConfig.appFontColor()
        
        emailInputTxt.title = "Your email".localized()
        passInputTxt.title = "Your password".localized()
        confirmPassInputTxt.title = "Your password again".localized()
        nameInputTxt.title = "Your first name".localized()
        lastnameInputTxt.title = "Your last name".localized()
        
        emailInputTxt.selectedTitleColor = AppInitSetConfig.appFontColor()
        passInputTxt.selectedTitleColor = AppInitSetConfig.appFontColor()
        confirmPassInputTxt.selectedTitleColor = AppInitSetConfig.appFontColor()
        nameInputTxt.selectedTitleColor = AppInitSetConfig.appFontColor()
        lastnameInputTxt.selectedTitleColor = AppInitSetConfig.appFontColor()
        
        emailInputTxt.lineColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        passInputTxt.lineColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        confirmPassInputTxt.lineColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        nameInputTxt.lineColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        lastnameInputTxt.lineColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        
        emailInputTxt.titleColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        passInputTxt.titleColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        confirmPassInputTxt.titleColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        nameInputTxt.titleColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        lastnameInputTxt.titleColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        
        emailInputTxt.backgroundColor = AppInitSetConfig.appBackColor()
        passInputTxt.backgroundColor = AppInitSetConfig.appBackColor()
        confirmPassInputTxt.backgroundColor = AppInitSetConfig.appBackColor()
        nameInputTxt.backgroundColor = AppInitSetConfig.appBackColor()
        lastnameInputTxt.backgroundColor = AppInitSetConfig.appBackColor()
    }
    
    @IBAction func cancelSignUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    func addPasswordValidatorView(textField: UITextField) {
        
        if passwordValidatorView == nil {
            passwordValidatorView = (TextFieldValidatorView.initFromNib() as! TextFieldValidatorView)
        }
        
        if passwordValidatorView!.superview == nil {
            view.addSubview(passwordValidatorView!)
            passwordValidatorView!.snp.makeConstraints({ (make) in
                make.left.right.equalTo(view)
                make.height.equalTo(TextFieldValidatorView.preferredHeight)
            })
        }
        
        passwordValidatorView?.descriptionLbl.text = "Passwords must match".localized()
        
        passwordValidatorView!.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.passwordValidatorView!.alpha = 1
        })
        
    }
    
    @IBAction func registerMe(_ sender: Any) {
        
        accessBtn.startAnimation()
        
        let initials = "\(nameInputTxt.text!.first!)\(lastnameInputTxt.text!.first!)"
        
        if profilePicImgView.image == nil {
            struct DataSource: AvatarImageViewDataSource { var initials: String = "NN" }
            let avatarImageView = AvatarImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            avatarImageView.dataSource = DataSource.init(initials: initials)
            profilePicImgView.image = avatarImageView.image
        }
            
        UserModel.registerUser(withName: nameInputTxt.text!, withLastName: lastnameInputTxt.text!, email: emailInputTxt.text!, password: confirmPassInputTxt.text!, profilePic: profilePicImgView.image!) { [weak weakSelf = self] (status) in
            DispatchQueue.main.async {
                if status == true
                {
                    var successMessage = "User created".localized()
                    SVProgressHUD.showSuccess(withStatus: successMessage)
                    self.dismiss(animated: true, completion: nil)
                }
                self.accessBtn.stopAnimation()
            }
        }
    }
    
    func fieldsValidator() {
        if let emailText = emailInputTxt.text, let nameText = nameInputTxt.text, let lastName = lastnameInputTxt.text, let passText = passInputTxt.text, let confirmPassText = confirmPassInputTxt.text, emailText.isEmpty == false && passText.isEmpty == false && confirmPassText.isEmpty == false && nameText.isEmpty == false && lastName.isEmpty == false && emailValidatorView == nil && passwordValidatorView == nil
        {
            accessBtn.alpha = 1
            accessBtn.isEnabled = true
        } else {
            accessBtn.alpha = 0.5
            accessBtn.isEnabled = false
        }
    }
    
    func removeEmailValidatorView() {
        emailValidatorView?.removeFromSuperview()
        emailValidatorView = nil
    }
    
    func removePasswordValidatorView() {
        passwordValidatorView?.removeFromSuperview()
        passwordValidatorView = nil
    }
    
    func setCloseSignUpBtnTop() {

    }
    
    func checkMatchingPasswords(password: String, confirmPassword: String) -> Bool? {
        if password == confirmPassword {
            return true
        } else {
            return false
        }
    }
    
}


// MARK: UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChangeText(_ textField: UITextField) {
        fieldsValidator()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == emailInputTxt {
            if let text = textField.text {
                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                    if(text.characters.count < 3 || !text.contains("@")) {
                        floatingLabelTextField.errorMessage = "Invalid email"
                    }
                    else {
                        // The error message will only disappear when we reset it to nil or empty string
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
        }
        
        if textField == confirmPassInputTxt {
            if checkMatchingPasswords(password: passInputTxt.text!, confirmPassword: confirmPassInputTxt.text!) == false {
                addPasswordValidatorView(textField: textField)
            } else {
                removePasswordValidatorView()
            }
        }
        
        fieldsValidator()
    }
}
