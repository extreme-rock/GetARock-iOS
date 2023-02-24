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
    let songList: [SongList]? // 정보 입력시 선택사항
    var memberList: [MemberList]
    let introduction: String? // 정보 입력시 선택사항
    let snsList: [SnsList]? // 정보 입력시 선택사항
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
    let name: String
}

struct SnsList: Codable {
    let type: SnsType
    let link: String?
}

struct SongList: Codable {
    let name, artist: String
    let link: String?
}
