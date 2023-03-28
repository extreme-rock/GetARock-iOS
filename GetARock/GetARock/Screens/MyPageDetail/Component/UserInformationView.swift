//
//  userInfomationView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/03/07.
//

import UIKit

final class UserInformationView: UIView {
    
    // MARK: - Property
    
    private var userData: UserInformationVO
    private var userInstrumentCollectionViewItem: [Item] = []
    
    // MARK: - View
    
    private let scrollView: UIScrollView = {
        $0.backgroundColor = .dark01
        return $0
    }(UIScrollView())
    
    private let userPositionTitleLabel = BasicLabel(
        contentText: "내 포지션 😎",
        fontStyle: .headline01,
        textColorInfo: .white
    )
    
    private lazy var userPositionCollectionView = PositionCollectionView(
        cellType: .position,
        items: userInstrumentCollectionViewItem,
        isNeedHeader: false)
    
    private lazy var userPositionStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [userPositionTitleLabel, userPositionCollectionView]))
    
    private let userBandTitleLabel = BasicLabel(
        contentText: "소속 밴드 🎸",
        fontStyle: .headline01,
        textColorInfo: .white
    )
    
    //TODO: - 추후 본인의 계정에만 노출 되어야함
    private let addBandButton: UIButton = {
        let action = UIAction {_ in
            NotificationCenter.default.post(name: NSNotification.Name.presentLeaderPositionSelectViewController,
                                            object: nil,
                                            userInfo: nil)
            print("밴드 추가 버튼 눌림!!")
        }
        $0.setImage(ImageLiteral.plusSymbol, for: .normal)
        $0.tintColor = .white
        $0.addAction(action, for: .touchUpInside)
        $0.constraint(.widthAnchor, constant: 20)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return $0
    }(UIButton())
    
    private lazy var bandTitleStackView: UIStackView = {
        $0.axis = .horizontal
        return $0
    }(UIStackView(arrangedSubviews: [userBandTitleLabel,addBandButton]))
    
    private let userBandButtonStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView())
    
    private lazy var userBandStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [bandTitleStackView, userBandButtonStackView]))
    
    private let userIntroTitleLabel = BasicLabel(
        contentText: "자기 소개 📢",
        fontStyle: .headline01,
        textColorInfo: .white
    )
    
    private let userIntroLabel: PaddingLabel = {
        $0.font = UIFont.setFont(.content)
        $0.numberOfLines = 0
        $0.textColor = .white
        $0.clipsToBounds = false
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .dark02
        $0.layer.borderColor = UIColor.gray02.cgColor
        $0.layer.borderWidth = 1
        return $0
    }(PaddingLabel())
    
    private lazy var userIntroStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [userIntroTitleLabel, userIntroLabel]))
    
    private let userSNSTitleLabel = BasicLabel(
        contentText: "SNS 🙌",
        fontStyle: .headline01,
        textColorInfo: .white
    )
    
    private lazy var userSNSListView = SNSListStackView(data: userData.snsList ?? [])
    
    private lazy var userSNSStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [userSNSTitleLabel, userSNSListView]))
    
    private lazy var userInfoStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 60
        $0.distribution = .fill
        return $0
    }(UIStackView(arrangedSubviews: [userPositionStackView, userBandStackView, userIntroStackView, userSNSStackView]))
    
    // MARK: - Init
    
    init(userData: UserInformationVO) {
        self.userData = userData
        super.init(frame: .zero)
        transformPositionData()
        setupLayout()
        attribute()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.backgroundColor = .dark01
    }
    
    private func setupLayout() {
        self.addSubview(scrollView)
        scrollView.constraint(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            bottom: self.bottomAnchor,
            trailing: self.trailingAnchor
        )
        
        setUserPositionCollectionView()
        setUserBandButton()
        setUserIntro()
        scrollView.addSubview(userInfoStackView)
        userInfoStackView.constraint(
            top: scrollView.contentLayoutGuide.topAnchor,
            leading: scrollView.contentLayoutGuide.leadingAnchor,
            bottom: scrollView.contentLayoutGuide.bottomAnchor,
            trailing: scrollView.contentLayoutGuide.trailingAnchor,
            padding: UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        )
    }
    
    private func setUserPositionCollectionView() {
        userPositionCollectionView.constraint(
            .widthAnchor,
            constant: UIScreen.main.bounds.width - 32
        )
        userPositionCollectionView.constraint(
            .heightAnchor,
            constant: CGFloat((140 + 10) * (userData.instrumentList.count-1)/2 + 140)
        )
    }
    
    private func transformPositionData() {
        //TODO: - 유저의 메인악기는 메인 표시 부여 및 배경색상 변경해야함
        let userInstrumentList = userData.instrumentList.map {
            Position(instrumentName: Instrument(rawValue: $0.name)?.inKorean ?? $0.name,
                     instrumentImageName: setInstrumentImage(instrumentName: $0.name), isETC: false)
        }
        
        userInstrumentList.forEach {
            userInstrumentCollectionViewItem.append(.position($0))
        }
    }
    
    private func setInstrumentImage(instrumentName: String) -> Instrument {
        return Instrument(rawValue: instrumentName) ?? .etc
    }
    
    private func setUserBandButton() {
        if let userBand = userData.bandList.map({ $0 }) {
            if userBand.count == 0 {
                let emptyView = EmptyView(type: .noBand)
                self.userBandButtonStackView.addArrangedSubview(emptyView)
            }
            else {
                userBand.forEach{
                    let bandButton = BandButtonView(bandID: $0.bandID,
                                                    bandName: $0.name,
                                                    membersNumber: $0.memberCount,
                                                    membersAge: $0.memberAge)
                    self.userBandButtonStackView.addArrangedSubview(bandButton)
                }
            }
        }
    }
    
    private func setUserIntro() {
        let userIntro = userData.introduction
        if userIntro == nil {
            let emptyView = EmptyView(type: .noIntroduction)
            userIntroStackView.removeArrangedSubview(userIntroLabel)
            userIntroStackView.addArrangedSubview(emptyView)
        } else {
            userIntroLabel.text = userIntro
        }
    }
}
