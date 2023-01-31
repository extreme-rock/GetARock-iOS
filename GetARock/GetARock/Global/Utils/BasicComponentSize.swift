//
//  DeviceSize.swift
//  GetARock
//
//  Created by 장지수 on 2023/01/23.
//
import UIKit

struct TextFieldSize {
    static let width = UIScreen.main.bounds.width * 0.9
    static let height = CGFloat(55)
}

struct TextViewSize {
    static let width = UIScreen.main.bounds.width * 0.9
    static let height = CGFloat(250)
}

struct SFIconSize {
    static let smallIconSize = UIImage.SymbolConfiguration(pointSize: 15)
}

struct BandButtonSize {
    static let  width = UIScreen.main.bounds.width - 32
    static let height = CGFloat(100)
}
