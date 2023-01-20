//
//  UIFont+Extension.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/20.
//

import UIKit

enum FontType {
    case largeTitle
    case mediumTitle
    case smallTitle
    case headline
    case subHeadline
    case content
    case contentBold
    case caption
}

extension UIFont {
    static func setFont(_ type: FontType) -> UIFont {
        switch type {
        case .largeTitle:
            return systemFont(ofSize: 34, weight: .bold)
        case .mediumTitle:
            return systemFont(ofSize: 18, weight: .light)
        case .smallTitle:
            return systemFont(ofSize: 16, weight: .light)
        case .headline:
            return systemFont(ofSize: 18, weight: .bold)
        case .subHeadline:
            return systemFont(ofSize: 16, weight: .bold)
        case .content:
            return systemFont(ofSize: 14, weight: .regular)
        case .contentBold:
            return systemFont(ofSize: 14, weight: .bold)
        case .caption:
            return systemFont(ofSize: 12, weight: .regular)
        }
    }
}
