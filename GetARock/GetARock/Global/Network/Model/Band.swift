//
//  Band.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/25.
//

import Foundation

struct Band {
//    let bandID: UUID
    let name: String
//    let age: String
    let location: Location
//    let introduction: String?
//    let member: [BandMember]
    var song: [Song]?
    var sns: SNS
}

struct BandDummyData {
    static var testBands: [Band] = [
        Band(name: "레드제플린", location: Location(
            name: "레드제플린",
            address: "대구광역시 남구 명덕로 102",
            additionalAddress: "레드제플린",
            coordinate: Coordinate(latitude: 35.85672, longitude: 128.58130)),
            song: [Song(title: "노엘갤러거는 최고다", artist: "오아시스", link: nil),
                   Song(title: "Champagne Supernova", artist: "OASIS", link: "https://youtu.be/tI-5uv4wryI"),
                   Song(title: "Little by Little", artist: "OASIS", link: "https://youtu.be/ic-Na--7_NI")],
             sns: SNS(youtube: "UCUDVBtnOQi4c7E8jebpjc9Q", instagram: nil, soundCloud: nil)
        ),
        Band(name: "블랙로즈블랙로즈블랙", location: Location(
            name: "블랙로즈",
            address: "대한민국 대구광역시 중구 태평로2가 17-11",
            additionalAddress: nil,
            coordinate: Coordinate(latitude: 35.87478, longitude: 128.59192)),
            sns: SNS(youtube: "UCUDVBtnOQi4c7E8jebpjc9Q", instagram: "UCUDVBtnOQi4c7E8jebpjc9Q", soundCloud: nil)
        ),
        Band(name: "모닝샐러드", location: Location(
            name: "모닝샐러드",
            address: "대한민국 대구광역시 중구 남산동 2185-110",
            additionalAddress: nil,
            coordinate: Coordinate(latitude: 35.85785, longitude: 128.58661)),
        sns: SNS(youtube: nil, instagram: nil, soundCloud: nil)),
    ]
}
