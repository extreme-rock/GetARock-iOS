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
            
            $0.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.gray02, .font: UIFont.setFont(.content)])
            
            if let characterLimit { $0.maxCount = characterLimit }
            
            $0.layer.borderWidth = 2
            $0.layer.cornerRadius = 10
            $0.layer.borderColor = UIColor.white.cgColor
            $0.backgroundColor = .dark02
            $0.textColor = .white
            
            $0.leftView = EmptyView()
            $0.leftViewMode = .always
            
            $0.rightViewMode = .never

            return $0
        }(UITextField(frame: .zero))
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

final class EmptyView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        constraint(.widthAnchor, constant: 20)
        constraint(.heightAnchor, constant: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
