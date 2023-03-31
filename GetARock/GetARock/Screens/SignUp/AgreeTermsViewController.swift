//
//  AgreeTermsViewController.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/20.
//

import UIKit

protocol AgreeTermsViewControllerDelegate: AnyObject {
    func presentPositionSelectViewController()
}

final class AgreeTermsViewController: UIViewController {
    
    // MARK: - Property

    weak var delegate: AgreeTermsViewControllerDelegate?
    private lazy var requiedTermButtons: [CheckMarkButton] = [serviceCheckMarkButton,
                                                              personalInfoCheckMarkButton,
                                                              ageLimitCheckMarkButton]
    
    // MARK: - View
    
    private let titleLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(
        contentText: "모여락을 시작하기 위해\n약관에 동의해 주세요",
        fontStyle: .largeTitle01,
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
    
    private let serviceTermStackView = TermGuideStackView(
        guideText: "서비스 이용약관 동의",
        type: .required,
        isNeedUnderLine: true,
        url: StringLiteral.serviceTermLink
    )
    
    private lazy var personalInfoStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [personalInfoCheckMarkButton,
                                     personalInfoTermStackView]))
    
    private let personalInfoCheckMarkButton = CheckMarkButton()
    
    private let personalInfoTermStackView = TermGuideStackView(
        guideText: "개인정보 수집 및 이용 동의",
        type: .required,
        isNeedUnderLine: true,
        url: StringLiteral.personalInfoTermLink
    )
    
    private lazy var ageLimitInfoStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [ageLimitCheckMarkButton,
                                     ageLimitTermStackView]))
    
    private let ageLimitCheckMarkButton = CheckMarkButton()
    
    private let ageLimitTermStackView = TermGuideStackView(
        guideText: "만 14세 이상",
        type: .required,
        isNeedUnderLine: false
    )
    
    private lazy var nextButton: BottomButton =  {
        $0.setTitle("동의 후 프로필 만들기", for: .normal)
        $0.isEnabled = false
        $0.titleLabel?.font = .setFont(.headline02)
        let action = UIAction { [weak self]_ in
            self?.dismiss(animated: true)
            self?.delegate?.presentPositionSelectViewController()
        }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(BottomButton())
        
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
        addAgreeAllButtonAction()
        addTermsButtonAction()
    }
    
    // MARK: - Method
    
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
        
        self.view.addSubview(nextButton)
        nextButton.constraint(bottom: view.bottomAnchor,
                               centerX: view.centerXAnchor,
                               padding: UIEdgeInsets(top: 0, left: 0, bottom: 23, right: 0)
        )
    }
   
}

// MARK: 버튼 Action 관련 Method

extension AgreeTermsViewController {
    private func addButtonActions() {
        addAgreeAllButtonAction()
        addTermsButtonAction()
    }
    
    private func addAgreeAllButtonAction() {
        let action = UIAction { [weak self] _ in
            guard let isAgreeAllButtonChecked = self?.agreeAllTermsButton.isChecked else { return }
            self?.serviceCheckMarkButton.isChecked = isAgreeAllButtonChecked
            self?.ageLimitCheckMarkButton.isChecked = isAgreeAllButtonChecked
            self?.personalInfoCheckMarkButton.isChecked = isAgreeAllButtonChecked
            self?.applyNextButtonEnabledState()
        }
        self.agreeAllTermsButton.addAction(action, for: .touchUpInside)
    }
    
    private func addTermsButtonAction() {
        let action = UIAction { [weak self] _ in
            self?.applyTermButtonsStateToAgreeAllButton()
            self?.applyNextButtonEnabledState()
        }
        
        serviceCheckMarkButton.addAction(action, for: .touchUpInside)
        ageLimitCheckMarkButton.addAction(action, for: .touchUpInside)
        personalInfoCheckMarkButton.addAction(action, for: .touchUpInside)
        
    }
    
    private func applyTermButtonsStateToAgreeAllButton() {
        let termsCheckedState = self.requiedTermButtons.filter { $0.isChecked }
        
        agreeAllTermsButton.isChecked =
        termsCheckedState.count == requiedTermButtons.count
        ? true
        : false
    }
    
    private func applyNextButtonEnabledState() {
        let termsCheckedState = self.requiedTermButtons.filter { $0.isChecked }
        
        nextButton.isEnabled =
        termsCheckedState.count == requiedTermButtons.count
        ? true
        : false
    }
}
