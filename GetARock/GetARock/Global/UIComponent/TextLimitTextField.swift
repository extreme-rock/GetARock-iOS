//
//  TextLimitTextField.swift
//  GetARock
//
//  Created by 장지수 on 2023/01/30.
//
import UIKit

enum CheckDuplicationCase {
    case userNickName
    case bandName
}

final class TextLimitTextField: UIView {
    
    private let placeholder: String
    
    private let maxCount: Int

    private let duplicationCheckType: CheckDuplicationCase
    
    private lazy var textField: UITextField = {
        return $0
    }(UITextField.makeBasicTextField(placeholder: placeholder, characterLimit: maxCount))
    
    private lazy var checkButton: DefaultButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 9, leading: 12, bottom: 9, trailing: 12)
        $0.configuration = configuration
        $0.setTitle("중복 확인", for: .normal)
        return $0
    }(DefaultButton(borderBounds: CGRect(x: 0, y: 0, width: 80, height: 40)))
    
    init(placeholer: String, maxCount: Int, checkCase: CheckDuplicationCase) {
        self.maxCount = maxCount
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
        
        self.addSubview(textField)
        textField.constraint(to: self)

        self.addSubview(checkButton)
        checkButton.constraint(trailing: textField.trailingAnchor, centerY: textField.centerYAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
    }
}
