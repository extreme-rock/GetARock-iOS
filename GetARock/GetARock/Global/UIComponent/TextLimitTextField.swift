//
//  TextLimitTextField.swift
//  GetARock
//
//  Created by 장지수 on 2023/01/29.
//
import UIKit

enum CheckDuplicationCase {
    case userNickName
    case bandName
}

final class TextLimitTextField: UIView {
    
    private let placeholder: String
    
    private let maximumCount: Int

    private let duplicationCheckType: CheckDuplicationCase
    
    private lazy var textField: UITextField = {
        let textField = UITextField.makeBasicTextField(placeholder: placeholder, characterLimit: maximumCount)
        return textField
    }()
    
    private let checkLabel: UIStackView = TwoHstackLabel.checkLabel
    
//    private lazy var checkButton = {
//        let button = BasicButton(text: "중복 확인", widthPadding: 24, heightPadding: 10)
//        button.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
//        return button
//    }()
    
    init(placeholer: String, maxCount: Int, checkCase: CheckDuplicationCase) {
        self.maximumCount = maxCount
        self.placeholder = placeholer
        self.duplicationCheckType = checkCase
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.constraint(.widthAnchor, constant: TextFieldSize.width)
        self.constraint(.heightAnchor, constant: TextFieldSize.height)
        
        addSubview(textField)
        textField.constraint(top: self.topAnchor, leading: self.leadingAnchor)
        
//        addSubview(checkButton)
//        checkButton.constraint(trailing: textField.trailingAnchor, centerY: textField.centerYAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
    }
}
