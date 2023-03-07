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

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        attribute()
    }
    private func attribute() {
        let gradientImage = UIImage.gradientImage(bounds: self.bounds, colors: [.mainPurple, .blue02])
        let color = UIColor(patternImage: gradientImage)
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
        layer.cornerRadius = 10
        titleLabel?.font = UIFont.setFont(.contentBold)
        setTitleColor(.white, for: .normal)
        self.setBackgroundColor(.dark04, for: .disabled)
    }
}
