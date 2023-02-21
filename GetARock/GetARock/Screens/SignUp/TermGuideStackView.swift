//
//  TermGuideStackView.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/21.
//

import UIKit

final class TermGuideStackView: UIStackView {
    
    // MARK: - Property
    
    enum InputType: String {
        case optional = "(선택)"
        case required = "(필수)"
    }
    
    private let guideText: String
    private let type: InputType
    private let isNeedUnderLine: Bool
    private let url: String?
    
    // MARK: - View
    
    private lazy var firstLabel: BasicLabel = {
        $0.setContentHuggingPriority(
            UILayoutPriority.defaultHigh,
            for: .horizontal)
        
        let attributeString = NSMutableAttributedString(string: guideText)
        attributeString.addAttribute(
            .underlineStyle,
            value: 1,
            range: NSRange.init(location: 0, length: guideText.count)
        )
        $0.attributedText = attributeString
        return $0
    }(BasicLabel(contentText: guideText,
                 fontStyle: .content,
                 textColorInfo: .white))
    
    private lazy var guideButton: UIButton = {
        $0.setTitle(guideText, for: .normal)
        $0.setContentHuggingPriority(UILayoutPriority.defaultHigh,
                                     for: .horizontal)
        
        if isNeedUnderLine {
            let attributeString = NSMutableAttributedString(string: guideText)
            attributeString.addAttribute(
                .underlineStyle,
                value: 1,
                range: NSRange.init(location: 0, length: guideText.count)
            )
            $0.titleLabel?.attributedText = attributeString
        }
        $0.titleLabel?.font = .setFont(.content)
        $0.titleLabel?.textColor = .white
        
      return $0
    }(UIButton())
    
    private lazy var secondLabel = BasicLabel(contentText: type.rawValue,
                                              fontStyle: .content,
                                              textColorInfo: .gray02)
    
    // MARK: - Init
    
    init(guideText: String, type: InputType, isNeedUnderLine: Bool, url: String? = nil) {
        self.guideText = guideText
        self.type = type
        self.isNeedUnderLine = isNeedUnderLine
        self.url = url
        super.init(frame: .zero)
        attribute()
        addGuideButtonAction()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.axis = .horizontal
        self.spacing = 3
        self.addArrangedSubview(guideButton)
        self.addArrangedSubview(secondLabel)
    }
    
    private func addGuideButtonAction() {
        guard let url else { return }
        let action = UIAction { _ in
            guard let url = URL(string: url) else { return }
            UIApplication.shared.open(url)
        }
        self.guideButton.addAction(action, for: .touchUpInside)
    }
}
