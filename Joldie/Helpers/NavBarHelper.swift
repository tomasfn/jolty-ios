//
//  NavBarHelper.swift
//  MyWorldCup
//
//  Created by Tomás Fernández on 9/1/18.
//  Copyright © 2018 Tomás Fernández Nuñez. All rights reserved.
//

import UIKit

class NavbarHelper: NSObject {
    
    class func navBarCancelButton(target: AnyObject, selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage.menuBlack(), style: UIBarButtonItemStyle.plain, target: target, action: selector)
    }
    
    class func navBarBackButton(target: AnyObject, selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage.menuBlack(), style: UIBarButtonItemStyle.plain, target: target, action: selector)
    }
    
    class func navBarMenuButton(target: AnyObject, selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage.menu(), style: UIBarButtonItemStyle.plain, target: target, action: selector)
    }
    
    class func navBarMyLocationButton(target: AnyObject, selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage.myLocation(), style: UIBarButtonItemStyle.plain, target: target, action: selector)
    }
    
}

