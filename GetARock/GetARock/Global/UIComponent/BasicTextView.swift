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
        let attributedString = NSMutableAttributedString(string: textView.text)
        style.lineSpacing = CGFloat(7)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))

        $0.attributedText = attributedString
        $0.font = UIFont.setFont(.content)
        $0.textColor = .white
        $0.backgroundColor = .dark02

        $0.delegate = self
        return $0
    }(UITextView())

    private lazy var countLabel = BasicLabel(contentText: "\(textView.text.count)/\(maxCount)", fontStyle: .headline01, textColorInfo: .gray02)

    private lazy var placeholderLabel: UILabel = BasicLabel(contentText: placeholder, fontStyle: .content, textColorInfo: .gray02)

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
        textView.constraint(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom:50, right: 10))

        self.addSubview(countLabel)
        countLabel.constraint(bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 20))

        self.addSubview(placeholderLabel)
        placeholderLabel.constraint(top: self.topAnchor, leading: self.leadingAnchor, padding: UIEdgeInsets(top: 15, left: 20, bottom: 0, right: 0))
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

//MARK: Test code case1
// 기본 텍스트뷰 (글자수 제한 300) + UIStackView에 사용하는 경우 (stackView의 크기에 맞춤)
class BasicTextViewTestClass: UIViewController {

    let firstTestTextView = BasicTextView(placeholder: "테스트용 텍스트뷰 입니다")

    lazy var stackView = UIStackView(arrangedSubviews: [firstTestTextView])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stackView)
        stackView.constraint(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
        stackView.constraint(.widthAnchor, constant: 200)
        stackView.constraint(.heightAnchor, constant: 400)
    }
}

//MARK: Test code case2
// 글자수 제한 30 + x,y 위치만 잡아주는 경우 (클래스 내에서 지정된 원래 크기로 할당됨)
class BasicTextViewSecondTestClass: UIViewController {

    let secondTestTextView = BasicTextView(placeholder: "테스트용", maxCount: 30)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(secondTestTextView)
        secondTestTextView.constraint(centerX: view.centerXAnchor, centerY: view.centerYAnchor, padding: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0))
    }
}

