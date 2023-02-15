//
//  BandInformationViewController.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/14.
//

import UIKit

final class BandInformationSetViewController: BaseViewController {
    
    private var keyBoardHeight: CGFloat = 280

    // MARK: - View
    
    private let pageIndicatorLabel: UILabel = {
        $0.font = .setFont(.headline03)
        $0.text = "3/3"
        $0.textColor = .gray02
        return $0
    }(UILabel())

    private let contentViewTitleLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "밴드에 대해\n간단히 알려주세요", fontStyle: .largeTitle01, textColorInfo: .white))

    private let contentViewSubTitleLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "작성해주신 정보는 내 프로필로 만들어지고\n프로필은 다른 사용자들이 볼 수 있어요", fontStyle: .headline03, textColorInfo: .gray02))
    
    private lazy var titleVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [pageIndicatorLabel,contentViewTitleLabel, contentViewSubTitleLabel]))

    private let bandNamingGuideTitleLabel = InformationGuideLabel(guideText: "밴드 이름", type: .optional)
    
    private let bandNamingGuideSubLabel = BasicLabel(
        contentText: "* 공백없이 15자 이하, 기호는 _만 입력 가능합니다.",
        fontStyle: .content,
        textColorInfo: .gray02)

    private lazy var bandNamingTextField: TextLimitTextField = TextLimitTextField(
        placeholer: "밴드 이름을 입력해주세요",
        maxCount: 15,
        duplicationCheckType: .bandName,
        textExpressionCheck: true)
    
    private lazy var textFieldVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [bandNamingGuideTitleLabel, bandNamingGuideSubLabel, bandNamingTextField]))
    
    private let practicePlaceTitleLabel = InformationGuideLabel(guideText: "합주실 위치", type: .required)

    private let practicePlaceSubTitleLabel = BasicLabel(
        contentText: "* 지도에서 우리밴드가 보여질 위치입니다.",
        fontStyle: .content,
        textColorInfo: .gray02)

    //TODO: 합주실 찾기 VC로 이동하는 TapGesture 추가
    private lazy var practicePlaceSearchButton = {
        $0.showRightView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentLocationSearchViewController))
        $0.addGestureRecognizer(tapGesture)
        return $0
    }(BasicBoxView(text: "주소 검색"))

    private let detailPracticePlaceTextField = BasicTextField(placeholder: "상세 주소를 입력해주세요 (선택)")

    private lazy var practicePlaceVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [practicePlaceTitleLabel, practicePlaceSubTitleLabel, practicePlaceSearchButton, detailPracticePlaceTextField]))
    
    private let bandIntroGuideTitleLabel = InformationGuideLabel(guideText: "밴드 소개", type: .optional)

    private let bandIntroTextView: BasicTextView = BasicTextView(
        placeholder: "우리 밴드를 더 잘 보여줄 수 있는 소개를 간단하게\n적어주세요(ex. 좋아하는 밴드, 밴드 경력 등)",
        maxCount: 300)

    private lazy var textViewVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [bandIntroGuideTitleLabel, bandIntroTextView]))

    private var practiceSongTitleLabel = InformationGuideLabel(guideText: "합주곡", type: .optional)

    private var practiceSongSubTitleLabel = BasicLabel(
        contentText: "* 최대 3개까지 등록 가능합니다.",
        fontStyle: .content,
        textColorInfo: .gray02)

    //TODO: 추후에 합주곡 삽입 action 추가 필요
    private lazy var addPracticeSongButton: DefaultButton = {
        var configuration = UIButton.Configuration.plain()
        //TODO: 이전 PR 머지 이후 이미지 리터럴로 변경하기
        configuration.image = UIImage(systemName: "plus")
        configuration.title = "합주곡 추가"
        configuration.attributedTitle?.font = UIFont.setFont(.contentBold)
        configuration.imagePadding = 10
        let button = DefaultButton(configuration: configuration)
        button.tintColor = .white
        button.constraint(.heightAnchor, constant: 55)
        return button
    }()

    private lazy var practiceSongList: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 20
        return $0
        // ScrollView라서 여기는 StackView로 구현함
    }(UIStackView(arrangedSubviews: [addPracticeSongButton]))

    private lazy var practiceSongVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [practiceSongTitleLabel, practiceSongSubTitleLabel, practiceSongList]))

    private let snsTitleLabel = InformationGuideLabel(guideText: "SNS", type: .optional)

    private let snsFirstSubTitleLabel = BasicLabel(
        contentText: "* 밴드의 SNS 계정을 입력해주세요 ",
        fontStyle: .content,
        textColorInfo: .gray02)

    private let snsSecondSubTitleLabel = BasicLabel(
        contentText: "* 본인계정이 아닌 계정 등록 시 책임은 본인에게 있습니다?",
        fontStyle: .content,
        textColorInfo: .gray02)
    
    private lazy var snsGuideLabelVstack: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 5
        return $0
    }(UIStackView(arrangedSubviews: [snsTitleLabel, snsFirstSubTitleLabel, snsSecondSubTitleLabel]))

    private let youtubeTextField = SNSBoxView(type: .youTube, placeholder: "채널명")

    private let instagramTextField = SNSBoxView(type: .instagram, placeholder: "사용자 계정")

    private let soundCloudTextField = SNSBoxView(type: .soundCloud, placeholder: "사용자 계정")

    private lazy var snsInformationVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [snsGuideLabelVstack,
                                     youtubeTextField,
                                     instagramTextField,
                                     soundCloudTextField]))
    
    private lazy var mainScrollView: UIScrollView = {
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .dark01
        $0.delegate = self
        return $0
    }(UIScrollView())

    private lazy var contentView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 40
        $0.backgroundColor = .dark01
        $0.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        return $0
    }(UIStackView(arrangedSubviews: [titleVstack,
                                     textFieldVstack,
                                     practicePlaceVstack,
                                     practiceSongVstack,
                                     textViewVstack,
                                     snsInformationVstack]))
    
    private let keyBoardHeightPaddingView: UIView = UIView(frame: .zero)

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setDelegate()
        setKeyboardDismiss()
        setNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    // MARK: - Method
    
    private func setKeyboardDismiss() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTouchScreen))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        mainScrollView.addGestureRecognizer(recognizer)
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getKeyboardHeight(notification: )),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
    }

    private func setupLayout() {
        
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        
        mainScrollView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                  leading: view.safeAreaLayoutGuide.leadingAnchor,
                                  bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                  trailing: view.safeAreaLayoutGuide.trailingAnchor)

        contentView.constraint(top: mainScrollView.topAnchor,
                               leading: mainScrollView.leadingAnchor,
                               bottom: mainScrollView.bottomAnchor,
                               trailing: mainScrollView.trailingAnchor,
                               padding: UIEdgeInsets(top: 20, left: 16, bottom: 25, right: 16))
    }
    
    private func setDelegate() {
        youtubeTextField.textField.delegate = self
        instagramTextField.textField.delegate = self
        soundCloudTextField.textField.delegate = self
    }
}

// MARK: - Extension

extension BandInformationSetViewController {
    
    @objc func presentLocationSearchViewController() {
    }
    
    @objc func didTapAddPracticeSong() {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.mainScrollView.endEditing(true)
    }
    
    @objc func didTouchScreen() {
        self.view.endEditing(true)
    }
    
    @objc func getKeyboardHeight(notification: Notification) {
        keyBoardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
    }
}

extension BandInformationSetViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.frame.origin.y -= self.keyBoardHeight
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.frame.origin.y += self.keyBoardHeight
    }
}

//MARK: ScrollView 가로 스크롤 막기

extension BandInformationSetViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}

