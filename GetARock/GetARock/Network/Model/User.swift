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

enum Gender: String, CaseIterable, Codable {
    case man = "남자"
    case woman = "여자"
    
    enum CodingKeys: String, CodingKey {
        case man = "MAN"
        case woman = "WOMAN"
        
        var rawGenderValue: String {
            switch self {
            case .woman:
                return "여자"
            case .man:
                return "남자"
            }
        }
    }
    
    var codingKey: String {
        switch self {
        case .woman:
            return "WOMAN"
        case .man:
            return "MAN"
        }
    }
}

enum Age: String, CaseIterable, Codable {
    case undertwenties = "20대 미만"
    case twenties = "20대"
    case thirties = "30대"
    case fourties = "40대"
    case fifties = "50대"
    case oversixties = "60대 이상"
    
    enum CodingKeys: String, CodingKey {
        case undertwenties = "UNDERTWENDTIES"
        case twenties = "TWENTIES"
        case thirties = "THIRTIES"
        case fourties = "FOURTIES"
        case fifties = "FIFTIES"
        case oversixties = "OVERSIXTIES"
        
        var rawAgeValue: String {
            switch self {
            case .undertwenties:
                return "20대 미만"
            case .twenties:
                return "20대"
            case .thirties:
                return "30대"
            case .fourties:
                return "40대"
            case .fifties:
                return "50대"
            case .oversixties:
                return "60대 이상"
            }
        }
    }
    
    var codingKey: String {
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

