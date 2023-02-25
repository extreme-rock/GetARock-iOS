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

enum Gender: String, CaseIterable {
    case man = "남자"
    case woman = "여자"
    
    var codingKye: String {
        switch self {
        case .woman:
            return "WOMAN"
        case .man:
            return "MAN"
        }
    }
}

enum Age: String, CaseIterable {
    case undertwenties = "20대 미만"
    case twenties = "20대"
    case thirties = "30대"
    case fourties = "40대"
    case fifties = "50대"
    case oversixties = "60대 이상"
    
    var codingKye: String {
        switch self {
        case .undertwenties:
            return "UNDERTWENDTIES"
        case .twenties:
            return "TWENTIES"
        case .thirties:
            return "THIRTIES"
        case .fourties:
            return "FOURTIES"
        case .fifties:
            return "FIFTIES"
        case .oversixties:
            return "OVERSIXTIES"
        }
    }
}

