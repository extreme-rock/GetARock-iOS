//
//  BottomButton.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/24.
//

import UIKit

final class BottomButton: UIButton {
    
    // MARK: - Layout
    
    override func setNeedsLayout() {
        self.applyMainGradient()
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        attribute()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Method
    
    private func attribute() {
        layer.masksToBounds = true
        layer.cornerRadius = 10
        titleLabel?.font = UIFont.setFont(.headline02)
        setBackgroundColor(.dark04, for: .disabled)
        setTitleColor(.white, for: .normal)
    }

    private func setupLayout() {
        self.constraint(.widthAnchor, constant: UIScreen.main.bounds.width - 32)
        self.constraint(.heightAnchor, constant: 60)
    }
}
