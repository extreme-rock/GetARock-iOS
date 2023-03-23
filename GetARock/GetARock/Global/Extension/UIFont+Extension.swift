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
    case subTitle2
    case nameTitle
    case headline01
    case headline02
    case headline03
    case headline04
    case content
    case contentBold
    case contentLight
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
        case .subTitle2:
            return systemFont(ofSize: 22, weight: .bold)
        case .nameTitle:
            return systemFont(ofSize: 20, weight: .bold)
        
        // MARK: - Headline
        
        case .headline01:
            return systemFont(ofSize: 18, weight: .bold)
        case .headline02:
            return systemFont(ofSize: 16, weight: .bold)
        case .headline03:
            return systemFont(ofSize: 16, weight: .light)
        case .headline04:
            return systemFont(ofSize: 16, weight: .regular)
            
        // MARK: - content
        
        case .content:
            return systemFont(ofSize: 14, weight: .regular)
        case .contentBold:
            return systemFont(ofSize: 14, weight: .bold)
        case .contentLight:
            return systemFont(ofSize: 14, weight: .light)
            
        // MARK: - content
        
        case .caption:
            return systemFont(ofSize: 12, weight: .regular)
        }
    }
}
