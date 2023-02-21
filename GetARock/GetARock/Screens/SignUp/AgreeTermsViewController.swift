//
//  AgreeTermsViewController.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/20.
//

import UIKit

final class AgreeTermsViewController: UIViewController {
    
    private let titleLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(
        contentText: "모여락을 시작하기 위해\n약관에 동의해 주세요",
        fontStyle: .headline01,
        textColorInfo: .white
    ))
    
    private lazy var agreeAllTermsStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [agreeAllTermsButton, agreeAllTermsLabel]))
    
    private let agreeAllTermsButton = CheckMarkButton()
    
    private let agreeAllTermsLabel = BasicLabel(
        contentText: "모두 동의합니다.",
        fontStyle: .content,
        textColorInfo: .white
    )
    
    private let containerView: UIView = {
        $0.backgroundColor = .dark04
        $0.layer.cornerRadius = 20
        return $0
    }(UIView())
    
    private lazy var termsStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 17
        return $0
    }(UIStackView(arrangedSubviews: [serviceStackView,
                                    personalInfoStackView,
                                    ageLimitInfoStackView]))
    
    private lazy var serviceStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [serviceCheckMarkButton,
                                     serviceTermStackView]))
    
    private let serviceCheckMarkButton = CheckMarkButton()
    
    private let serviceTermStackView = TermGuideLabel(
        guideText: "서비스 이용약관 동의",
        type: .required
    )
    
    private lazy var personalInfoStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [personalInfoCheckMarkButton,
                                     personalInfoTermStackView]))
    
    private let personalInfoCheckMarkButton = CheckMarkButton()
    
    private let personalInfoTermStackView = TermGuideLabel(
        guideText: "개인정보 수집 및 이용 동의",
        type: .required
    )
    
    private lazy var ageLimitInfoStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [ageLimitCheckMarkButton,
                                     ageLimitTermStackView]))
    
    private let ageLimitCheckMarkButton = CheckMarkButton()
    
    private let ageLimitTermStackView = TermGuideLabel(
        guideText: "만 14세 이상",
        type: .required
    )
    
    private let agreeButton: BottomButton =  {
        $0.setTitle("동의 후 프로필 만들기", for: .normal)
        $0.titleLabel?.font = .setFont(.headline02)
        return $0
    }(BottomButton())
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
        addAgreeAllButtonAction()
        addTermsButtonAction()
    }
    
    private func attribute() {
        self.view.backgroundColor = .dark03
    }
    
    private func setupLayout() {
        self.view.addSubview(titleLabel)
        titleLabel.constraint(top: view.topAnchor,
                              leading: view.leadingAnchor,
                              padding: UIEdgeInsets(top: 60, left: 16, bottom: 0, right: 0))
        
        self.view.addSubview(agreeAllTermsStackView)
        agreeAllTermsStackView.constraint(top: titleLabel.bottomAnchor,
                                          leading: view.leadingAnchor,
                                          padding: UIEdgeInsets(top: 30, left: 22, bottom: 0, right: 0))
        
        self.view.addSubview(containerView)
        containerView.constraint(top: agreeAllTermsStackView.bottomAnchor,
                                 leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 padding: UIEdgeInsets(top: 30, left: 16, bottom: 0, right: 16))
        
        self.containerView.addSubview(termsStackView)
        termsStackView.constraint(top: containerView.topAnchor,
                                  leading: containerView.leadingAnchor,
                                  bottom: containerView.bottomAnchor,
                                  trailing: containerView.trailingAnchor,
                                   padding: UIEdgeInsets(top: 27, left: 20, bottom: 27, right: 20))
        
        self.view.addSubview(agreeButton)
        agreeButton.constraint(bottom: view.bottomAnchor,
                               centerX: view.centerXAnchor,
                               padding: UIEdgeInsets(top: 0, left: 0, bottom: 23, right: 0)
        )
    }
    
    private func addAgreeAllButtonAction() {
        let action = UIAction { [weak self] _ in
            guard let isAgreeAllButtonChecked = self?.agreeAllTermsButton.isChecked else { return }
            self?.serviceCheckMarkButton.isChecked = isAgreeAllButtonChecked
            self?.ageLimitCheckMarkButton.isChecked = isAgreeAllButtonChecked
            self?.personalInfoCheckMarkButton.isChecked = isAgreeAllButtonChecked
        }
        self.agreeAllTermsButton.addAction(action, for: .touchUpInside)
    }
    
    private func addTermsButtonAction() {
        let action = UIAction { [weak self] _ in
            self?.applyTermButtonsStateToAgreeAllButton()
        }
        
        serviceCheckMarkButton.addAction(action, for: .touchUpInside)
        ageLimitCheckMarkButton.addAction(action, for: .touchUpInside)
        personalInfoCheckMarkButton.addAction(action, for: .touchUpInside)
        
    }
    
    private func applyTermButtonsStateToAgreeAllButton() {
        if serviceCheckMarkButton.isChecked == true &&
            ageLimitCheckMarkButton.isChecked == true &&
            personalInfoCheckMarkButton.isChecked == true {
            agreeAllTermsButton.isChecked = true
        } else {
            agreeAllTermsButton.isChecked = false
        }
    }
}

final class CheckMarkButton: UIButton {
    
    var isChecked: Bool = false {
        didSet {
            self.setImage(
                isChecked ?
                ImageLiteral.checkMarkCircleFillSymbol
                : ImageLiteral.checkmarkCircleSymbol
                , for: .normal)
            self.tintColor = isChecked ? .mainPurple : .gray02
        }
    }
    
    init() {
        super.init(frame: .zero)
        attribute()
        self.addTarget(self, action:#selector(buttonClicked(_:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        if sender == self {
            isChecked.toggle()
        }
    }
    
    private func attribute() {
        self.setImage(ImageLiteral.checkmarkCircleSymbol, for: .normal)
        self.tintColor = .gray02
        self.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

final class TermGuideLabel: UIStackView {
    
    enum InputType: String {
        case optional = "(선택)"
        case required = "(필수)"
    }
    
    private let guideText: String
    
    private let type: InputType
    
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
    
    private lazy var secondLabel = BasicLabel(contentText: type.rawValue,
                                              fontStyle: .content,
                                              textColorInfo: .gray02)
    
    init(guideText: String, type: InputType) {
        self.guideText = guideText
        self.type = type
        super.init(frame: .zero)
        attribute()
    }
    
    private func attribute() {
        self.axis = .horizontal
        self.spacing = 3
        self.addArrangedSubview(firstLabel)
        self.addArrangedSubview(secondLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
