//
//  BandInformationViewController.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/14.
//

import UIKit

final class BandInformationSetViewController: BaseViewController {
    
    // MARK: - Properties
    
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
    }(BasicLabel(
        contentText: "작성 정보는 프로필로 만들어집니다.\n밴드를 잘 어필할 수 있도록 작성해보세요! 😎",
        fontStyle: .headline03,
        textColorInfo: .gray02))
    
    private lazy var titleVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [pageIndicatorLabel,
                                     contentViewTitleLabel,
                                     contentViewSubTitleLabel]))

    private let bandNamingGuideTitleLabel: InformationGuideLabel = InformationGuideLabel(guideText: "밴드 이름", type: .required)
    
    private let bandNamingGuideSubLabel: BasicLabel = BasicLabel(
        contentText: "* 공백없이 20자 이하, 기호는 _만 입력 가능합니다.",
        fontStyle: .content,
        textColorInfo: .gray02)

    private lazy var bandNamingTextField: TextLimitTextField = TextLimitTextField(
        placeholer: "밴드 이름을 입력해주세요.",
        maxCount: 20,
        duplicationCheckType: .bandName,
        textExpressionCheck: true)
    
    private lazy var textFieldVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [bandNamingGuideTitleLabel,
                                     bandNamingGuideSubLabel,
                                     bandNamingTextField]))
    
    private let practicePlaceTitleLabel: InformationGuideLabel = InformationGuideLabel(guideText: "합주실 위치", type: .required)

    private let practicePlaceSubTitleLabel: BasicLabel = BasicLabel(
        contentText: "* 지도에서 우리밴드가 보여질 위치입니다.",
        fontStyle: .content,
        textColorInfo: .gray02)

    private lazy var practicePlaceSearchButton: BasicBoxView = {
        $0.showRightView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPracticePlaceSearchButton))
        $0.addGestureRecognizer(tapGesture)
        return $0
    }(BasicBoxView(text: "주소 검색"))

    private let detailPracticePlaceTextField: BasicTextField = BasicTextField(placeholder: "상세 주소를 입력해주세요. (선택)")

    private lazy var practicePlaceVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [practicePlaceTitleLabel,
                                     practicePlaceSubTitleLabel,
                                     practicePlaceSearchButton,
                                     detailPracticePlaceTextField]))
    
    private let bandIntroGuideTitleLabel: InformationGuideLabel = InformationGuideLabel(guideText: "밴드 소개", type: .optional)

    private let bandIntroTextView: BasicTextView = BasicTextView(
        placeholder: "우리 밴드를 더 잘 보여줄 수 있는 소개를 간단하게\n적어주세요.(ex. 좋아하는 밴드, 밴드 경력 등)",
        maxCount: 300)

    private lazy var textViewVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [bandIntroGuideTitleLabel, bandIntroTextView]))

    private let practiceSongTitleLabel: InformationGuideLabel = InformationGuideLabel(guideText: "합주곡", type: .optional)

    private let practiceSongSubTitleLabel: BasicLabel = BasicLabel(
        contentText: "* 최대 3개까지 등록 가능합니다.",
        fontStyle: .content,
        textColorInfo: .gray02)

    private lazy var addPracticeSongButton: DefaultButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = ImageLiteral.plusSymbol
        configuration.title = "합주곡 추가"
        configuration.attributedTitle?.font = UIFont.setFont(.contentBold)
        configuration.imagePadding = 10
        let button = DefaultButton(configuration: configuration)
        button.tintColor = .white
        button.constraint(.heightAnchor, constant: 55)
        button.addTarget(self, action: #selector(didTapAddPracticeSong), for: .touchUpInside)
        return button
    }()

    private lazy var practiceSongList: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [addPracticeSongButton]))

    private lazy var practiceSongVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [practiceSongTitleLabel,
                                     practiceSongSubTitleLabel,
                                     practiceSongList]))

    private let snsTitleLabel: InformationGuideLabel = InformationGuideLabel(guideText: "SNS", type: .optional)

    private let snsFirstSubTitleLabel = BasicLabel(
        contentText: "* 밴드의 SNS 계정을 입력해주세요.",
        fontStyle: .content,
        textColorInfo: .gray02)

    private let snsSecondSubTitleLabel = BasicLabel(
        contentText: "* 본인계정이 아닌 계정 등록 시 책임은 본인에게 있습니다.",
        fontStyle: .content,
        textColorInfo: .gray02)
    
    private lazy var snsGuideLabelVstack: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 5
        return $0
    }(UIStackView(arrangedSubviews: [snsTitleLabel,
                                     snsFirstSubTitleLabel,
                                     snsSecondSubTitleLabel]))

    private let youtubeTextField: SNSBoxView = SNSBoxView(type: .youTube, placeholder: "채널명")

    private let instagramTextField: SNSBoxView = SNSBoxView(type: .instagram, placeholder: "사용자 계정")

    private let soundCloudTextField: SNSBoxView = SNSBoxView(type: .soundCloud, placeholder: "사용자 계정")

    private lazy var snsInformationVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [snsGuideLabelVstack,
                                     youtubeTextField,
                                     instagramTextField,
                                     soundCloudTextField]))

    private let informationFillCompleteButton: BottomButton = {
        //TODO: 밴드 정보 POST action 추가 필요
        $0.setTitle("추가", for: .normal)
        return $0
    }(BottomButton())
    
    private lazy var mainScrollView: UIScrollView = {
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .dark01
        return $0
    }(UIScrollView())

    private lazy var contentView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 60
        $0.backgroundColor = .dark01
        return $0
    }(UIStackView(arrangedSubviews: [titleVstack,
                                     textFieldVstack,
                                     practicePlaceVstack,
                                     practiceSongVstack,
                                     textViewVstack,
                                     snsInformationVstack,
                                    informationFillCompleteButton]))
    
    private let keyBoardHeightPaddingView: UIView = UIView(frame: .zero)

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setTextFieldDelegate()
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
                                  bottom: view.bottomAnchor,
                                  trailing: view.safeAreaLayoutGuide.trailingAnchor)

        contentView.constraint(top: mainScrollView.topAnchor,
                               leading: mainScrollView.leadingAnchor,
                               bottom: mainScrollView.bottomAnchor,
                               trailing: mainScrollView.trailingAnchor,
                               padding: UIEdgeInsets(top: 20, left: 16, bottom: 25, right: 16))
    }
    
    private func setTextFieldDelegate() {
        youtubeTextField.textField.delegate = self
        instagramTextField.textField.delegate = self
        soundCloudTextField.textField.delegate = self
    }
}

// MARK: - Extension

extension BandInformationSetViewController {

    @objc func didTapPracticePlaceSearchButton() {
        let nextViewController = PracticePlaceSearchViewController()
        nextViewController.completion = { [weak self] locationInformation in
            print("completion Handler 작동")
            self?.practicePlaceSearchButton.configureText(with: locationInformation)
            self?.practicePlaceSearchButton.hideRightView()
        }
        navigationController?.pushViewController(nextViewController, animated: true)
    }

//MARK: PR 추가
    @objc func didTapAddPracticeSong() {
        let nextViewController = AddPracticeSongViewController()
        nextViewController.completion = { [weak self] songs in
            let addedSongs: [PracticeSongBoxView] = self?.makePracticeSongBoxes(with: songs) ?? []
            for song in addedSongs {
                if self?.practiceSongList.arrangedSubviews.count ?? 0 > 3 { break }
                self?.practiceSongList.addArrangedSubview(song)
            }
        }
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func didTouchScreen() {
        self.view.endEditing(true)
    }
    
    @objc func getKeyboardHeight(notification: Notification) {
        keyBoardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
    }

    //TODO: 밴드 정보를 서버에 POST 하는 코드 추가 예정
    private func postBandInformation() {

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

//MARK: PR 추가
extension BandInformationSetViewController {
    func makePracticeSongBoxes(with data: [PracticeSongCardView]) -> [PracticeSongBoxView] {
        var result: [PracticeSongBoxView] = []
        for datum in data {
            let practiceSong: PracticeSongBoxView = PracticeSongBoxView()
            practiceSong.configure(data: datum)
            result.append(practiceSong)
        }
        return result
    }
}
