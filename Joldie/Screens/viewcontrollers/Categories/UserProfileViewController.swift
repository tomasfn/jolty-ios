//
//  UserProfileViewController.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/27/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import RAMPaperSwitch
import SVProgressHUD
import Firebase
import Toast_Swift
import IQDropDownTextField
import AvatarImageView
import SDWebImage
import ZAlertView

class UserProfileViewController: BaseViewController {
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var fullNameTxtField: UITextField!
    @IBOutlet weak var selectedRangeTxtField: IQDropDownTextField!
    
    @IBOutlet weak var searchDistanceDescriptionLbl: UILabel!
    @IBOutlet weak var userCalificationImgView: UIImageView!
        
    @IBOutlet weak var switcherDescriptionLbl: UILabel!
    @IBOutlet weak var userFullnameIconImgView: UIImageView!
    @IBOutlet weak var emailIconImgView: UIImageView!
    @IBOutlet weak var distanceRangeIcon: UIImageView!
    @IBOutlet weak var lightningIconImgView: UIImageView!
    
    @IBOutlet var userProfileImgView: AvatarImageView! {
        didSet {
            userProfileImgView.contentMode = .scaleAspectFit
            userProfileImgView.layer.borderWidth = 3
            userProfileImgView.layer.borderColor = UIColor.appMainGrayColor().cgColor
            userProfileImgView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var shareSwitch: RAMPaperSwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.title = "My Settings".localized()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: AppInitSetConfig.appFontColor(),
                                                                        NSAttributedStringKey.font: UIFont.OpenSansRegular(fontSize: 22)]
        
        shareSwitch.layer.borderWidth = 1
        shareSwitch.layer.cornerRadius = 16.0
        shareSwitch.layer.borderColor = UIColor.appMainGrayColor().cgColor
        
        self.view.backgroundColor = AppInitSetConfig.appFontColor()
        
        shareSwitch.tintColor = AppInitSetConfig.appFontColor()
        
        
        switcherDescriptionLbl.text = "I almost always carry the charger with me and I am open to share it.".localized()
        
        switcherDescriptionLbl.textColor = UIColor.appMainGrayColor()
        userCalificationImgView.maskWith(color: UIColor.appMainGrayColor())
        
        emailIconImgView.maskWith(color: AppInitSetConfig.appFontColor())
        userFullnameIconImgView.maskWith(color: AppInitSetConfig.appFontColor())
        distanceRangeIcon.maskWith(color: AppInitSetConfig.appFontColor())        
        lightningIconImgView.maskWith(color: UIColor.appMainGrayColor())
        
        shareSwitch.addTarget(self, action: #selector(self.switchValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        userProfileImgView.roundView()
        setColorAnimatedChanges()
        setRangePicker()
        configureViewWithUserData()

        if Auth.auth().currentUser == nil {
            navigationItem.rightBarButtonItem = nil
        } else {
            setRightNavBarButton()
        }

        //4 fun
        setGreenWhisperEasterEgg()
    }
    
    func setRangePicker() {
        
        if Auth.auth().currentUser == nil {
            selectedRangeTxtField.isEnabled = false
        } else {
            selectedRangeTxtField.isEnabled = true
        }
        
        selectedRangeTxtField.itemList = ["100", "200", "300", "400"]
        
        let selectedRange = UserModelShared.currentUserData(attribute: "selected_range")
        
        selectedRangeTxtField.attributedPlaceholder = NSAttributedString(string: selectedRange!, attributes: [
            .foregroundColor: UIColor.appMainGrayColor()
            ])
        selectedRangeTxtField.isOptionalDropDown = false
        selectedRangeTxtField.delegate = self
        searchDistanceDescriptionLbl.text = "Search distance in meters".localized()
    }
    
    func setColorsForCurrentSwitchState() {
        
        let currentSwitchState = Bool(UserModelShared.currentUserData(attribute: "share_lightning"))
        
        shareSwitch.setOn(currentSwitchState!, animated: false)
        
        if currentSwitchState == true {
            self.view.backgroundColor = AppInitSetConfig.appBackColor()
                        emailIconImgView.maskWith(color: AppInitSetConfig.appFontColor())
                        userFullnameIconImgView.maskWith(color: AppInitSetConfig.appFontColor())
                        distanceRangeIcon.maskWith(color: AppInitSetConfig.appFontColor())
                        shareSwitch.tintColor = AppInitSetConfig.appFontColor()
        } else {
            self.view.backgroundColor = AppInitSetConfig.appFontColor()
                        emailIconImgView.maskWith(color: AppInitSetConfig.appBackColor())
                        userFullnameIconImgView.maskWith(color: AppInitSetConfig.appBackColor())
                        distanceRangeIcon.maskWith(color: AppInitSetConfig.appBackColor())
                        shareSwitch.tintColor = AppInitSetConfig.appBackColor()
        }
      }
    
    override func viewDidLoad() {
        }
    
        func setRightNavBarButton() {
            let button = UIButton.init(type: .custom)
            button.setImage(UIImage.logoutUser(), for: UIControlState.normal)
            button.addTarget(self, action: #selector(wantToLogOut), for: UIControlEvents.touchUpInside)
            button.frame = CGRect(x: 0, y: 0, width: 20, height: 35)
            button.contentMode = .scaleAspectFit
            let rightBarButton = UIBarButtonItem(customView: button)
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
    
        func setColorAnimatedChanges() {
            
            self.shareSwitch.animationDidStartClosure = {(onAnimation: Bool) in
                UIView.transition(with: self.emailTxtField, duration: self.shareSwitch.duration, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                    self.emailIconImgView.tintColor = onAnimation ? AppInitSetConfig.appFontColor() : AppInitSetConfig.appBackColor()
                    self.distanceRangeIcon.tintColor = onAnimation ? AppInitSetConfig.appFontColor() : AppInitSetConfig.appBackColor()
                    self.userFullnameIconImgView.tintColor = onAnimation ? AppInitSetConfig.appFontColor() : AppInitSetConfig.appBackColor()
                }, completion:nil)
            }
        }
}


// MARK: Switcher Purposes
extension UserProfileViewController {
    
    @objc func switchValueChanged(sender: UISwitch!)
    {
        guard Auth.auth().currentUser != nil else {
            
            ZAlertView(title: "Oops...".localized(), message: "Nothing happened. You must be logged in".localized(), closeButtonText: "Ok".localized()) { (alert) in
                alert.dismissAlertView()
                }.show()

            return }
        
        if sender.isOn {
            ShowTurnedOnToast()
            UserModel.isChargerSharer(newState: "true")

        } else {
            ShowTurnedOffToast()
            UserModel.isChargerSharer(newState: "false")

        }
    }
    
    func ShowTurnedOffToast() {
        self.view.hideAllToasts()
        self.view.makeToast("Push notifications now won't be received when someone near request a charger".localized(), duration: 2.5, position: .bottom)
    }
    
    func ShowTurnedOnToast() {
        self.view.hideAllToasts()
        self.view.makeToast("Push notifications now will be received when someone near you request a charger".localized(), duration: 2.5, position: .bottom)
    }
}



extension UserProfileViewController {
    
    @objc func wantToLogOut() {
        
        PopUpHelper.showLogOutAlertPopUp(leftButtonBlock: { (alert) in
            self.logOutUser()
            alert.dismissAlertView()
        }, rightButtonBlock: { (alert) in
            alert.dismissAlertView()
        }).show()
    
    }
    
    @objc func logOutUser() {
        
        SVProgressHUD.show()
        UserModel.logOutUser { (success) in
            if success == true {
                SVProgressHUD.dismiss()
                self.viewWillAppear(true)
            }
        }
    }
    
    func configureViewWithUserData() {
        
        let name = UserModelShared.currentUserData(attribute: "name")
        let email = UserModelShared.currentUserData(attribute: "email")
        let lastName = UserModelShared.currentUserData(attribute: "last_name")
        let selectedRange = UserModelShared.currentUserData(attribute: "selected_range")
        let profilePicUrl = UserModelShared.currentUserData(attribute: "profilepic_url")
        let currentState = Bool(UserModelShared.currentUserData(attribute: "share_lightning"))
        
        emailTxtField.text = email
        fullNameTxtField.text = "\(String(describing: name!)) \(String(describing: lastName!))"
        selectedRangeTxtField.setSelectedItem(selectedRange, animated: false)
        shareSwitch.setOn(currentState!, animated: false)
        
        if profilePicUrl == "" {
            userProfileImgView.image = UIImage.profilePlaceholder()
        } else {
            let urlProfilepic = URL(string: profilePicUrl!)
            userProfileImgView.sd_setImage(with: urlProfilepic, placeholderImage: UIImage.profilePlaceholder())
        }
    }
}


extension UserProfileViewController: IQDropDownTextFieldDelegate, IQDropDownTextFieldDataSource {
    
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        Database.database().reference().child("Users").child((Auth.auth().currentUser!.uid)).child("user_details").child("selected_range").setValue(item)
        
        var userInfo = UserDefaults.standard.dictionary(forKey: "userDetails")
        userInfo?.updateValue(item!, forKey: "selected_range")
        UserDefaults.standard.set(userInfo, forKey: "userDetails")
    }
    
}


//This is for fun reasons anyways
extension UserProfileViewController {
    
    func setGreenWhisperEasterEgg() {
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(easterEggTapped))
        doubleTapRecognizer.numberOfTapsRequired = 4
        
        // add gesture recognizer to imageview
        userFullnameIconImgView.isUserInteractionEnabled = true
        userFullnameIconImgView.addGestureRecognizer(doubleTapRecognizer)
    }
    
    @objc func easterEggTapped() {
        let whispa = UIImageView(image: UIImage(named: "greenwhispa"))
        whispa.center = view.center
        view.addSubview(whispa)
        //animate and remove whispa elemnent
        UIView.animate(withDuration: 0.03,
                       delay:0.0,
                       options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
                       animations: { whispa.alpha = 0 },
                       completion: nil)
        
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            self.view.layer.removeAllAnimations()
            whispa.removeFromSuperview()
        }
    }
    
}


