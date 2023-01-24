//
//  BottomButton.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/24.
//

import UIKit

final class BottomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        layer.masksToBounds = true
        layer.cornerRadius = 10
        titleLabel?.font = UIFont.setFont(.headline02)
        setBackgroundColor(.dark04, for: .disabled)
        setBackgroundColor(.mainPurple, for: .normal)
        setTitleColor(.white, for: .normal)
    }

    private func setupLayout() {
        self.constraint(.widthAnchor, constant: UIScreen.main.bounds.width - 32)
        self.constraint(.heightAnchor, constant: 60)
    }
}
