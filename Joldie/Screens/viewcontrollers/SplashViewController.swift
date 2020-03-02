//
//  SplashViewController.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/22/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SVProgressHUD
import Lottie
import IQKeyboardManager
import Firebase
import RAMAnimatedTabBarController
import MapKit
import ZAlertView

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimationView()
    
        //logoutuser
       //UserModel.logOutUser { (success) in

        //}
        
        var rootVC: UIViewController!
    
        rootVC = NavigationHelper.tabBarViewController()
        
        if InitSet.currentInitSet?.backHexaColor.isEmpty == true {
            // this color must be always same as current firebase initset config
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]

            self.view.backgroundColor = UIColor.init(hexString: "#57A0D3")
        } else {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : AppInitSetConfig.appFontColor()]
            self.view.backgroundColor = AppInitSetConfig.appBackColor()
        }
        
        let url = "https://joldie-tlm.firebaseio.com/InitSet.json"
        
        let response = Alamofire.request(url, method: HTTPMethod.get, parameters: nil, headers: nil).responseJSON { response in
            
            if let json = response.result.value {
                self.setInitSetApp(json: json as! InitSetJSON)
                
                if Auth.auth().currentUser != nil {
                    
                    UserModel.info(forUserID: Auth.auth().currentUser!.uid, completion: { (userModel) in
                        DispatchQueue.main.async(execute: {
                            NavigationHelper.setRootViewController(rootVC)
                        })
                    })
                    
                }  else {
                    NavigationHelper.setRootViewController(rootVC)
                    
                }
                
            }
        }
    }
    
    
    func showAnimationView() {
        let animationView = LOTAnimationView(name: "batterysplashwhite")
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 400)
        animationView.contentMode = .scaleAspectFit
        animationView.center.y = view.center.y
        animationView.center.x = view.center.x
        
        self.view.addSubview(animationView)
        
        animationView.loopAnimation = true
        
        animationView.play(fromProgress: 0.4, toProgress: 1) { (finished) in
            // Do Something
        }
        
    }
    
    func setInitSetApp(json: InitSetJSON) {
        InitSet.currentInitSet = InitSet(JSON: json)
        
        UINavigationBar.appearance().barTintColor = AppInitSetConfig.appBackColor()
        UINavigationBar.appearance().tintColor = AppInitSetConfig.appFontColor()
        UINavigationBar.appearance().isTranslucent = false
        UIApplication.shared.statusBarView?.tintColor = AppInitSetConfig.appBackColor()
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.custom)
        SVProgressHUD.setForegroundColor(AppInitSetConfig.appBackColor())
        SVProgressHUD.setBackgroundColor(AppInitSetConfig.appFontColor())
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        ZAlertView.positiveColor            = AppInitSetConfig.appBackColor()
        ZAlertView.negativeColor            = UIColor.color("#FF6C66")
        ZAlertView.textFieldTextColor       = .black
        ZAlertView.textFieldBackgroundColor = UIColor.color("#e8e8e8")
        ZAlertView.textFieldBorderColor     = .white
        ZAlertView.normalTextColor     = .black
        //ZAlertView.messageColor = .black
        ZAlertView.messageFont = UIFont.systemFont(ofSize: 16)
        ZAlertView.buttonHeight = 40
                
        //ZAlertView.alertTitleFont = UIFont.OpenSansBold(fontSize: 20)
        //ZAlertView.messageFont = UIFont.OpenSansRegular(fontSize: 16)
        //ZAlertView.buttonFont = UIFont.OpenSansRegular(fontSize: 18)
    }
}
