//
//  BandInformationDTO.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/12.
//

import Foundation

struct BandInformationDTO: Codable {
    let name: String
    let address: Address
    let songList: [SongList]
    let memberList: [MemberList]
    let introduction: String
    let snsList: [SnsList]
}

struct Address: Codable {
    let city, street, detail: String
    let longitude, latitude: Double
}

struct MemberList: Codable {
    let memberId: Int?
    let name: String
    let memberState: MemberState
    let instrumentList: [InstrumentList]
}

struct InstrumentList: Codable {
    let name: Name
}

//MARK: Name
enum Name: String, Codable {
    case base = "base"
    case guitar = "guitar"
}

enum SnsType: String, Codable {
    case youtube = "YOUTUBE"
    case instagram = "INSTAGRAM"
    case soundcloud = "SOUNDCLOUD"
}

enum MemberState: String, Codable {
    case inviting = "INVITING"
    case approved = "APPROVE"
    case denied = "DENY"
}

// MARK: - SnsList
struct SnsList: Codable {
    let type: SnsType
    let link: String?
}

// MARK: - SongList
struct SongList: Codable {
    let name, artist: String
    let link: String?
}
