//
//  Member.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/24.
//

import Foundation

struct User: Codable {
    let memberId: Int?
    let name: String
    let age: String
    let gender: String
    let introduction: String?
    let instrumentList: [InstrumentList]
    let snsList: [SnsList]
}

enum Gender: String {
    case woman = "WOMAN"
    case man = "MAN"
}

enum Age: String {
    case undertwenties = "UNDERTWENDTIES"
    case twenties = "TWENTIES"
    case thirties = "THIRTIES"
    case fourties = "FOURTIES"
    case fifties = "FIFTIES"
    case oversixties = "OVERSIXTIES"
}
