//
//  UIColor+Extension.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

extension UIColor {
    
    // MARK: - background
    
    static var dark01: UIColor {
        return UIColor(hex: "#17171B")
    }
    
    static var dark02: UIColor {
        return UIColor(hex: "#202026")
    }
    
    static var dark03: UIColor {
        return UIColor(hex: "#2E2E36")
    }
    
    static var dark04: UIColor {
        return UIColor(hex: "#43434D")
    }
    
    // MARK: - purple
    
    static var activeGradationPurple: UIColor {
        return UIColor(hex: "#411A59")
    }
    
    static var mainPurple: UIColor {
        return UIColor(hex: "#AF4DEC")
    }
    
    static var lightPurple: UIColor {
        return UIColor(hex: "#ECCDFF")
    }
    
    // MARK: - bule
    
    static var blue01: UIColor {
        return UIColor(hex: "#4A87FF")
    }
    
    static var blue02: UIColor {
        return UIColor(hex: "#6D7EF7")
    }
    
    static var blue03: UIColor {
        return UIColor(hex: "#CAD2FF")
    }
    
    // MARK: - gray
    
    static var gray01: UIColor {
        return UIColor(hex: "#5F5F5F")
    }
    
    static var gray02: UIColor {
        return UIColor(hex: "#AFAFAF")
    }
    
    // MARK: - etc
    
    static var warningRed: UIColor {
        return UIColor(hex: "#CA0000")
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
