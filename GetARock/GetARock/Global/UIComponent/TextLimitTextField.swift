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

protocol TextLimitTextFieldDelegate: AnyObject {
    func textFieldTextDidChanged()
}

final class TextLimitTextField: UIView {
    
    // MARK: - Property
    
    weak var delegate: TextLimitTextFieldDelegate?
    
    private let placeholder: String
    
    private let maxCount: Int

    private let type: DuplicationCheckType

    private let textExpressionCheck: Bool
    
    private var isDuplicated = false
    
    private var availableName: String? = nil
    
    // MARK: - View
    
    lazy var textField: UITextField = {
        $0.addTarget(self, action: #selector(textFieldTextDidChange), for: .editingChanged)
        $0.delegate = self
        return $0
    }(UITextField.makeBasicTextField(placeholder: placeholder, characterLimit: maxCount))
    
    private lazy var checkButton: DefaultButton = {
        $0.setTitle("중복 확인", for: .normal)
        $0.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
        return $0
    }(DefaultButton())

    private lazy var duplicationCheckLabel: UIStackView = {
        let imageView: UIImageView = {
            $0.constraint(.widthAnchor, constant: 20)
            $0.constraint(.heightAnchor, constant: 20)
            return $0
        }(UIImageView())

        let label = BasicLabel(contentText: "중복 확인을 체크해주세요", fontStyle: .caption, textColorInfo: .systemBlue)

        $0.axis = .horizontal
        $0.spacing = 5
        $0.addArrangedSubview(imageView)
        $0.addArrangedSubview(label)
        return $0
    }(UIStackView())
    
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
        duplicationCheckLabel.constraint(top: textField.bottomAnchor, leading: textField.leadingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
    }
    
    private func attribute() {
        if type == .none {
            self.checkButton.isHidden = true
            self.textField.rightViewMode = .never
        }
        self.duplicationCheckLabel.isHidden = true
        self.textField.rightView = TextFieldRightPaddingView()
        self.textField.rightViewMode = .always
    }
    
    func isNameDuplicated() -> Bool {
        return self.isDuplicated
    }
    
    func isTextFieldEmpty() -> Bool {
        guard let isTextFieldEmpty = self.textField.text?.isEmpty else { return true }
        return isTextFieldEmpty
    }
    
    func isAvailableName() -> Bool {
        guard let availableName else { return false }
        return self.textField.text == availableName
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
        // 중복체크 성공 후 텍스트 변경시, 다시 중복체크를 요구하는 로직
        if !isAvailableName() {
            showLabelForRequringDuplicationCheck()
        } else {
            showDuplicationCheckPassedLabel()
        }
        // textField의 text가 바뀔때마다 nextButton enabled 체크
        delegate?.textFieldTextDidChanged()
    }
    
    //MARK: 중복 확인 버튼
    @objc func didTapCheckButton() {
        Task {
            do {
                //TODO: 추후 API 완성 이후 duplicationCheck 결과가 true일 경우의 코드 수정 필요
                if textField.text == "모여락" {
                    showDuplicationCheckLabel(with: true)
                    self.isDuplicated = true
                    self.availableName = textField.text
                } else {
                    let isDuplicated = try await DuplicationCheckRequest.checkDuplication(
                        checkCase: type,
                        word: textField.text ?? "")
                    showDuplicationCheckLabel(with: isDuplicated)
                    self.isDuplicated = isDuplicated
                }
                delegate?.textFieldTextDidChanged()
            } catch {
                print(error)
            }
        }
    }
    
    private func showDuplicationCheckLabel(with isDuplicated: Bool) {
        self.duplicationCheckLabel.isHidden = false
        // 중복 체크 라벨의 이미지 변경
        guard let imageView = duplicationCheckLabel.arrangedSubviews.first as? UIImageView else { return }
        imageView.image = isDuplicated ? ImageLiteral.checkmarkCircleSymbol : ImageLiteral.xmarkCircleSymbol
        imageView.tintColor = isDuplicated ? .blue02 : .warningRed
        // 중복 체크 라벨의 텍스트 변경
        guard let label = duplicationCheckLabel.arrangedSubviews.last as? UILabel else { return }
        label.text = isDuplicated ? StringLiteral.duplicationCheckPassed : StringLiteral.duplicationCheckUnPassed
        label.textColor = isDuplicated ? .blue02 : .warningRed
    }
    
    private func showLabelForRequringDuplicationCheck() {
        guard let imageView = duplicationCheckLabel.arrangedSubviews.first as? UIImageView else { return }
        imageView.image = ImageLiteral.exclamationMarkCircleSymbol
        imageView.tintColor = .warningRed

        guard let label = duplicationCheckLabel.arrangedSubviews.last as? UILabel else { return }
        label.text = StringLiteral.needDuplicationCheck
        label.textColor = .warningRed
    }
    
    private func showDuplicationCheckPassedLabel() {
        guard let imageView = duplicationCheckLabel.arrangedSubviews.first as? UIImageView else { return }
        imageView.image = ImageLiteral.checkmarkCircleSymbol
        imageView.tintColor =  .blue02
        // 중복 체크 라벨의 텍스트 변경
        guard let label = duplicationCheckLabel.arrangedSubviews.last as? UILabel else { return }
        label.text = StringLiteral.duplicationCheckPassed
        label.textColor = .blue02
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
