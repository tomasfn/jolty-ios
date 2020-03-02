//
//  UserAnnotationView.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 01/09/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

private let identifier = UserAnnotationView.nameOfClass

class UserAnnotationView: BaseAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        canShowCallout = false
        
        let btn = UIButton(type: .detailDisclosure)
        rightCalloutAccessoryView = btn
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func reusableAnnotationViewForMap(mapView: MKMapView!, forAnnotation annotation: MKAnnotation) -> UserAnnotationView {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? UserAnnotationView
        
        if annotationView != nil {
            annotationView!.annotation = annotation
        } else {
            annotationView = UserAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        return annotationView!
    }
    
    func calloutTapped() {
        
    }
    
    func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil) {
            self.superview?.bringSubview(toFront: self)
        }
        return hitView
    }
    
}
