//
//  BaseTableViewCell.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/27/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit

protocol ReusableTableViewCell {
    static var _reuseIdentifier: String { get }
}

protocol TableViewCellHeights {
    static var _height: CGFloat { get }
}

protocol TableViewCellNib {
    static var _nib: UINib { get }
}

class BaseTableViewCell: UITableViewCell {
    
    var separator : UIView?
    var shouldAddSeparator : Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        
        if shouldAddSeparator {
            addSeparator()
        }
    }
    
    fileprivate func addSeparator() {
        separator = UIView()
        separator!.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        separator!.isUserInteractionEnabled = false
        addSubview(separator!)
        
        separator!.translatesAutoresizingMaskIntoConstraints = false
        
        separator!.addConstraint(NSLayoutConstraint(item: separator!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 1))
        
        separator!.superview!.addConstraint(NSLayoutConstraint(item: separator!.superview!, attribute: .bottom, relatedBy: .equal, toItem: separator!, attribute: .bottom, multiplier: 1, constant: 0))
        
        separator!.superview!.addConstraint(NSLayoutConstraint(item: separator!, attribute: .left, relatedBy: .equal, toItem: separator!.superview!, attribute: .left, multiplier: 1, constant: 15))
        
        separator!.superview!.addConstraint(NSLayoutConstraint(item: separator!.superview!, attribute: .right, relatedBy: .equal, toItem: separator!, attribute: .right, multiplier: 1, constant: 0))
    }
    
}


extension BaseTableViewCell: Reusable {
    static var identifier: String! {
        get { return nameOfClass }
    }
    
    static var nib: UINib! {
        get { return UINib(nibName: nameOfClass, bundle: nil) }
    }
}
