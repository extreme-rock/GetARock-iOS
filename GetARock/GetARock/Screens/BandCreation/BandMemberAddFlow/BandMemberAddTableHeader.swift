//
//  BandMemberAddTableHeader.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/16.
//

import UIKit

final class BandMemberAddTableViewHeader: UITableViewHeaderFooterView {

    // MARK: 이 뷰를 업로드할 때, 서버에 UID를 날리고 그 UID에 해당하는 닉네임을 업데이트해야함
    private let stepLabel: BasicLabel = BasicLabel(contentText: "2/3", fontStyle: .caption, textColorInfo: .gray02)

    private let titleLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "밴드 멤버를\n알려주세요", fontStyle: .largeTitle01, textColorInfo: .white))

    private let subTitleLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "처음 선택한 악기가\n나의 Main 포지션이 됩니다.", fontStyle: .content, textColorInfo: .gray02))

    //TODO: BandInforSet VC에서 여기 configuration 적용 버튼 만들어야함
    let inviteMemberButton: DefaultButton = {
        $0.setTitle("멤버 초대", for: .normal)
        return $0
    }(DefaultButton())

    //TODO: BandInforSet VC에서 여기 configuration 적용 버튼 만들어야함
    let inviteUnRegisteredMemberButton: DefaultButton = {
        $0.setTitle("미가입 회원 추가", for: .normal)
        return $0
    }(DefaultButton())

    let sectionTitle = BasicLabel(contentText: "밴드 멤버 1인", fontStyle: .content, textColorInfo: .white)

    private lazy var buttonHstack: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 5
        return $0
    }(UIStackView(arrangedSubviews: [inviteMemberButton, inviteUnRegisteredMemberButton]))

    private lazy var titleVstack: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView(arrangedSubviews: [stepLabel, titleLabel, subTitleLabel, buttonHstack, sectionTitle]))

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        attribute()
        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(titleVstack)
        titleVstack.constraint(top: contentView.safeAreaLayoutGuide.topAnchor,
                               leading: contentView.safeAreaLayoutGuide.leadingAnchor,
                               bottom: contentView.safeAreaLayoutGuide.bottomAnchor,
                               trailing: contentView.safeAreaLayoutGuide.trailingAnchor,
                               padding: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))

        inviteMemberButton.constraint(.heightAnchor, constant: 55)

        inviteUnRegisteredMemberButton.constraint(.heightAnchor, constant: 55)
    }

    private func attribute() {
        contentView.backgroundColor = .dark01
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

