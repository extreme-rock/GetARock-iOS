//
//  ImageLiteral.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

enum ImageLiteral {
//     static var exampleIcon: UIImage { .load(named: sth) }
    
    // MARK: - SF Symbols
    static var xmarkSymbol: UIImage { .load(systemName: "xmark") }
    static var arrowUpRightSymbol: UIImage { .load(systemName: "arrow.up.right") }
    static var crownSymbol: UIImage { .load(systemName: "crown") }
    static var plusSymbol: UIImage { .load(systemName: "plus") }
    
}

extension UIImage {
    static func load(named imageName: String) -> UIImage {
        guard let image = UIImage(named: imageName, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = imageName
        return image
    }
    
    static func load(systemName: String) -> UIImage {
        guard let image = UIImage(systemName: systemName, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = systemName
        return image
    }
    
    func resize(to size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}
