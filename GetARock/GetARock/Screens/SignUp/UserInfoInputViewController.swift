//
//  UserInfoInputViewController.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/17.
//

import UIKit

final class UserInfoInputViewController: UIViewController {
    
    // MARK: - Property
    
    private let instrumentList: [InstrumentList]?
    private var keyBoardHeight: CGFloat = 280
    
    // MARK: - View
    
    private let pageIndicatorLabel: UILabel = {
        $0.font = .setFont(.headline03)
        $0.text = "2/2"
        $0.textColor = .gray02
        return $0
    }(UILabel())

    private let contentViewTitleLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "나에 대해\n간단히 알려주세요", fontStyle: .largeTitle01, textColorInfo: .white))

    private let contentViewSubTitleLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "작성 정보는 프로필로 만들어집니다.\n나를 잘 어필할 수 있도록 작성해보세요! 😎",
                 fontStyle: .headline03,
                 textColorInfo: .gray02))
    
    private lazy var titleStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [pageIndicatorLabel,
                                     contentViewTitleLabel,
                                     contentViewSubTitleLabel]))

    private let userNamingGuideTitleLabel = InformationGuideLabel(guideText: "닉네임",
                                                                  type: .required)
    
    private let userNamingGuideSubLabel = BasicLabel(
        contentText: "* 공백없이 20자 이하, 기호는 _만 입력 가능합니다.",
        fontStyle: .content,
        textColorInfo: .gray02)

    private lazy var userNamingTextField: TextLimitTextField = TextLimitTextField(
        placeholer: "닉네임을 입력해주세요.",
        maxCount: 20,
        duplicationCheckType: .userName,
        textExpressionCheck: true)
    
    private lazy var textFieldStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [userNamingGuideTitleLabel,
                                     userNamingGuideSubLabel,
                                     userNamingTextField]))
    
    private let ageTitleLabel = InformationGuideLabel(guideText: "연령대", type: .required)

    private let ageSelectCollectionView: SelectCollectionView = {
        $0.constraint(.widthAnchor, constant: UIScreen.main.bounds.width - 32)
        $0.constraint(.heightAnchor, constant: 102)
        return $0
    }(SelectCollectionView(
        widthOption: .flexable,
        items: Age.allCases.map { $0.rawValue },
        widthSize: 25,
        itemSpacing: 5,
        cellBackgroundColor: .dark02
    ))
    private lazy var ageInputStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [ageTitleLabel,
                                     ageSelectCollectionView]))
    
    private let genderTitleLabel = InformationGuideLabel(guideText: "성별",
                                                         type: .required)
    
    private let genderSelectCollectionView: SelectCollectionView = {
        $0.constraint(.widthAnchor, constant: UIScreen.main.bounds.width - 32)
        $0.constraint(.heightAnchor, constant: 46)
        return $0
    }(SelectCollectionView(
        widthOption: .fixed,
        items: Gender.allCases.map { $0.rawValue },
        widthSize: (UIScreen.main.bounds.width - 41) / 2,
        itemSpacing: 8,
        cellBackgroundColor: .dark02
    ))
    
    private lazy var genderInputStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [genderTitleLabel,
                                     genderSelectCollectionView]))
    
    private let userIntroGuideTitleLabel = InformationGuideLabel(
        guideText: "자기 소개",
        type: .optional
    )

    private let userIntroTextView: BasicTextView = BasicTextView(
        placeholder: "나를 더 잘 보여줄 수 있는 소개를 간단하게 적어주세요.\n(ex. 좋아하는 밴드, 밴드 경력 등)",
        maxCount: 300
    )

    private lazy var textViewStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [userIntroGuideTitleLabel,
                                     userIntroTextView]))

    private let snsTitleLabel = InformationGuideLabel(
        guideText: "SNS",
        type: .optional
    )

    private let snsFirstSubTitleLabel = BasicLabel(
        contentText: "* 본인의 SNS 계정을 입력해주세요.",
        fontStyle: .content,
        textColorInfo: .gray02
    )

    private let snsSecondSubTitleLabel = BasicLabel(
        contentText: "* 본인계정이 아닌 계정 등록 시 책임은 본인에게 있습니다.",
        fontStyle: .content,
        textColorInfo: .gray02
    )
    
    private lazy var snsGuideLabelStackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 5
        return $0
    }(UIStackView(arrangedSubviews: [snsTitleLabel,
                                     snsFirstSubTitleLabel,
                                     snsSecondSubTitleLabel]))

    private let youtubeTextField = SNSBoxView(type: .youTube, placeholder: "채널명")

    private let instagramTextField = SNSBoxView(type: .instagram, placeholder: "사용자 계정")

    private let soundCloudTextField = SNSBoxView(type: .soundCloud, placeholder: "사용자 계정")

    private lazy var snsInformationStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [snsGuideLabelStackView,
                                     youtubeTextField,
                                     instagramTextField,
                                     soundCloudTextField]))

    private lazy var nextButton: BottomButton = {
        //TODO: 밴드 정보 POST action 추가 필요
        $0.setTitle("다음", for: .normal)
        $0.isEnabled = false
        let action = UIAction { _ in
            self.showBandCreationDecisionViewController()
        }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(BottomButton())
    
    private lazy var scrollView: UIScrollView = {
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .dark01
        return $0
    }(UIScrollView())
    
    private lazy var contentStackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 60
        $0.backgroundColor = .dark01
        return $0
    }(UIStackView(arrangedSubviews: [titleStackView,
                                     textFieldStackView,
                                     ageInputStackView,
                                     genderInputStackView,
                                     textViewStackView,
                                     snsInformationStackView,
                                     nextButton]))
    
    // MARK: - Life Cycle
    
    init(instrumentList: [InstrumentList]? = nil) {
        self.instrumentList = instrumentList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.hideKeyboardWhenTappedAround()
        self.configureDelegate()
        self.setNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    // MARK: - Method
    
    private func configureDelegate() {
        self.genderSelectCollectionView.delegate = self
        self.ageSelectCollectionView.delegate = self
        self.userNamingTextField.delegate = self
        self.youtubeTextField.textField.delegate = self
        self.instagramTextField.textField.delegate = self
        self.soundCloudTextField.textField.delegate = self
    }
    
    private func attribute() {
        self.view.backgroundColor = .dark01
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              bottom: view.bottomAnchor,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        scrollView.addSubview(contentStackView)
        contentStackView.constraint(top: scrollView.contentLayoutGuide.topAnchor,
                                    leading: scrollView.contentLayoutGuide.leadingAnchor,
                                    bottom: scrollView.contentLayoutGuide.bottomAnchor,
                                    trailing: scrollView.contentLayoutGuide.trailingAnchor,
                                    padding: UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16))
    }
    
    private func checkNextButtonEnabledState() {
        let isAgeSelected = ageSelectCollectionView.isSelected()
        let isGenderSelected = genderSelectCollectionView.isSelected()
        let isAvailableName = userNamingTextField.isAvailableName()
        
        if isAgeSelected && isGenderSelected && isAvailableName {
            self.nextButton.isEnabled = true
        } else {
            self.nextButton.isEnabled = false
        }
    }
    
    private func showBandCreationDecisionViewController() {
        guard let age = Age(rawValue: ageSelectCollectionView.selectedItem())?.inEnglish,
              let gender = Gender(rawValue: genderSelectCollectionView.selectedItem())?.inEnglish,
              let instrumentList else { return }
        
        let snsList = [youtubeTextField.inputText(),
                       instagramTextField.inputText(),
                       soundCloudTextField.inputText()]
        
        let user = User(memberId: nil,
                        name: self.userNamingTextField.inputText(),
                        age: age,
                        gender: gender,
                        introduction: self.userIntroTextView.inputText(),
                        instrumentList: instrumentList,
                        snsList: snsList)
        Task {
            try await SignUpNetworkManager.shared.postUserInformation(user: user)
        }
        
        let viewcontroller = SetAuthorizationViewController()
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
}

extension UserInfoInputViewController: SelectCollectionViewDelegate {
    func collectionViewCellDidSelect() {
        self.checkNextButtonEnabledState()
    }
}

extension UserInfoInputViewController: TextLimitTextFieldDelegate {
    func textFieldTextDidChanged() {
        self.checkNextButtonEnabledState()
    }
}

// MARK: 키보드 높이 관련 함수

extension UserInfoInputViewController {
    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getKeyboardHeight(notification: )),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
    }
    
    @objc func getKeyboardHeight(notification: Notification) {
        keyBoardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
    }
}

extension UserInfoInputViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.frame.origin.y -= self.keyBoardHeight
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.frame.origin.y += self.keyBoardHeight
    }
}
