//
//  BasicPopUpView.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 26/09/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit

typealias ButtonBlock = () -> (Void)

class BasicPopUpView: PopUpView {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title != nil ? title!.localized().uppercased() : nil
            setNeedsLayout()
        }
    }
    
    var _description: String? {
        didSet {
            descriptionLabel.text = _description != nil ? _description!.localized() : nil
            setNeedsLayout()
        }
    }
    
}
