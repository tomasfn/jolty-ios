//
//  MapOverlayView.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 03/09/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit

protocol PreferredHeight {
    static var preferredHeight: Float { get }
}

class MapOverlayView: UIView, PreferredHeight {
    
    class var preferredHeight: Float { return 0 }
    
}
