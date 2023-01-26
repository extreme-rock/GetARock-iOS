//
//  Coordinate.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/25.
//

import Foundation
import MapKit

struct Coordinate: Codable {
    typealias LocationDegrees = Double
    
    var latitude: LocationDegrees
    var longitude: LocationDegrees
}

extension Coordinate {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
