//
//  TabBarController.swift
//  Jolty
//
//  Created by MacMini03 on 07/09/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import Firebase
import RAMAnimatedTabBarController
import ZAlertView

class TabBarController: RAMAnimatedTabBarController {
    
    struct MainButton {
        static var menuButton = UIButton()
    }
    
    let tbItema = RAMAnimatedTabBarItem(
        title: "".localized(),
        image: UIImage(named: "")?.maskWithColor(color: .darkGray),
        selectedImage: UIImage(named: "")?.maskWithColor(color: AppInitSetConfig.appBackColor())
    )
    
    let tbItema2 = RAMAnimatedTabBarItem(
        title: "Settings".localized(),
        image: UIImage(named: "settings")?.maskWithColor(color: .darkGray),
        selectedImage: UIImage(named: "settings")?.maskWithColor(color: AppInitSetConfig.appBackColor())
    )
    
    let tbItema3 = RAMAnimatedTabBarItem(
        title: "Activity".localized(),
        image: UIImage(named: "history")?.maskWithColor(color: .darkGray),
        selectedImage: UIImage(named: "history")?.maskWithColor(color: AppInitSetConfig.appBackColor())
    )
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //because mainview selectedindex is 1 we do this...
        tbItema2.deselectAnimation()
        tbItema3.deselectAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        if #available(iOS 11.0, *) {
//            let bottomPadding = view.safeAreaInsets.bottom
//            MainButton.menuButton.frame.origin.y = (view.bounds.height - bottomPadding) - MainButton.menuButton.frame.height
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        // create here your controllers, or override your init and pass them as parameters
        
        let ViewController1 = NavigationHelper.newJoltyViewController()
        let oneNavigationController = UINavigationController(rootViewController: ViewController1)

        tbItema.animation = RAMBounceAnimation()
        tbItema.textColor = UIColor.appMainGrayColor()
        tbItema.iconColor = UIColor.appMainGrayColor()
        
        oneNavigationController.tabBarItem = tbItema
        oneNavigationController.tabBarItem.isEnabled = false
        
        let ViewController2 = NavigationHelper.userProfileViewController()
        let twoNavigationController = UINavigationController(rootViewController: ViewController2)

        tbItema2.animation = RAMBounceAnimation()
        tbItema2.textColor = UIColor.appMainGrayColor()
        tbItema2.iconColor = UIColor.appMainGrayColor()

        twoNavigationController.tabBarItem = tbItema2
        
        let ViewController3 = NavigationHelper.userJoltysViewController()
        let threeNavigationController = UINavigationController(rootViewController: ViewController3)
        
        tbItema3.animation = RAMBounceAnimation()
        tbItema3.textColor = UIColor.appMainGrayColor()
        tbItema3.iconColor = UIColor.appMainGrayColor()

        threeNavigationController.tabBarItem = tbItema3
        
        
        self.viewControllers = [threeNavigationController, oneNavigationController, twoNavigationController]
        
        
        selectedIndex = 1

        setupMiddleButton()

        // Do any additional setup after loading the view.
    }
    
    func setupMiddleButton() {
        
        MainButton.menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        
        var menuButtonFrame = MainButton.menuButton.frame
        
        //menuButtonFrame.origin.y = (view.bounds.height - 30) - menuButtonFrame.height
        
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        
        MainButton.menuButton.frame = menuButtonFrame
        MainButton.menuButton.backgroundColor = AppInitSetConfig.appFontColor()
        
        MainButton.menuButton.layer.borderWidth = 0.5
        MainButton.menuButton.layer.borderColor = UIColor.lightGray.cgColor
        MainButton.menuButton.layer.cornerRadius = menuButtonFrame.height/2
        
        view.addSubview(MainButton.menuButton)
        
        MainButton.menuButton.setImage(UIImage(named: "findCharger")?.maskWithColor(color: AppInitSetConfig.appBackColor()), for: .normal)
        MainButton.menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        
        animatedZoomInForButtonTouched()

        view.layoutIfNeeded()
    }
    
    @objc private func menuButtonAction(sender: UIButton) {
        selectedIndex = 1
        animatedZoomInForButtonTouched()
        handMadeSelectTabBarState()
    }
    
    func animatedZoomInForButtonTouched() {
        MainButton.menuButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3,
                       animations: {
                        MainButton.menuButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        })
    }
    
    func animatedNormalSizedButtonTouched() {
        MainButton.menuButton.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3,
                       animations: {
                        MainButton.menuButton.transform = .identity
        })
    }
    
    func animatedBounceForButtonTouched() {
        MainButton.menuButton.transform = CGAffineTransform(scaleX: 0.20, y: 0.20)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 3.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        MainButton.menuButton.transform = .identity
            },
                       completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handMadeSelectTabBarState() {
        
        if selectedIndex == 0 {
            
            tbItema.deselectAnimation()
            tbItema2.deselectAnimation()

        } else if selectedIndex == 1 {
            
            tbItema2.deselectAnimation()
            tbItema3.deselectAnimation()
            
        } else if selectedIndex == 2 {
            
            if Auth.auth().currentUser == nil {
                
                ZAlertView(title: "Oops...".localized(), message: "You must be logged in".localized(), closeButtonText: "Ok".localized()) { (alert) in
                    alert.dismissAlertView()
                    }.show()
                
            }
            
            tbItema.deselectAnimation()
            tbItema3.deselectAnimation()
        
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        animatedNormalSizedButtonTouched()
        handMadeSelectTabBarState()
    }
}


