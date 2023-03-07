//
//  EventDataVO.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/21.
//

import Foundation

// MARK: - EventDataVO
struct EventDataVO: Codable {
    let eventID: Int
    let name, introduction, eventCategory, eventState: String
    let address: Address
    let startTime, endTime: String
    let band: BandData // 이미 있는 Band랑 이름 겹쳐서 임시로 이름 변경함
    let commentList: [CommentList]

    enum CodingKeys: String, CodingKey {
        case eventID = "eventId"
        case name, introduction, eventCategory, eventState, address, startTime, endTime, band, commentList
    }
}

// MARK: - Band
struct BandData: Codable {
    let bandID: Int
    let name: String
    let memberCount: Int
    let memberAge: String

    enum CodingKeys: String, CodingKey {
        case bandID = "bandId"
        case name, memberCount, memberAge
    }
}
//
//// MARK: - CommentList
//struct CommentList: Codable {
//    let commentID: Int
//    let memberName, comment, createdDate: String
//
//    enum CodingKeys: String, CodingKey {
//        case commentID = "commentId"
//        case memberName, comment, createdDate
//    }
//}
