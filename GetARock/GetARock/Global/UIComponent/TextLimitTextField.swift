//
//  TextLimitTextField.swift
//  GetARock
//
//  Created by 장지수 on 2023/01/30.
//
import UIKit

enum DuplicationCheckType {
    case userName
    case bandName
    case none
}

final class TextLimitTextField: UIStackView {
    
    // MARK: - Property
    
    private let placeholder: String
    
    private let maxCount: Int

    private let type: DuplicationCheckType

    private let textExpressionCheck: Bool
    
    // MARK: - View
    
    private lazy var textField: UITextField = {
        $0.addTarget(self, action: #selector(textFieldTextDidChange), for: .editingChanged)
        $0.delegate = self
        return $0
    }(UITextField.makeBasicTextField(placeholder: placeholder, characterLimit: maxCount))
    
    private lazy var checkButton: DefaultButton = {
        $0.setTitle("중복 확인", for: .normal)
        $0.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
        return $0
    }(DefaultButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40)))
    
    private let duplicationCheckLabel: UIStackView = TwoHstackLabel.checkLabel
    
    // MARK: - Life Cycle
    
    init(placeholer: String, maxCount: Int, duplicationCheckType: DuplicationCheckType, textExpressionCheck: Bool) {
        self.maxCount = maxCount
        self.placeholder = placeholer
        self.type = duplicationCheckType
        self.textExpressionCheck = textExpressionCheck
        super.init(frame: .zero)
        
        setupLayout()
        attribute()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func setupLayout() {
        textField.constraint(.widthAnchor, constant: TextFieldSize.width)
        textField.constraint(.heightAnchor, constant: TextFieldSize.height)
        
        self.addArrangedSubview(textField)
        self.addArrangedSubview(duplicationCheckLabel)

        self.addSubview(checkButton)
        checkButton.constraint(
            trailing: textField.trailingAnchor,
            centerY: textField.centerYAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        checkButton.constraint(.widthAnchor, constant: 80)
        checkButton.constraint(.heightAnchor, constant: 40)
    }
    
    private func attribute() {
        if type == .none {
            checkButton.isHidden = true
        }
        duplicationCheckLabel.isHidden = true
        self.axis = .vertical
        self.spacing = 5
    }
}

//MARK: 글자수 제한 로직

extension TextLimitTextField {
    @objc func textFieldTextDidChange() {
        if let text = textField.text {
            if text.count >= maxCount {
                let maxCountIndex = text.index(text.startIndex, offsetBy: maxCount)
                let fixedText = String(text[text.startIndex..<maxCountIndex])
                textField.text = fixedText + " "
                self.textField.text = fixedText
            }
        }
    }
    
    @objc func didTapCheckButton() {
        Task {
            do {
                let isChecked = try await DuplicationCheckRequest.checkDuplication(
                    checkCase: type,
                    word: textField.text ?? "")
                showDuplicationCheckLabel(with: isChecked)
            } catch {
                print(error)
            }
        }
    }
    
    private func showDuplicationCheckLabel(with isChecked: Bool) {
        duplicationCheckLabel.isHidden = false
        let imageView = duplicationCheckLabel.arrangedSubviews.first! as! UIImageView
        imageView.image = isChecked ? UIImage(systemName: "checkmark.circle")! : UIImage(systemName: "x.circle")!
        imageView.tintColor = isChecked ? .systemBlue : .systemRed
        
        let label = duplicationCheckLabel.arrangedSubviews.last! as! UILabel
        label.text = isChecked ? "가능합니다" : "불가능합니다"
        label.textColor = isChecked ? .systemBlue : .systemRed
    }
}

//MARK: 특수문자 제한 로직

extension TextLimitTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.textExpressionCheck == true {
            let utf8Char = string.cString(using: .utf8)
            let isBackSpace = strcmp(utf8Char, "\\b")
            if string.checkStringExpression() || isBackSpace == -92 {
                return true
            }
            return false
        }
        return true
    }
}
