//
//  UITextField+Extension.swift
//  GetARock
//
//  Created by 장지수 on 2023/01/23.
//
import UIKit

extension UITextField {
    static func makeBasicTextField(placeholder: String, characterLimit: Int? = nil) -> UITextField {
        let textField: UITextField = {
            
            let textField = UITextField(frame: .zero)
            textField.constraint(.widthAnchor, constant: DeviceSize.width * 0.9)
            textField.constraint(.heightAnchor, constant: DeviceSize.width * 0.9 * 0.15)
            
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.gray02, .font: UIFont.setFont(.content)])
            
            if let characterLimit {
                textField.maxCount = characterLimit
            }
            textField.layer.borderWidth = 2
            textField.layer.cornerRadius = 10
            textField.layer.borderColor = UIColor.white.cgColor
            textField.backgroundColor = .dark02
            textField.textColor = .white
            
            textField.leftView = EmptyView()
            
            textField.rightViewMode = .never
            textField.leftViewMode = .always
            return textField
        }()
        return textField
    }
}

extension UITextField {
    struct MaxCount {
        static var number: Int = 10
    }
    var maxCount: Int {
        get {
            MaxCount.number
        }
        set(newValue) {
            MaxCount.number = newValue
        }
    }
}

class EmptyView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        constraint(.widthAnchor, constant: 20)
        constraint(.heightAnchor, constant: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

