//
//  BandMemberModifyCell.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/19.
//

import UIKit

final class BandMemberModifyCell: UIStackView, Identifiable {
    
    var id: String = UUID().uuidString
    
    var isSelectedState: Bool = false {
        didSet {
            selectButton.setImage(UIImage(
                systemName: isSelectedState ? "checkmark.circle" : "checkmark.circle",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 22)),for: .normal)
            selectButton.tintColor = isSelectedState ? .systemPurple : .gray02
        }
    }
    
    private let userNameLabel: BasicLabel = {
        $0.setContentHuggingPriority(
            UILayoutPriority.defaultHigh,
            for: .horizontal)
        return $0
    }(BasicLabel(
        contentText: "쏘시지불나방캐리어쏘시지",
        fontStyle: .headline01,
        textColorInfo: .white))
    
    private let userGenderAgeLabel: BasicLabel = BasicLabel(
        contentText: "남 | 20대",
        fontStyle: .content,
        textColorInfo: .gray02)
    
    private lazy var userDetailInfoHstack: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [userNameLabel,
                                     userGenderAgeLabel]))
    
    private let instrumentListLabel: BasicLabel = BasicLabel(
        contentText: "베이스",
        fontStyle: .content,
        textColorInfo: .gray02)
    
    private lazy var userInfoVStack: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [userDetailInfoHstack,
                                     instrumentListLabel]))
    
    private lazy var memberStateIcon: UIImageView = {
        $0.constraint(.widthAnchor, constant: 45)
        $0.constraint(.heightAnchor, constant: 45)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var leaderButton: UIButton = {
        //MARK: ImageLiteral로 바꾸기
        $0.setImage(UIImage(systemName: "crown"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray01
        $0.constraint(.widthAnchor, constant: 45)
        $0.constraint(.heightAnchor, constant: 45)
        return $0
    }(UIButton(type: .custom))
    
    private lazy var selectButton: UIButton = {
        $0.contentMode = .scaleAspectFit
        $0.setImage(UIImage(
            systemName: "checkmark.circle",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 22)),for: .normal)
        $0.tintColor = .gray02
        $0.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        return $0
    }(UIButton(type: .custom))
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        attribute()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        self.backgroundColor = .dark01
        selectButton.isHidden = true
        self.axis = .horizontal
        self.spacing = 20
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        self.addArrangedSubview(memberStateIcon)
        self.addArrangedSubview(userInfoVStack)
        self.addArrangedSubview(leaderButton)
        self.addArrangedSubview(selectButton)
    }
    
    func configure(data: SearchedUserInfo) {
        
        if data.name.count > 10 {
            userNameLabel.numberOfLines = 1
            userNameLabel.adjustsFontSizeToFitWidth = true
            userNameLabel.minimumScaleFactor = 0.9
            userNameLabel.lineBreakMode = .byTruncatingTail
            userNameLabel.constraint(.widthAnchor, constant: 160)
        }
        
        userNameLabel.text = data.name
        if data.instrumentList.count >= 2 {
            instrumentListLabel.text = data.instrumentList.map({ Instrument(rawValue: $0.name)?.inKorean ?? $0.name }).joined(separator: ", ")
        } else {
            instrumentListLabel.text = data.instrumentList.map({ Instrument(rawValue: $0.name)?.inKorean ?? $0.name }).joined(separator: "")
        }
        print("++++ConfigureState++++")
        print(data.memberState)
        print(data.instrumentList)
        print("+++++++++++++++")

        userGenderAgeLabel.text = (Gender.CodingKeys(rawValue: data.gender)?.inKorean ?? "")  + (Age.CodingKeys(rawValue: data.age)?.inKorean ?? "")
        id = data.id
        
        // member 상태에 따라 우측 아이콘 변경
        switch data.memberState {
        case .admin:
            memberStateIcon.image = ImageLiteral.leaderIcon
            leaderButton.tintColor = .systemPurple
        case .none:
            memberStateIcon.image = ImageLiteral.memberIcon
        case .annonymous:
            memberStateIcon.image = ImageLiteral.unRegisteredMemberIcon
            userGenderAgeLabel.isHidden = true
            leaderButton.removeFromSuperview()
        case .inviting:
            leaderButton.removeFromSuperview()
            memberStateIcon.image = ImageLiteral.invitingIcon
        default: return
        }
    }
    
    func nameText() -> String {
        return userNameLabel.text ?? ""
    }
    
    func abandonLeaderPositionState() {
        self.leaderButton.tintColor = .gray01
        self.memberStateIcon.image = ImageLiteral.memberIcon
    }
    
    func getLeaderPositionState() {
        self.leaderButton.tintColor = .systemPurple
        self.memberStateIcon.image = ImageLiteral.leaderIcon
    }
    
    func setLeaderButtonAction(action: @escaping ()-> Void) {
        let action = UIAction { _ in action() }
        self.leaderButton.addAction(action, for: .touchUpInside)
    }
    
    func setSelectButtonAction(action: @escaping ()-> Void) {
        let action = UIAction { _ in action() }
        self.selectButton.addAction(action, for: .touchUpInside)
    }
    
    func activateMemberEditingState() {
        leaderButton.isHidden = true
        selectButton.isHidden = false
        self.layoutMargins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 10)
    }
    
    func deactiveMemberEditingState() {
        self.isSelectedState = false
        leaderButton.isHidden = false
        selectButton.isHidden = true
        self.layoutMargins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
}

