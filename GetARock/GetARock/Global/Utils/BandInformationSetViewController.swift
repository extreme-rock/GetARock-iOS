//
//  BandInformationViewController.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/14.
//

import UIKit

final class BandInformationSetViewController: BaseViewController {

    // MARK: - Property

    // MARK: - View

    private let titleLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "밴드에 대해\n간단히 알려주세요", fontStyle: .largeTitle01, textColorInfo: .white))

    private let subTitleLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "작성해주신 정보는 내 프로필로 만들어지고\n프로필은 다른 사용자들이 볼 수 있어요", fontStyle: .headline03, textColorInfo: .white))

    private let bandNameLabel = InformationGuideLabel(guideText: "밴드 이름", type: .optional)

    private let bandIntroductionLabel = InformationGuideLabel(guideText: "밴드 소개", type: .optional)

    private lazy var bandNamingTextFieldView: TextLimitTextField = TextLimitTextField(placeholer: "밴드 이름을 입력해주세요", maxCount: 10, duplicationCheckType: .bandName, textExpressionCheck: true)

    private let bandIntroTextView: BasicTextView = BasicTextView(placeholder: "우리 밴드를 더 잘 보여줄 수 있는 소개를 간단하게\n적어주세요(ex. 좋아하는 밴드, 밴드 경력 등)", maxCount: 300)
    
    private lazy var titleVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [titleLabel, subTitleLabel]))

    private lazy var textFieldVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [bandNameLabel, bandNamingTextFieldView]))

    private lazy var textViewVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [bandIntroductionLabel, bandIntroTextView]))

    private var practiceLabel = InformationGuideLabel(guideText: "합주실 위치", type: .optional)

    private var practiceSubLabel = BasicLabel(contentText: "* 지도에서 우리밴드가 보여질 위치입니다.", fontStyle: .content, textColorInfo: .white)

    //TODO: 합주실 찾기 VC로 이동하는 TapGesture 추가
    private lazy var practicePlace = {
        let boxView = BasicBoxView(text: "합주실 위치")
        //MARK: Show RightView 색상 수정 필요
        boxView.showRightView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentLocationSearchViewController))
        boxView.addGestureRecognizer(tapGesture)
        return boxView
    }()

    private let detailPracticePlace = BasicTextField(placeholder: "상세 주소를 입력해주세요 (선택)")

    private lazy var practicePlaceStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [practiceLabel, practiceSubLabel, practicePlace, detailPracticePlace]))

    private var practiceSongLabel = InformationGuideLabel(guideText: "합주곡", type: .optional)

    private var practiceSongSubLabel = BasicLabel(contentText: "* 최대 3개까지 등록 가능합니다.", fontStyle: .content, textColorInfo: .white)

    //MARK: Default Button 형식으로 바꾸기 필요
    //TODO: 추후에 합주곡 삽입 action 추가 필요
    private lazy var addPracticeSongButton = {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = UIFont.setFont(.contentBold)
        configuration.baseBackgroundColor = .systemPurple
        configuration.attributedTitle = AttributedString("합주곡 추가", attributes: container)
        configuration.image = UIImage(systemName: "plus")
        configuration.imagePadding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 0, bottom: 13, trailing: 0)
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(didTapAddPracticeSong), for: .touchUpInside)

        return button
    }()

    private lazy var practiceSongList: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 20
        return $0
        // ScrollView라서 여기는 StackView로 구현함
    }(UIStackView(arrangedSubviews: [addPracticeSongButton]))

    private lazy var practiceSongStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [practiceSongLabel, practiceSongSubLabel, practiceSongList]))

    private let snsTitleLabel = InformationGuideLabel(guideText: "SNS", type: .optional)

    private let snsSubTitleLabel = BasicLabel(contentText: "* 밴드의 SNS 계정을 입력해주세요 ", fontStyle: .content, textColorInfo: .gray02)

    private let snsSecondSubTitleLabel = BasicLabel(contentText: "* 본인계정이 아닌 계정 등록 시 책임은 본인에게 있습니다?", fontStyle: .content, textColorInfo: .gray02)

    private let youtubeTextField = SNSBoxView(type: .youTube, placeholder: "채널명")

    private let instagramTextField = SNSBoxView(type: .instagram, placeholder: "사용자 계정")

    private let soundCloundTextField = SNSBoxView(type: .soundCloud, placeholder: "사용자 계정")

    private lazy var snsStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [snsTitleLabel, snsSubTitleLabel, snsSecondSubTitleLabel, youtubeTextField, instagramTextField, soundCloundTextField]))

    private lazy var contentView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 40
        $0.backgroundColor = .dark01
        $0.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        return $0
    }(UIStackView(arrangedSubviews: [titleVstack,
                                     textFieldVstack,
                                     practicePlaceStack,
                                     practiceSongStack,
                                     textViewVstack,
                                     snsStack]))

    private lazy var mainScrollView: UIScrollView = {
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .dark01
        $0.delegate = self
        return $0
    }(UIScrollView())

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    // MARK: - Method

    private func setupLayout() {
        
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)

        titleVstack.constraint(leading: view.safeAreaLayoutGuide.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))

        mainScrollView.constraint(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)

        contentView.constraint(top: mainScrollView.topAnchor, leading: mainScrollView.leadingAnchor, bottom: mainScrollView.bottomAnchor, trailing: mainScrollView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 16, bottom: 10, right: 16))
        contentView.constraint(.widthAnchor, constant: UIScreen.main.bounds.width - 50)

    }
}

    // MARK: Extension

extension BandInformationSetViewController {
    
    @objc func presentLocationSearchViewController() {
    }
    
    @objc func didTapAddPracticeSong() {
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

