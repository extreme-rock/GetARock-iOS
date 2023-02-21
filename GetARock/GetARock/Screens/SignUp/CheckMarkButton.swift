//
//  CheckMarkButton.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/21.
//

import UIKit

final class CheckMarkButton: UIButton {
    
    // MARK: - Property
    
    var isChecked: Bool = false {
        didSet {
            self.setImage(
                isChecked
                ? ImageLiteral.checkMarkCircleFillSymbol
                : ImageLiteral.checkmarkCircleSymbol
                , for: .normal)
            self.tintColor = isChecked ? .mainPurple : .gray02
        }
    }
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        attribute()
        self.addTarget(self, action:#selector(buttonClicked(_:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    @objc func buttonClicked(_ sender: UIButton) {
            isChecked.toggle()
    }
    
    private func attribute() {
        self.setImage(ImageLiteral.checkmarkCircleSymbol, for: .normal)
        self.tintColor = .gray02
        self.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}
