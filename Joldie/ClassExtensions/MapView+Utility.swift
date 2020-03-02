//
//  MapView+Utility.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 31/08/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import MapKit.MKMapView

extension MKMapView {
    
    @objc func centerInCoordinates(_ coordinates: CLLocationCoordinate2D, latitudDelta: CLLocationDegrees = 0.01, longitudeDelta: CLLocationDegrees = 0.01, animated: Bool = true) {
        let span = MKCoordinateSpan(latitudeDelta: latitudDelta, longitudeDelta: longitudeDelta)
        centerInCoordinates(coordinates, span: span, animated: animated)
    }
    
    @objc func centerInCoordinates(_ coordinates: CLLocationCoordinate2D, span: MKCoordinateSpan, animated: Bool = true) {
        let region = MKCoordinateRegion(center: coordinates, span: span)
        setRegion(regionThatFits(region), animated: true)
    }
    
    @objc func centerInUserLocation(animated: Bool = true) {
        guard let userCoords = userLocation.location?.coordinate else { return }
        setCenter(userCoords, animated: animated)
    }
    
    func refreshUserLocationAnnotation() {
        guard showsUserLocation == true else { return }
        
        showsUserLocation = false
        showsUserLocation = true
    }
    
}
