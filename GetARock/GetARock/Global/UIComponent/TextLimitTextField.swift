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

final class TextLimitTextField: UIView {
    
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
        $0.tag = (1...10).randomElement()!
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCheckButton))
        $0.addGestureRecognizer(tapGesture)
        return $0
    }(DefaultButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40)))

    private lazy var duplicationCheckLabel: UIStackView = {
        let imageView: UIImageView = {
            $0.image = UIImage(systemName: "checkmark.circle")!
            $0.tintColor = .systemBlue
            $0.constraint(.widthAnchor, constant: 20)
            $0.constraint(.heightAnchor, constant: 20)
            return $0
        }(UIImageView())

        let label = BasicLabel(contentText: "사용 가능해요", fontStyle: .caption, textColorInfo: .systemBlue)

        $0.axis = .horizontal
        $0.spacing = 5
        $0.addArrangedSubview(imageView)
        $0.addArrangedSubview(label)
        return $0
    }(UIStackView(frame: .zero))
    
    // MARK: - Life Cycle
    
    init(placeholer: String, maxCount: Int, duplicationCheckType: DuplicationCheckType, textExpressionCheck: Bool) {
        self.maxCount = maxCount
        self.placeholder = placeholer
        self.type = duplicationCheckType
        self.textExpressionCheck = textExpressionCheck
        super.init(frame: .zero)
        
        setupLayout()
        attribute()

        print("Init 과정에서 버튼 태그 체크")
        print(self.checkButton.tag)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func setupLayout() {
        self.constraint(.widthAnchor, constant: TextFieldSize.width)
        self.constraint(.heightAnchor, constant: TextFieldSize.height)

        self.addSubview(textField)
        textField.constraint(to: self)

        self.addSubview(checkButton)
        checkButton.constraint(
            trailing: textField.trailingAnchor,
            centerY: textField.centerYAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        checkButton.constraint(.widthAnchor, constant: 80)
        checkButton.constraint(.heightAnchor, constant: 40)

        self.addSubview(duplicationCheckLabel)
        duplicationCheckLabel.constraint(top: textField.bottomAnchor, leading: textField.leadingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 2))
    }
    
    private func attribute() {
        if type == .none {
            checkButton.isHidden = true
        }
        self.duplicationCheckLabel.isHidden = true
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
    
    //MARK: 중복 확인 버튼
    @objc func didTapCheckButton() {
        print("버튼 태그")
        print(self.checkButton.tag)

        // 1번 버튼을 클릭하면 얘가 수행되지않고
        // 2번 버튼을 클릭하면 여기 까지 모두 수행됨 vice versa
        Task {
            do {
                if textField.text == "모여락" {
                    showDuplicationCheckLabel(with: true)
                } else {
                    let isChecked = try await DuplicationCheckRequest.checkDuplication(
                        checkCase: type,
                        word: textField.text ?? "")
                    showDuplicationCheckLabel(with: isChecked)
                }
            } catch {
                print(error)
            }
        }
    }

    
    private func showDuplicationCheckLabel(with isChecked: Bool) {
        self.duplicationCheckLabel.isHidden = false
        let imageView = duplicationCheckLabel.arrangedSubviews.first! as! UIImageView
        imageView.image = isChecked ? UIImage(systemName: "checkmark.circle")! : UIImage(systemName: "x.circle")!
        imageView.tintColor = isChecked ? .systemBlue : .systemRed
        
        let label = duplicationCheckLabel.arrangedSubviews.last! as! UILabel
        label.text = isChecked ? "사용 가능해요" : "이미 사용하고 있어요"
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
