//
//  BasicTextField.swift
//  GetARock
//
//  Created by 장지수 on 2023/01/23.
//
import UIKit

final class BasicTextField: UIView {

    private let placeholder: String

    lazy var textField: UITextField = UITextField.makeBasicTextField(placeholder: placeholder)

    init(placeholder: String) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    private func setupLayout() {
        self.constraint(.widthAnchor, constant: TextFieldSize.width)
        self.constraint(.heightAnchor, constant: TextFieldSize.height)

        self.addSubview(textField)
        textField.constraint(to: self)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
