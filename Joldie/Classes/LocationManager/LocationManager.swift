//
//  LocationManager.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/28/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import CoreLocation

typealias LocationManagerFailureBlock = (CLLocationManager, NSError) -> Void
typealias LocationManagerUpdateLocationsBlock = (CLLocationManager, [CLLocation]) -> Void
typealias LocationManagerChangeAuthorizationStatusBlock = (CLLocationManager, CLAuthorizationStatus) -> Void

class LocationManager: NSObject {
    
    static let sharedManager = LocationManager()
    private var locationManager = CLLocationManager()
    
    var failureBlock: LocationManagerFailureBlock?
    var updatedLocationsBlock: LocationManagerUpdateLocationsBlock?
    var changeAuthorizationStatusBlock: LocationManagerChangeAuthorizationStatusBlock?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.activityType = .automotiveNavigation
    }
    
    var lastLocation: CLLocation? {
        return locationManager.location
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
}

// MARK: Authorization
extension LocationManager {
    
    func locationEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() == false { return false }
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            return true
        } else {
            return false
        }
    }
}

// MARK: CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updatedLocationsBlock?(manager, locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        failureBlock?(manager, error as NSError)
        debugPrint("Error in locationManager: \(error)")
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        changeAuthorizationStatusBlock?(manager, status)
        
        switch status {
        case .authorizedWhenInUse:
            debugPrint("CLAuthorizationStatus: AuthorizedWhenInUse")
        case .denied:
            debugPrint("CLAuthorizationStatus: Denied")
        default:
            break
        }
        
    }
    
    class func getCityName(coords: CLLocation, completion: @escaping (String) -> Swift.Void) {
        
        var cityString : String = ""
        
        CLGeocoder().reverseGeocodeLocation(coords) { (placemark, error) in
            if error != nil {
                print("Hay un error")
                completion("none")
            } else {
                
                let place = placemark! as [CLPlacemark]
                if place.count > 0 {
                    let place = placemark![0]
                    if place.locality != nil {
                        cityString = place.locality!
                        completion(cityString)
                    }
                }
            }
        }
        
    }
}
