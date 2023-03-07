//
//  BasicTextView.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/01/25.
//
import UIKit

final class BasicTextView: UIView {

    private let placeholder: String

    private var maxCount: Int = 300

    private lazy var textView: UITextView = {
        // 행간 세팅
        let style = NSMutableParagraphStyle()
        let attributedString = NSMutableAttributedString(string: $0.text)
        style.lineSpacing = CGFloat(10)
        attributedString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: style,
            range: NSRange(location: 0, length: attributedString.length)
        )
        $0.attributedText = attributedString
        $0.font = UIFont.setFont(.content)
        $0.textColor = .white
        $0.backgroundColor = .dark02

        $0.delegate = self
        return $0
    }(UITextView())

    private lazy var countLabel = BasicLabel(
        contentText: "\(textView.text.count)/\(maxCount)",
        fontStyle: .content,
        textColorInfo: .gray02
    )

    private lazy var placeholderLabel: UILabel = BasicLabel(
        contentText: placeholder,
        fontStyle: .content,
        textColorInfo: .gray02
    )

    init(placeholder: String, maxCount: Int? = nil) {
        self.placeholder = placeholder
        if let maxCount { self.maxCount = maxCount }
        super.init(frame: .zero)
        setupLayout()
        attribute()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func attribute() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.white.cgColor
        self.backgroundColor = .dark02
        placeholderLabel.numberOfLines = 2
    }

    private func setupLayout() {
        self.constraint(.widthAnchor, constant: TextViewSize.width)
        self.constraint(.heightAnchor, constant: TextViewSize.height)

        self.addSubview(textView)
        textView.constraint(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            bottom: self.bottomAnchor,
            trailing: self.trailingAnchor,
            padding: UIEdgeInsets(top: 10, left: 10, bottom:50, right: 10)
        )

        self.addSubview(countLabel)
        countLabel.constraint(
            bottom: self.bottomAnchor,
            trailing: self.trailingAnchor,
            padding: UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 20)
        )

        self.addSubview(placeholderLabel)
        placeholderLabel.constraint(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            padding: UIEdgeInsets(top: 15, left: 20, bottom: 0, right: 0)
        )
    }
    
    func inputText() -> String? {
        return self.textView.text == placeholder ? nil : self.textView.text
    }
}

extension BasicTextView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        // text 숫자 업데이트
        countLabel.text = "\(textView.text.count)/\(maxCount)"
        // 최대 글자수 제한 로직
        if let text = textView.text {
            if text.count >= maxCount {
                let maxCountIndex = text.index(text.startIndex, offsetBy: maxCount)
                let fixedText = String(text[text.startIndex..<maxCountIndex])
                textView.text = fixedText + " "
                self.countLabel.text = "\(maxCount)/\(maxCount)"
                self.textView.text = fixedText
            }
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeholderLabel.isHidden = false
        }
    }
}
