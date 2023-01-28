//
//  IconImage.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/28.
//

import UIKit

class IconImageView: UIImageView {
    
    // MARK: - Property
    
    enum IconType: String {
        case bandIcon
        case eventIcon
    }
    
    private var iconType: IconType
    private let imageView = UIImageView()
    private let iconSize: CGFloat = 50
    
    // MARK: - Init
    
    init(iconType: IconType) {
        self.iconType = iconType
        super.init(frame: .zero)
        attribute()
        setupLayout() 
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func attribute() {
        switch iconType {
        case .bandIcon:
            imageView.image = ImageLiteral.bandIcon
        case .eventIcon:
            imageView.image = ImageLiteral.eventIcon
        }
    }
    
    private func setupLayout() {
        self.addSubview(imageView)
        imageView.constraint(to: self)
        self.constraint(.widthAnchor, constant: iconSize)
        self.constraint(.heightAnchor, constant: iconSize)
    }
}
