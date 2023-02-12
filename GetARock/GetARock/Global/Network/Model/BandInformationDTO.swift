//
//  BandInformationDTO.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/12.
//

import Foundation

// MARK: - BandCreate
struct BandInformationDTO: Codable {
    let name: String
    let address: Address
    let songList: [SongList]
    let memberList: [MemberList]
    let introduction: String
    let snsList: [SnsList]
}

// MARK: - Address
struct Address: Codable {
    let city, street, detail: String
    let longitude, latitude: Double
}

// MARK: - MemberList
struct MemberList: Codable {
    let memberID: Int?
    let name, memberState: String
    let instrumentList: [InstrumentList]

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case name, memberState, instrumentList
    }
}

// MARK: - InstrumentList
struct InstrumentList: Codable {
    let name: Name
}

enum Name: String, Codable {
    case base = "base"
    case guitar = "guitar"
}

// MARK: - SnsList
struct SnsList: Codable {
    let type: String
    let link: String?
}

// MARK: - SongList
struct SongList: Codable {
    let name, artist: String
    let link: String?
}
