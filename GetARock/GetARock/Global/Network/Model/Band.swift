//
//  Band.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/25.
//

import Foundation

struct Band {
//    let bandID: Int
    let name: String
//    let age: String
    let location: Location
//    let introduction: String?
//    let member: [BandMember]
//    let song: [Song]
//    let sns: [SNS]?
}

var testBands: [Band] = [
    Band(name: "레드제플린", location: Location(
        name: "레드제플린",
        address: "대구광역시 남구 명덕로 102",
        additionalAddress: "레드제플린",
        coordinate: Coordinate(latitude: 35.85672, longitude: 128.58130))),
    Band(name: "블랙로즈블랙로즈블랙", location: Location(
        name: "블랙로즈",
        address: "대한민국 대구광역시 중구 태평로2가 17-11",
        additionalAddress: nil,
        coordinate: Coordinate(latitude: 35.87478, longitude: 128.59192))),
    Band(name: "모닝샐러드", location: Location(
        name: "모닝샐러드",
        address: "대한민국 대구광역시 중구 남산동 2185-110",
        additionalAddress: nil,
        coordinate: Coordinate(latitude: 35.85785, longitude: 128.58661))),
]