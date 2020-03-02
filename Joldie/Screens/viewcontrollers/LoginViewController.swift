//
//  LoginViewController.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/22/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import SVProgressHUD
import Firebase
import FirebaseAuth
import BubbleTransition
import TransitionButton
import FBSDKLoginKit
import GeoFire
import GoogleSignIn
import SkyFloatingLabelTextField
import FacebookCore
import FacebookLogin
import ZAlertView

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameInputTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var passInputTxt: SkyFloatingLabelTextField!
    
    @IBOutlet weak var accessBtn: TransitionButton!
    
    @IBOutlet weak var badgeView: UIView!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: GIDSignInButton!
    
    @IBOutlet weak var forgotPasswordLbl: UILabel!

    @IBOutlet weak var closeLoginBtn: UIButton!
    @IBOutlet weak var closeLoginBtnTop: NSLayoutConstraint!
    
    var geoFireRef: DatabaseReference?
    var geoFire: GeoFire?
    
    
   func presentMylazyLoginViewAlert() {
        if User.currentUser == nil {
            present(AlertControllerHelper.presentRegisterLoginMessage(), animated: true, completion: nil)
        }
    }
    
    weak var emailValidatorView: TextFieldValidatorView! {
        didSet{
            setCloseLoginBtnTop()
        }
    }
    weak var passwordValidatorView: TextFieldValidatorView! {
        didSet{
            setCloseLoginBtnTop()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentMylazyLoginViewAlert()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
//        facebookButton.delegate = self
        
        facebookButton.addTarget(self, action: #selector(LoginViewController.handleSignInWithFacebookBtn), for: .touchUpInside)
        
        googleButton.style = .wide
        
        setTextFieldsInView()
        
        //configureSocialNetworkView()
        setDynamicColorsToElements()
        
        let forgoPassGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.showForgotPasswordPopUp))

        forgotPasswordLbl.isUserInteractionEnabled = true
        forgotPasswordLbl.addGestureRecognizer(forgoPassGesture)
        
        geoFireRef = Database.database().reference().child("Geolocs")
        geoFire = GeoFire(firebaseRef: geoFireRef!)
    }
    
    func setDynamicColorsToElements() {
        
        accessBtn.spinnerColor = AppInitSetConfig.appBackColor()
        signUpButton.setTitleColor(AppInitSetConfig.appBackColor(), for: .normal)
        
        forgotPasswordLbl.textColor = AppInitSetConfig.appFontColor()
        
        facebookButton.setImage(UIImage.facebook().maskWithColor(color: AppInitSetConfig.appFontColor()), for: .normal)
        facebookButton.setTitle("Log in with facebook".localized(), for: .normal)
        facebookButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        usernameInputTxt.textColor = AppInitSetConfig.appFontColor()
        passInputTxt.textColor = AppInitSetConfig.appFontColor()
        
        usernameInputTxt.placeholderColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        passInputTxt.placeholderColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        
        usernameInputTxt.placeholder = "Email".localized()
        passInputTxt.placeholder = "Password".localized()
        
        usernameInputTxt.selectedLineColor = AppInitSetConfig.appFontColor()
        passInputTxt.selectedLineColor = AppInitSetConfig.appFontColor()
        
        usernameInputTxt.title = "Your Email".localized()
        passInputTxt.title = "Your password".localized()
        
        usernameInputTxt.selectedTitleColor = AppInitSetConfig.appFontColor()
        passInputTxt.selectedTitleColor = AppInitSetConfig.appFontColor()
        
        usernameInputTxt.lineColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        passInputTxt.lineColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        
        usernameInputTxt.titleColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        passInputTxt.titleColor = AppInitSetConfig.appFontColor().withAlphaComponent(0.5)
        
        usernameInputTxt.backgroundColor = AppInitSetConfig.appBackColor()
        passInputTxt.backgroundColor = AppInitSetConfig.appBackColor()
        
        badgeView.backgroundColor = AppInitSetConfig.appBackColor()
        
        accessBtn.setTitleColor(AppInitSetConfig.appBackColor(), for: .normal)
        accessBtn.setTitleColor(AppInitSetConfig.appBackColor(), for: .highlighted)
        
        accessBtn.setBackgroundColor(color: AppInitSetConfig.appFontColor(), forState: .normal)
        accessBtn.setBackgroundColor(color: AppInitSetConfig.appFontColor(), forState: .highlighted)
        
        accessBtn.cornerRadius = 8
    }
    
    @objc func showForgotPasswordPopUp() {
        view.endEditing(true)
        
        PopUpHelper.showForgotPasswordPopUp().emailBlock = { (email) in
            
            // set firebase get new password and shit
        }
        
    }
    
    @IBAction func goToSignUpUserVC() {
        var signUpVc: UIViewController!
        signUpVc = NavigationHelper.signUpViewController()
        present(signUpVc, animated: true, completion: nil)
    }
    
    @IBAction func loginGoogle() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func setTextFieldsInView() {
        
        usernameInputTxt.delegate = self
        passInputTxt.delegate = self
        
        usernameInputTxt.addTarget(self, action: #selector(textFieldDidChangeText(_:)), for: .editingChanged)
        passInputTxt.addTarget(self, action: #selector(textFieldDidChangeText(_:)), for: .editingChanged)

    }
    
    func removeEmailValidatorView() {
        emailValidatorView?.removeFromSuperview()
        emailValidatorView = nil
    }
    
    func removePasswordValidatorView() {
        passwordValidatorView?.removeFromSuperview()
        passwordValidatorView = nil
    }
    
    func setCloseLoginBtnTop() {
        if emailValidatorView == nil && passwordValidatorView == nil {
            closeLoginBtnTop.constant = 20
        } else {
            closeLoginBtnTop.constant = 60
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    }

    @IBAction func cancelLogin(_ sender: Any) {
        let root = UIApplication.shared.keyWindow?.rootViewController
        root?.dismiss(animated: true, completion: nil)        
//        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logMeIn(_ sender: AnyObject) {
        logUser(email: usernameInputTxt.text!, password: passInputTxt.text!)
        view.endEditing(true)
    }
    
    func checkAllFields() {
        if let legText = usernameInputTxt.text, let passText = passInputTxt.text, legText.isEmpty == false && passText.isEmpty == false && emailValidatorView == nil && passwordValidatorView == nil {
            accessBtn.alpha = 1
            accessBtn.isEnabled = true
        } else {
            accessBtn.alpha = 0.5
            accessBtn.isEnabled = false
        }
    }
    
    func validateFields(textField: UITextField) {
        
        // for Email field
        if textField == usernameInputTxt {
            if (usernameInputTxt.text?.isValidEmail(str: usernameInputTxt.text!))! == false {
                addEmailValidatorView(textField: textField)
            } else {
                removeEmailValidatorView()
            }
        }
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
        
        if textField == passInputTxt {
            passwordValidatorView?.descriptionLbl.text = "Password must be longer".localized()
        }
        
        passwordValidatorView!.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.passwordValidatorView!.alpha = 1
        })
        
    }
    
    func addEmailValidatorView(textField: UITextField) {
        
        if emailValidatorView == nil {
            emailValidatorView = (TextFieldValidatorView.initFromNib() as! TextFieldValidatorView)
        }
        
        if emailValidatorView!.superview == nil {
            
            view.addSubview(emailValidatorView!)
            emailValidatorView!.snp.makeConstraints({ (make) in
                make.left.right.equalTo(view)
                make.height.equalTo(TextFieldValidatorView.preferredHeight)
            })
        }
        
        if textField == usernameInputTxt {
            emailValidatorView?.descriptionLbl.text = "Please enter a valid email".localized()
        }
        
        emailValidatorView!.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.emailValidatorView!.alpha = 1
        })
        
    }
    
    func logUser(email: String, password: String) {
        
        accessBtn.startAnimation()
        UserModel.loginUser(withEmail: usernameInputTxt.text!, password: passInputTxt.text!) { (success) in
            if success == true {
                
                if let lastLoc = LocationManager.sharedManager.lastLocation {
                    self.geoFire?.setLocation(lastLoc, forKey:(Auth.auth().currentUser?.uid)!)
                }
                
                UserModel.info(forUserID: Auth.auth().currentUser!.uid, completion: { (userModel) in
                    DispatchQueue.main.async(execute: {
                        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                    })
                })
                
            }
            self.accessBtn.stopAnimation()
        }
    }
    
    @objc func handleSignInWithFacebookBtn() {
        
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                print("")
                self.loginWithFacebook()
            case .failed(let err):
                print(err.localizedDescription)
                
                ZAlertView(title: "Oops...".localized(), message: err.localizedDescription, closeButtonText: "Ok".localized()) { (alert) in
                    alert.dismissAlertView()
                    }.show()

                SVProgressHUD.dismiss()
                    print(err)
            case .cancelled:
                    print("cancelled")
            }
        }
    }
    
    func loginWithFacebook() {
        
        SVProgressHUD.show()
                
        let credential = FacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.authenticationToken)!)
        UserModel.loginUserWithCredentials(credential: credential) { (success) in
            
            if success == true {
                UserModel.info(forUserID: Auth.auth().currentUser!.uid, completion: { (userModel) in
                    DispatchQueue.main.async(execute: {
                        SVProgressHUD.dismiss()
                        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                    })
                })
            }
        }
    }
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChangeText(_ textField: UITextField) {
        checkAllFields()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if usernameInputTxt == textField {
            if let text = textField.text {
                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                    if(text.count < 3 || !text.contains("@")) {
                        floatingLabelTextField.errorMessage = "Invalid email"
                    }
                    else {
                        // The error message will only disappear when we reset it to nil or empty string
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
        }
        
//        validateFields(textField: textField)
        checkAllFields()
        textField.resignFirstResponder()
        textField.layoutIfNeeded()
    }
}

// Social Network Login and Firebase Linkage

///MARK: Login With Google
extension LoginViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    
    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("google cancelled")
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // ...
        
        SVProgressHUD.show()
        if let error = error {
            
            ZAlertView(title: "Oops...".localized(), message: error.localizedDescription, closeButtonText: "Ok".localized()) { (alert) in
                alert.dismissAlertView()
                }.show()

            SVProgressHUD.dismiss()
            
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)

        UserModel.loginUserWithCredentials(credential: credential) { (success) in
            
            if success == true {
                UserModel.info(forUserID: Auth.auth().currentUser!.uid, completion: { (userModel) in
                    DispatchQueue.main.async(execute: {
                        SVProgressHUD.dismiss()
                        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                    })
                })
            }
        }
    }
}

///MARK: Login With Facebook
extension LoginViewController: FBSDKLoginButtonDelegate {
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("fb cancelled")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
    }
    
}

