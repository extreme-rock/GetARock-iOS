//
//  ModifyUserProfileViewController.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/13.
//

import UIKit

final class ModifyUserProfileViewController: UIViewController {
    
    // MARK: - Property
    
    // MARK: - View
    
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
    }(UIStackView(arrangedSubviews: [contentViewTitleLabel,
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
        items: ["20대 미만", "20대", "30대", "40대", "50대", "60대 이상"],
        widthSize: 25,
        itemSpacing: 5
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
        items: ["남자", "여자"],
        widthSize: (UIScreen.main.bounds.width - 41) / 2,
        itemSpacing: 8
    ))
    
    private lazy var genderInputStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [genderTitleLabel,
                                     genderSelectCollectionView]))
    
    private let userIntroGuideTitleLabel = InformationGuideLabel(guideText: "자기 소개", type: .optional)

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

    private let snsTitleLabel = InformationGuideLabel(guideText: "SNS", type: .optional)

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
    
    private lazy var scrollView: UIScrollView = {
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .dark01
        return $0
    }(UIScrollView())
    
    private let contentView = UIView()
    
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
                                     snsInformationStackView]))
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.hideKeyboardWhenTappedAround()
    }
    
    private func attribute() {
        self.view.backgroundColor = .dark01
    }
    
    private func setupLayout() {
        //MARK: - scrollView
        
        view.addSubview(scrollView)
        scrollView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              bottom: view.bottomAnchor,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        scrollView.addSubview(contentView)
        contentView.constraint(top: scrollView.contentLayoutGuide.topAnchor,
                               leading: scrollView.contentLayoutGuide.leadingAnchor,
                               bottom: scrollView.contentLayoutGuide.bottomAnchor,
                               trailing: scrollView.contentLayoutGuide.trailingAnchor)
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        //MARK: - contentView
        
        contentView.addSubview(contentStackView)
        contentStackView.constraint(top: contentView.topAnchor,
                                    leading: contentView.leadingAnchor,
                                    bottom: contentView.bottomAnchor,
                                    trailing: contentView.trailingAnchor,
                                    padding: UIEdgeInsets(top: 20, left: 16, bottom: 38, right: 16))
        
    }
}
