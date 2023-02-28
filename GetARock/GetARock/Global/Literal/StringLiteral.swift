//
//  StringLiteral.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

enum StringLiteral {
    static let duplicationCheckPassed = "사용 가능해요"
    static let duplicationCheckUnPassed = "이미 사용하고 있어요"
    static let needDuplicationCheck = "중복 확인이 필요해요"
    
    // Setting
    
    static let privacyPolicyNotionURL = "https://fascinated-neem-285.notion.site/907e9564134e4bbfa1b026324e85339d"
    static let thirdPartyInfoNotionURL = "https://fascinated-neem-285.notion.site/72e315a117dd402aa5056cb4244b7f43"
    
    // 약관 link
    static let personalInfoTermLink = "https://fascinated-neem-285.notion.site/5c3e8ec8b2a94e149e55e8e12cb1a915"
    static let serviceTermLink = "https://fascinated-neem-285.notion.site/4ccebe442f8b4c3c98f54c719a5636d8"
}

enum Instrument: String {
    case guitar = "기타"
    case bass = "베이스"
    case keyboard = "키보드"
    case drum = "드럼"
    case vocal = "보컬"
    case etc = ""
    
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
}
