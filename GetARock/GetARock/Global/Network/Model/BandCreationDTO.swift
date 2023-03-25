//
//  BandInformationDTO.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/12.
//

import Foundation

class BandCreationDTO: Codable {
    var name: String
    var address: Address
    var songList: [SongList]? // 정보 입력시 선택사항
    var memberList: [MemberList]
    var introduction: String? // 정보 입력시 선택사항
    var snsList: [SnsList]? // 정보 입력시 선택사항
    
    init(name: String, address: Address, songList: [SongList]?, memberList: [MemberList], introduction: String?, snsList: [SnsList]?) {
        self.name = name
        self.address = address
        self.songList = songList
        self.memberList = memberList
        self.introduction = introduction
        self.snsList = snsList
    }
}

struct Address: Codable {
    var city, street, detail: String
    var longitude, latitude: Double
}

struct MemberList: Codable {
    let memberId: Int?
    let name: String
    let memberState: MemberState
    let instrumentList: [InstrumentList]
}

struct SearchedMemberList: Codable {
    let memberId: Int?
    let name, gender, age: String
    let memberState: MemberState
    let instrumentList: [SearchedUserInstrumentList]
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
