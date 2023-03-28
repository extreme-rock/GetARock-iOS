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
    var instrumentList: [InstrumentList]
    let snsList: [SnsList]
}

enum Gender: String, CaseIterable, Codable {
    case man = "남자"
    case woman = "여자"
    
    enum CodingKeys: String, CodingKey {
        case man = "MAN"
        case woman = "WOMAN"
        
        var inKorean: String {
            switch self {
            case .man:
                return "남자"
            case .woman:
                return "여자"
            }
        }
    }
    
    var inEnglish: String {
        switch self {
        case .man:
            return "MAN"
        case .woman:
            return "WOMAN"
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
        case undertwenties = "UNDERTWENTIES"
        case twenties = "TWENTIES"
        case thirties = "THIRTIES"
        case fourties = "FOURTIES"
        case fifties = "FIFTIES"
        case oversixties = "OVERSIXTIES"
        
        var inKorean: String {
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
    
    var inEnglish: String {
        switch self {
        case .undertwenties:
            return "UNDERTWENTIES"
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

enum Instrument: String, CaseIterable {
    case guitar
    case bass
    case keyboard
    case drum
    case vocal
    case etc = ""
    
    enum CodingKey: String {
        case guitar = "기타"
        case bass = "베이스"
        case keyboard = "키보드"
        case drum = "드럼"
        case vocal = "보컬"
        case etc = ""
        
        var inEnglish: String {
            switch self {
            case .guitar:
                return "guitar"
            case .bass:
                return "bass"
            case .keyboard:
                return "keyboard"
            case .drum:
                return "drum"
            case .vocal:
                return "vocal"
            case .etc:
                return "etc"
            }
        }
    }
    
    var imageName: String {
        switch self {
        case .guitar:
            return "guitar"
        case .bass:
            return "bass"
        case .keyboard:
            return "keyboard"
        case .drum:
            return "drum"
        case .vocal:
            return "vocal"
        case .etc:
            return "etc"
        }
    }
    
    var inKorean: String {
        switch self {
        case .guitar:
            return "기타"
        case .bass:
            return "베이스"
        case .keyboard:
            return "키보드"
        case .drum:
            return "드럼"
        case .vocal:
            return "보컬"
        case .etc:
            return ""
        }
    }
}
