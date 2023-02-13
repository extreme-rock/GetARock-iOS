//
//  StringLiteral.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

enum StringLiteral {
//    static let exampleString = "안녕하세요"
    static let duplicationCheckPassed = "사용 가능해요"
    static let duplicationCheckUnPassed = "이미 사용하고 있어요"
    
    // Notifiation.Name
    static let deletePositionCell = "deletePositionCell"
    static let showPositionPlusModal = "showPositionPlusModal"
    static let deselectAllPosition = "deselectAllPosition"
    static let hideDeselectAllPositionButton = "hideDeselectAllPositionButton"
}

enum InstrumentImageName: String {
    case guitar
    case bass
    case keyboard
    case drum
    case vocal
    case etc
}
