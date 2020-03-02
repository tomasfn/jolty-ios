//
//  BaseAnnotationView.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 01/09/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//


import UIKit
import MapKit

class BaseAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        canShowCallout = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BaseAnnotationView: Reusable {
    static var identifier: String! {
        get { return nameOfClass }
    }
}
