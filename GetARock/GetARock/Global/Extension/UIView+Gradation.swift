//
//  UIView+Gradation.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/21.
//

import UIKit

extension UIView {
    
    func applyGradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint ) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.locations = [0.0, 1.0]
        gradient.colors = colors.map { $0.cgColor }
        guard
            self.superview?.layer.sublayers?.contains(where: { $0 is CAGradientLayer }) == false
           else { return }
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: - Gradient Method
    
    func applyMainGradient() {
        applyGradient(
            colors:[.mainPurple, .blue02],
            startPoint: CGPoint(x: 0.0, y:0.5),
            endPoint: CGPoint(x: 1.0, y: 0.5)
        )
    }
    
    func applyActiveGradation() {
        applyGradient(
            colors: [.activeGradationPurple, .black],
            startPoint: CGPoint(x: 0.0, y:0.0),
            endPoint: CGPoint(x: 1.0, y:1.0)
        )
    }
    
}
