//
//  ActiveGradationButton.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/25.
//

import UIKit

final class DefaultButton: UIButton {
    
    override func setNeedsLayout() {
        self.applyActiveGradation()
    }
    
    init(borderBounds: CGRect) {
        super.init(frame: .zero)
        attribute(bounds: borderBounds)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(codexr:) has not been implemented")
    }
    
    private func attribute(bounds: CGRect) {
        let gradientImage = UIImage.gradientImage(bounds: bounds, colors: [.mainPurple, .blue02])
        let color = UIColor(patternImage: gradientImage)
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
        layer.cornerRadius = 10
        
        titleLabel?.font = UIFont.setFont(.contentBold)
        setTitleColor(.white, for: .normal)
    }
}
