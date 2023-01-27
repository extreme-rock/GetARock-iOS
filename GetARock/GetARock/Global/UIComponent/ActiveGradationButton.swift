//
//  ActiveGradationButton.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/25.
//

import UIKit

final class ActiveGradationButton: UIButton {
    
    private let view = UIView()
    
    override func setNeedsLayout() {
        self.applyActiveGradation()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(codexr:) has not been implemented")
    }
    
    private func configureUI() {
        layer.masksToBounds = true
        layer.cornerRadius = 10
        titleLabel?.font = UIFont.setFont(.contentBold)
        setTitleColor(.white, for: .normal)
        let gradientimage = UIImage.gradientImage(bounds: CGRect(x: 0, y: 0, width: 200, height: 100), colors: [.mainPurple, .blue02])
        let color = UIColor(patternImage: gradientimage)
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
        
        let gradientimage1 = UIImage.gradientImage(bounds: CGRect(x: 0, y: 0, width: 200, height: 100), colors: [.activeGradationPurple, .black])
        let color1 = UIColor(patternImage: gradientimage1)
//        backgroundColor = .clear
    }
}



class View: UIView {
    
    init(frame: CGRect, cornerRadius: CGFloat, colors: [UIColor], lineWidth: CGFloat = 5) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = colors.map({ (color) -> CGColor in
            color.cgColor
        })
        
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let shape = CAShapeLayer()
        shape.lineWidth = lineWidth
        shape.path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: lineWidth,
                                                                   dy: lineWidth), cornerRadius: cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        self.layer.addSublayer(gradient)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
