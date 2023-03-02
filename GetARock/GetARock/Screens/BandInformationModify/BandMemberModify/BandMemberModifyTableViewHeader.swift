//
//  BandMemberModifyTableViewHeader.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/01.
//

import UIKit

final class BandMemberModifyTableViewHeader: UITableViewHeaderFooterView {
    
    //MARK: View

    private let pageIndicatorLabel: BasicLabel = BasicLabel(contentText: "2/3",
                                                            fontStyle: .headline03,
                                                            textColorInfo: .gray02)

    private let titleLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "밴드 멤버를\n모두 알려주세요",
                 fontStyle: .largeTitle01,
                 textColorInfo: .white))

    private let subTitleLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "다른 밴드가 우리 밴드 멤버를 볼 수 있도록\n모든 멤버를 초대 및 등록해주세요",
                 fontStyle: .headline03,
                 textColorInfo: .gray02))

    let inviteMemberButton: DefaultButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = ImageLiteral.magnifyingGlassSymbol
        configuration.title = "멤버 초대"
        configuration.attributedTitle?.font = UIFont.setFont(.contentBold)
        configuration.imagePadding = 5
        let button = DefaultButton(configuration: configuration)
        button.tintColor = .white
        button.constraint(.heightAnchor, constant: 55)
        return button
    }()

    let inviteUnRegisteredMemberButton: DefaultButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = ImageLiteral.plusSymbol
        configuration.title = "미가입 회원 추가"
        configuration.attributedTitle?.font = UIFont.setFont(.contentBold)
        configuration.imagePadding = 5
        let button = DefaultButton(configuration: configuration)
        button.tintColor = .white
        button.constraint(.heightAnchor, constant: 55)
        return button
    }()

    let sectionTitle = BasicLabel(contentText: "밴드 멤버 1인",
                                  fontStyle: .content,
                                  textColorInfo: .white)

    private lazy var buttonHstack: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [inviteMemberButton,
                                     inviteUnRegisteredMemberButton]))

    private lazy var titleVstack: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 20
        return $0
    }(UIStackView(arrangedSubviews: [pageIndicatorLabel,
                                     titleLabel,
                                     subTitleLabel,
                                     buttonHstack,
                                     sectionTitle]))
    
    //MARK: init

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        attribute()
        setupLayout()
    }
    
    //MARK: Method

    private func setupLayout() {
        contentView.addSubview(titleVstack)
        titleVstack.constraint(to: contentView)
    }

    private func attribute() {
        contentView.backgroundColor = .dark01
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


