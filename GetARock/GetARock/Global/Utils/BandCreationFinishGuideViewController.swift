//
//  BandCreationFinishGuideViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/02.
//

import UIKit

final class BandCreationFinishGuideViewController: UIViewController {
    
    // MARK: View
    
    private let titleLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "밴드 가입이 완료되었어요!\n모여락에 오신걸 환영합니다! 🥳",
                 fontStyle: .headline01,
                 textColorInfo: .white))
    
    private let subTitleLabel: BasicLabel = {
        $0.numberOfLines = 3
        return $0
    }(BasicLabel(contentText: "주위 밴드와 소통하며 멤버들과 즐거운 밴드 생활의\n추억을 남길 준비 되셨나요?\n즐거운 모여락 이용을 위해 아래 내용을 확인해주세요!",
                 fontStyle: .content,
                 textColorInfo: .white))
    
    private lazy var titleStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 20
        return $0
    }(UIStackView(arrangedSubviews: [titleLabel, subTitleLabel]))
    
    private let guideContentTitle: BasicLabel = BasicLabel(contentText: "즐거운 밴드 생활",
                                                      fontStyle: .contentBold,
                                                      textColorInfo: .white)
    
    private let gatherRockGuideIcon: UIImageView = {
        $0.image = ImageLiteral.bubbleWithThunderIcon
        $0.tintColor = .white.withAlphaComponent(0.85)
        $0.constraint(.widthAnchor, constant: 26)
        $0.constraint(.heightAnchor, constant: 24)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let gatherRockTitleLabel: BasicLabel = BasicLabel(contentText: "주변 밴드 살펴보기",
                                                      fontStyle: .contentBold,
                                                      textColorInfo: .white)
    
    private let gatherRockSubtitleLabel: BasicLabel = {
        $0.numberOfLines = 5
        return $0
    }(BasicLabel(contentText: "지도를 기반으로 주변에 어떤 밴드들이 있는지 확인해보세요! 올바른 밴드 문화를 만들어봐요! (예: 합공, 공연홍보, 합주 등)",
                 fontStyle: .content,
                 textColorInfo: .white))
    
    private lazy var gatherRockLabelVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 5
        return $0
    }(UIStackView(arrangedSubviews: [gatherRockTitleLabel,
                                     gatherRockSubtitleLabel]))
    
    private lazy var gatherRockHstack: UIStackView = {
        $0.alignment = .top
        $0.axis = .horizontal
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [gatherRockGuideIcon, gatherRockLabelVstack]))
    
    private let bandTimelineGuideIcon: UIImageView = {
        $0.image = ImageLiteral.clockArrowCirclePathSymbol
        $0.tintColor = .white.withAlphaComponent(0.85)
        $0.constraint(.widthAnchor, constant: 26)
        $0.constraint(.heightAnchor, constant: 24)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let bandTimelineTitleLabel: BasicLabel = BasicLabel(contentText: "밴드 타임라인",
                                                      fontStyle: .contentBold,
                                                      textColorInfo: .white)
    
    private let bandTimelineSubtitleLabel: BasicLabel = {
        $0.numberOfLines = 5
        return $0
    }(BasicLabel(contentText: "우리 밴드가 열었던 모여락 이벤트가 모여 우리밴드 활동의 이력이 되어줍니다!",
                 fontStyle: .content,
                 textColorInfo: .white))
    
    private lazy var bandTimelineLabelVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 5
        return $0
    }(UIStackView(arrangedSubviews: [bandTimelineTitleLabel,
                                     bandTimelineSubtitleLabel]))
    
    private lazy var bandTimelineHstack: UIStackView = {
        $0.alignment = .top
        $0.axis = .horizontal
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [bandTimelineGuideIcon, bandTimelineLabelVstack]))
    
    private let commentGuideIcon: UIImageView = {
        $0.image = ImageLiteral.chatBubbleSymbol
        $0.tintColor = .white.withAlphaComponent(0.85)
        $0.constraint(.widthAnchor, constant: 26)
        $0.constraint(.heightAnchor, constant: 25)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let commentTitleLabel: BasicLabel = BasicLabel(contentText: "밴드 방명록",
                                                      fontStyle: .contentBold,
                                                      textColorInfo: .white)
    
    private let commentSubtitleLabel: BasicLabel = {
        $0.numberOfLines = 3
        return $0
    }(BasicLabel(contentText: "관심있는 밴드에 방명록을 남겨 소통할 수 있어요! 서로 성장하고 응원해주는 아름다운 밴드 문화를 만들어주세요!",
                 fontStyle: .content,
                 textColorInfo: .white))
    
    private lazy var commentVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 5
        return $0
    }(UIStackView(arrangedSubviews: [commentTitleLabel,
                                     commentSubtitleLabel]))
    
    private lazy var commentHstack: UIStackView = {
        $0.alignment = .top
        $0.axis = .horizontal
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [commentGuideIcon, commentVstack]))
    
    
    private lazy var containerStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 30
        $0.backgroundColor = .dark04
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 35, left: 20, bottom: 35, right: 20)
        $0.layer.cornerRadius = 20
        return $0
    }(UIStackView(arrangedSubviews: [guideContentTitle,
                                     gatherRockHstack,
                                     bandTimelineHstack,
                                     commentHstack]))

    private lazy var confirmButton: BottomButton = {
        let action = UIAction { _ in
            self.navigationController?.pushViewController(MainMapViewController(isFromSignUp: false), animated: true)
        }
        $0.setTitle("확인 완료 😎", for: .normal)
        $0.titleLabel?.font = .setFont(.headline02)
        $0.titleLabel?.textColor = .white
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(BottomButton())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attribute()
        self.setupLayout()
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.view.backgroundColor = .dark03
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupLayout() {
        self.view.addSubview(titleStackView)
        titleStackView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                  leading: view.leadingAnchor,
                                  trailing: view.trailingAnchor,
                                  padding: UIEdgeInsets(top: 100, left: 16, bottom: 0, right: 16))
        
        self.view.addSubview(containerStackView)
        containerStackView.constraint(top: titleStackView.bottomAnchor,
                                 leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16))
        
        self.view.addSubview(confirmButton)
        confirmButton.constraint(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                  centerX: view.centerXAnchor,
                                  padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
}

