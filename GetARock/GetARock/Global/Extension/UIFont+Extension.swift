//
//  UIFont+Extension.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/20.
//

import UIKit

enum FontType {
    case largeTitle01
    case largeTitle02
    case subTitle
    case headline01
    case headline02
    case headline03
    case content
    case contentBold
    case caption
}

extension UIFont {
    static func setFont(_ type: FontType) -> UIFont {
        switch type {
        
        // MARK: - Title
        
        case .largeTitle01:
            return systemFont(ofSize: 34, weight: .bold)
        case .largeTitle02:
            return systemFont(ofSize: 30, weight: .bold)
        case .subTitle:
            return systemFont(ofSize: 18, weight: .light)
        
        // MARK: - Headline
        
        case .headline01:
            return systemFont(ofSize: 18, weight: .bold)
        case .headline02:
            return systemFont(ofSize: 16, weight: .bold)
        case .headline03:
            return systemFont(ofSize: 16, weight: .light)
        
        // MARK: - content
        
        case .content:
            return systemFont(ofSize: 14, weight: .regular)
        case .contentBold:
            return systemFont(ofSize: 14, weight: .bold)
        
        // MARK: - content
        
        case .caption:
            return systemFont(ofSize: 12, weight: .regular)
        }
    }
}
