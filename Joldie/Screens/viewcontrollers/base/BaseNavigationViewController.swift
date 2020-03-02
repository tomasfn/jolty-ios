//
//  BaseNavigationViewController.swift
//  Jolty
//
//  Created by Tomás Fernández on 28/4/17.
//  Copyright © 2017 Tomás Fernández Nuñez. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeNavbarBottomLine()
    }
    
    fileprivate func removeNavbarBottomLine() {
        
    }
    
}

