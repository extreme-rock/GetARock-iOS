//
//  Dark02Button.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/27.
//

import UIKit

final class Dark02Button: UIButton {
    
    init() {
        super.init(frame: .zero)
        attribute()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(codexr:) has not been implemented")
    }
    
    private func attribute() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.gray02.cgColor
        self.layer.borderWidth = 1
        
        self.titleLabel?.font = UIFont.setFont(.contentBold)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .dark02
    }
}
