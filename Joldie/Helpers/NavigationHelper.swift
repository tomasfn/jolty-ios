//
//  NavigationHelper.swift
//  MyWorldCup
//
//  Created by Tomás Fernández on 9/1/18.
//  Copyright © 2018 Tomás Fernández Nuñez. All rights reserved.
//


import UIKit

private let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

class NavigationHelper: NSObject {
    
    class func setRootViewController(_ viewController: UIViewController?, animated: Bool = true) {
        guard viewController != nil,
            let window = UIApplication.shared.delegate?.window else { return }
        
        if (animated == false || window!.rootViewController == nil) {
            
            window!.rootViewController = viewController
            
        } else {
            
            let snapshot = window!.snapshotView(afterScreenUpdates: true)
            viewController!.view.addSubview(snapshot!)
            
            window!.rootViewController = viewController
            UIView.animate(withDuration: 0.35, animations: { () -> Void in
                snapshot!.layer.opacity = 0
            }, completion: { (finished) -> Void in
                snapshot!.removeFromSuperview()
            })
        }
    }
}

//MARK: ViewControllers
extension NavigationHelper {
    
    class func newJoltyViewController() -> NewJoltyViewController {
        let mainStoryboard = UIStoryboard(name: "map", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: NewJoltyViewController.nameOfClass) as! NewJoltyViewController
    }
    
    class func userJoltysViewController() -> UserJoltysViewController {
        let mainStoryboard = UIStoryboard(name: "activity", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: UserJoltysViewController.nameOfClass) as! UserJoltysViewController
    }
    
    class func userProfileViewController() -> UserProfileViewController {
        let mainStoryboard = UIStoryboard(name: "profile", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: UserProfileViewController.nameOfClass) as! UserProfileViewController
    }
    
    class func loginViewController() -> LoginViewController {
        let mainStoryboard = UIStoryboard(name: "login", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: LoginViewController.nameOfClass) as! LoginViewController
    }
    
    class func signUpViewController() -> SignUpViewController {
        let mainStoryboard = UIStoryboard(name: "signup", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: SignUpViewController.nameOfClass) as! SignUpViewController
    }
    
    class func tabBarViewController() -> TabBarController {
        let mainStoryboard = UIStoryboard(name: "tabbar", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: TabBarController.nameOfClass) as! TabBarController
    }
    
}

//MARK: NavigationControllers
extension NavigationHelper {
    fileprivate class func baseNavigationController() -> BaseNavigationController {
        return mainStoryboard.instantiateViewController(withIdentifier: BaseNavigationController.nameOfClass) as! BaseNavigationController
    }
}


