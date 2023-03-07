//
//  userInfomationView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/03/07.
//

import UIKit

final class UserInfomationView: UIView {

    // MARK: - Property
    
    private var userData: UserInformationVO
    private var userInstrument: [InstrumentListVO]
    private var userBandList: [BandListVO]?
    private var userIntro: String?
    private var bandSNS: [SnsListVO]?
    
    // MARK: - View
    
    private let scrollView: UIScrollView = {
        $0.backgroundColor = .dark01
        return $0
    }(UIScrollView())

    // ---------------------------------------------------------------------------------------- 1. 포지션
    private let userPositionTitleLable = BasicLabel(
        contentText: "내 포지션 😎",
        fontStyle: .headline01,
        textColorInfo: .white
    )

    private lazy var userPositionStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [userPositionTitleLable]))
    
    // ---------------------------------------------------------------------------------------- 2.소속밴드
    
    private let userBandTitleLable = BasicLabel(
        contentText: "소속 밴드 🎸",
        fontStyle: .headline01,
        textColorInfo: .white
    )

   private let userBandButton = BandButtonView(bandName: "오아시스",
                                               membersNumber: 2,
                                               membersAge: "20-30대")

    private lazy var userBandStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [userBandTitleLable, userBandButton]))

    // ---------------------------------------------------------------------------------------- 3.유저소개
    
    private let userIntroTitleLable = BasicLabel(
        contentText: "자기 소개 📢",
        fontStyle: .headline01,
        textColorInfo: .white
    )

    // paddingLabel 들어오면..
//    private let bandIntroLable: PaddingLabel = {
//        $0.font = UIFont.setFont(.content)
//        $0.numberOfLines = 0
//        $0.textColor = .white
//        $0.clipsToBounds = false
//        $0.layer.cornerRadius = 10
//        $0.backgroundColor = .dark02
//        $0.layer.borderColor = UIColor.gray02.cgColor
//        $0.layer.borderWidth = 1
//        $0.numberOfLines = 0
//        return $0
//    }(PaddingLabel())

    private lazy var userIntroStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [userIntroTitleLable]))

    // ---------------------------------------------------------------------------------------- 4. SNS
    private let userSNSTitleLable = BasicLabel(
        contentText: "SNS 🙌",
        fontStyle: .headline01,
        textColorInfo: .white
    )

    //TODO - : SNS의 데이터 구조 수정이 끝나면 전달 데이터 반영 필요
    private lazy var userSNSListView = SNSListStackView(data: SNS(youtube: nil, instagram: nil, soundCloud: nil))

    private lazy var userSNSStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [userSNSTitleLable, userSNSListView]))

    
    // ---------------------------------------------------------------------------------------- 모든 뷰
    
    private lazy var userInfoStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 60
        $0.distribution = .fill
        return $0
    }(UIStackView(arrangedSubviews: [userPositionStackView, userBandStackView, userIntroStackView, userSNSStackView]))

    // MARK: - Init
    
    init(userData: UserInformationVO) {
        self.userData = userData
        self.userInstrument = userData.instrumentList
        self.userBandList = userData.bandList
        self.userIntro = userData.introduction
        self.bandSNS = userData.snsList
        super.init(frame: .zero)
        setupLayout()
        attribute()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        scrollView.addSubview(userInfoStackView)
        userInfoStackView.constraint(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            bottom: scrollView.bottomAnchor,
            trailing: scrollView.trailingAnchor,
            padding: UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        )
    }


}
