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
    let category: EventCategory
    let state: EventState
    let location: Location
    let startTime, endTime: String
    //    let introdunction: String?
    //    let band: Band
}

enum EventCategory: String, Codable {
    case bandRecruiting = "BAND_RECRUITING"
    case eventPR = "EVENT_PR"
    case ect = "ETC"
}

enum EventState: String, Codable {
    case none = "NONE"
    case ready = "READY"
    case open = "OPEN"
    case close = "CLOSE"
    case canceled = "CANCELED"
}

struct EventDummyData {
    static let testEvents: [Event] = [
        Event(name: "이벤트1",
              category: EventCategory.ect,
              state: EventState.open,
              location: Location(
                name: "밴드1",
                address: "대한민국 대구광역시 중구 대신동 291-61",
                additionalAddress: "2층",
                coordinate: Coordinate(latitude: 35.86677, longitude: 128.57930)),
              startTime:"2023-02-21 15:45:00",
              endTime: "2023-02-21 18:45:00"
             ),
        Event(name: "이벤트2",
              category: EventCategory.eventPR,
              state: EventState.canceled,
              location: Location(
                name: "밴드2",
                address: "대구광역시 수성구 달구벌대로 2354",
                additionalAddress: "시카고 라이브클럽",
                coordinate: Coordinate(latitude: 35.85922, longitude: 128.61990)),
              startTime:"2023-02-21 15:45:00",
              endTime: "2023-02-21 18:45:00"),
        Event(name: "이벤트3",
              category: EventCategory.eventPR,
              state: EventState.close,
              location: Location(
                name: "밴드3",
                address: "대한민국 대구광역시 남구 대명동 1883-3",
                additionalAddress: "오투뮤직스토리 지하",
                coordinate: Coordinate(latitude: 35.85388, longitude: 128.58477)),
              startTime:"2023-02-21 15:45:00",
              endTime: "2023-02-21 18:45:00")
    ]
}
