//
//  Event.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/26.
//

import Foundation

struct Event {
//    let eventID: Int
    let name: String
//    let category: EventCategory
//    let state: EventState
    let location: Location
//    let startDate: Date
//    let endDate: Date
//    let introdunction: String?
//    let band: Band
}

struct EventDummyData {
    static let testEvents: [Event] = [
        Event(name: "이벤트1", location: Location(
            name: "밴드1",
            address: "대한민국 대구광역시 중구 대신동 291-61",
            additionalAddress: "2층",
            coordinate: Coordinate(latitude: 35.86677, longitude: 128.57930))),
        Event(name: "이벤트2", location: Location(
            name: "밴드2",
            address: "대구광역시 수성구 달구벌대로 2354",
            additionalAddress: "시카고 라이브클럽",
            coordinate: Coordinate(latitude: 35.85922, longitude: 128.61990))),
        Event(name: "이벤트3", location: Location(
            name: "밴드3",
            address: "대한민국 대구광역시 남구 대명동 1883-3",
            additionalAddress: "오투뮤직스토리 지하",
            coordinate: Coordinate(latitude: 35.85388, longitude: 128.58477))),
    ]
}
