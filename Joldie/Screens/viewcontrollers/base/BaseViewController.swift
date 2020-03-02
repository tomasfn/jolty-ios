//
//  BaseViewController.swift
//  Jolty
//
//  Created by Tomás Fernández on 3/5/17.
//  Copyright © 2017 Tomás Fernández Nuñez. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    var isFirstInStack : Bool {
        get { return navigationController?.viewControllers.index(of: self) == 0 }
    }
    
    var isModallyPresented : Bool {
        get { return presentingViewController != nil }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSLog("** Memory warning! at view controller: %@", self)
    }
}


//MARK: Navigation
extension BaseViewController {
    
    func backViewController() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissViewController() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

