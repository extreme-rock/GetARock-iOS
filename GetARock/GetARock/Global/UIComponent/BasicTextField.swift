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
        self.constraint(.widthAnchor, constant: DeviceSize.width * 0.9)
        self.constraint(.heightAnchor, constant: 55)

        self.addSubview(textField)
        textField.constraint(leading: self.leadingAnchor, centerY: self.centerYAnchor)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
