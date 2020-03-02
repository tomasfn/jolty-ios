//
//  BoxAnnotationView.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 07/12/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import MapKit

private let identifier = BoxAnnotationView.nameOfClass
private let pinImage = UIImage.boxPin()

class BoxAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        image = pinImage
        
        canShowCallout = false
        
        let btn = UIButton(type: .detailDisclosure)
        rightCalloutAccessoryView = btn
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func reusableAnnotationViewForMap(mapView: MKMapView!, forAnnotation annotation: BoxAnnotation) -> BoxAnnotationView {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? BoxAnnotationView
        
        if annotationView != nil {
            annotationView!.annotation = annotation
        } else {
            annotationView = BoxAnnotationView(annotation: annotation, reuseIdentifier: identifier)
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
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds
        var isInside = rect.contains(point)
        if (!isInside) {
            for view in self.subviews {
                isInside = view.frame.contains(point)
                if (isInside) {
                    
                    let location = annotation as! BoxAnnotation
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                         MKLaunchOptionsShowsTrafficKey: "1"]
                    location.mapItem().openInMaps(launchOptions: launchOptions)
                }
            }
        }
        return isInside
    }
    
}
