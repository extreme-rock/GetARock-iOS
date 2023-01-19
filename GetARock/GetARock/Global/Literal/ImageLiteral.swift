//
//  ImageLiteral.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

enum ImageLiteral {
//     static var exampleIcon: UIImage { .load(named: sth) }
}

extension UIImage {
    static func load(named imageName: String) -> UIImage {
        guard let image = UIImage(named: imageName, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = imageName
        return image
    }
    
    func resize(to size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}
