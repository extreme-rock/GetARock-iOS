//
//  BandInformationVO.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/22.
//

import Foundation

// MARK: - BandInformationVO
struct BandInformationVO: Codable {
    let bandID: Int
    let name, introduction, age: String
    let address: Address
    let memberList: [MemberList]
    let songList: [SongList]
    let snsList: [SnsList]
    let eventList: [EventList]
    let commentList: [CommentList]

    enum CodingKeys: String, CodingKey {
        case bandID = "bandId"
        case name, introduction, age, address, memberList, songList, snsList, eventList
        case commentList = "comment_list"
    }
}

// MARK: - CommentList
struct CommentList: Codable {
    let commentID: Int
    let memberName, comment, createdDate: String

    enum CodingKeys: String, CodingKey {
        case commentID = "commentId"
        case memberName, comment, createdDate
    }
}

// MARK: - EventList
struct EventList: Codable {
    let eventID: Int
    let eventState, name, eventDate: String

    enum CodingKeys: String, CodingKey {
        case eventID = "eventId"
        case eventState, name, eventDate
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

