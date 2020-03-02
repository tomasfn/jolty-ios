//
//  Polygon.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 25/03/2019.
//  Copyright © 2019 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import CoreLocation

struct Points: Codable {
    let type: String
    let features: [Feature]
}

struct Feature: Codable {
    let type: String
    let properties: Properties
    let geometry: Geometry
}

struct Geometry: Codable {
    let type: String
    let coordinates: [[[Double]]]
    
    func getCoordinates() -> [CLLocationCoordinate2D] {
        
        var array = [CLLocationCoordinate2D]()
        
        for coord in coordinates {
            for coordinates in coord {
                    let newCoord = CLLocationCoordinate2D.init(latitude: coordinates.last!, longitude: coordinates.first!)
                    array.append(newCoord)
            }
        }
        
        return array
    }
}

struct Properties: Codable {
}




