//
//  BasicTextField.swift
//  GetARock
//
//  Created by 장지수 on 2023/01/23.
//
import UIKit

final class BasicTextField: UIView {

    var placeholder: String

    private lazy var textField: UITextField = UITextField.makeBasicTextField(placeholder: placeholder)

    init(placeholder: String) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        setupLayout()
    }
    
    private func setupLayout() {
        self.constraint(.widthAnchor, constant: TextFieldSize.width)
        self.constraint(.heightAnchor, constant: TextFieldSize.height)

        self.addSubview(textField)
        textField.constraint(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
