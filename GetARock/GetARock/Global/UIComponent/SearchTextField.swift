//
//  SearchTextField.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/16.
//

import UIKit

final class SearchTextField: UIView {

    private let placeholder: String

    lazy var textField: UITextField = {
        $0.delegate = self
        $0.layer.borderWidth = 0
        return $0
    }(UITextField.makeBasicTextField(placeholder: placeholder))

    //TODO: ImageLiteral로 등록 필요
    private let searchImage: UIImageView = {
        $0.image = UIImage(systemName: "magnifyingglass")
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())

    init(placeholder: String) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        setupLayout()
        attribute()
    }

    private func setupLayout() {
        self.constraint(.heightAnchor, constant: 55)

        self.addSubview(textField)
        self.addSubview(searchImage)
        textField.constraint(leading: self.leadingAnchor, trailing: self.trailingAnchor, centerY: self.centerYAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))

        searchImage.constraint(.widthAnchor, constant: 20)
        searchImage.constraint(.heightAnchor, constant: 20)
        searchImage.constraint(leading: self.leadingAnchor, centerY: self.centerYAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
    }

    private func attribute() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.white.cgColor
        self.backgroundColor = .dark02
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

