//
//  MapMarkerVO.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/03/07.
//

import Foundation
import MapKit

struct MapMarkerVO: Codable {
    var bandList: [BandMarkerVO]
    var eventList: [EventMarkerVO]
}

struct BandMarkerVO: Codable {
    let id: Int
    let name: String
    let longitude: Double
    let latitude: Double
}

struct EventMarkerVO: Codable {
    let id: Int
    let name: String
    let longitude: Double
    let latitude: Double
}

extension BandMarkerVO {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
