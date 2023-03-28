//
//  MemberInformationVO.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/03/07.
//

import Foundation

// MARK: - MemberInformationVO
struct UserInformationVO: Codable {
    let userID: Int
    let name,age, gender: String
    let introduction: String?
    let bandList: [BandListVO]
    let instrumentList: [InstrumentListVO]
    let snsList: [SnsListVO]
    let eventList: [EventVO]
    let commentEventList: [CommentEventList]

    enum CodingKeys: String, CodingKey {
        case userID = "memberId"
        case name, introduction, age, gender, bandList, instrumentList, snsList, eventList, commentEventList
    }
}

// MARK: - BandListVO

struct BandListVO: Codable {
    let bandID: Int
    let name: String
    let memberCount: Int
    let memberAge: String

    enum CodingKeys: String, CodingKey {
        case bandID = "bandId"
        case name, memberCount, memberAge
    }
}

// MARK: - CommentEventList

struct CommentEventList: Codable {
    let eventInfo: EventVO
    let commentList: [CommentList]?
}

// MARK: - EventVO

struct EventVO: Codable {
    let eventID: Int
    let eventState, name, eventDate: String

    enum CodingKeys: String, CodingKey {
        case eventID = "eventId"
        case eventState, name, eventDate
    }
}
