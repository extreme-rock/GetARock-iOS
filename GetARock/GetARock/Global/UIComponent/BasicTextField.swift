//
//  BasicTextField.swift
//  GetARock
//
//  Created by 장지수 on 2023/01/23.
//
import UIKit

protocol BasicTextFieldDelegate: AnyObject {
    func textFieldTextDidChange()
}

final class BasicTextField: UIView {

    weak var delegate: BasicTextFieldDelegate?
    
    private let placeholder: String

    lazy var textField: UITextField = {
        $0.addTarget(self, action: #selector(textFieldTextDidChange), for: .editingChanged)
        return $0
    }(UITextField.makeBasicTextField(placeholder: placeholder))

    init(placeholder: String) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.constraint(.widthAnchor, constant: TextFieldSize.width)
        self.constraint(.heightAnchor, constant: TextFieldSize.height)

        self.addSubview(textField)
        textField.constraint(to: self)
    }
    
    func isTextFieldEmpty() -> Bool {
        guard let isTextFieldEmpty = self.textField.text?.isEmpty else { return true }
        return isTextFieldEmpty
    }
}

extension BasicTextField {
    @objc func textFieldTextDidChange() {
        delegate?.textFieldTextDidChange()
    }
}
