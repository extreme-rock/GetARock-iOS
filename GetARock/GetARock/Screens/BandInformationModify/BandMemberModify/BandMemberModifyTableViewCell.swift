//
//  BandMemberModifyTableViewCell.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/01.
//

import Foundation
import UIKit

final class BandMemberModifyTableViewCell: UITableViewCell, Identifiable {

    var id: String = "default"
    
    var isSelectedState: Bool = false {
        didSet {
            selectButton.image = isSelectedState ? ImageLiteral.checkmarkCircleFillSymbol : ImageLiteral.checkmarkCircleSymbol
            selectButton.tintColor = isSelectedState ? .systemPurple : .gray02
        }
    }

    private let userNameLabel: BasicLabel = BasicLabel(
        contentText: "",
        fontStyle: .headline01,
        textColorInfo: .white)
    
    private let userGenderLabel: BasicLabel = BasicLabel(
        contentText: "",
        fontStyle: .content,
        textColorInfo: .gray02)

    private let horizontalSeperator: BasicLabel = BasicLabel(
        contentText: "|",
        fontStyle: .content,
        textColorInfo: .gray02)

    private let userAgeLabel: BasicLabel = BasicLabel(
        contentText: "",
        fontStyle: .content,
        textColorInfo: .gray02)

    private lazy var userDetailInfoHstack: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 2
        return $0
    }(UIStackView(arrangedSubviews: [userGenderLabel,
                                     horizontalSeperator,
                                     userAgeLabel]))

    private let instrumentListLabel: BasicLabel = BasicLabel(
        contentText: "",
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
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())

    lazy var leaderButton: UIButton = {
        //MARK: ImageLiteral로 바꾸기
        $0.setImage(UIImage(systemName: "crown"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray01
        return $0
    }(UIButton(type: .custom))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupLayout()
        attribute()
    }

    lazy var selectButton: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.image = ImageLiteral.checkmarkCircleSymbol
        $0.tintColor = .gray02
        return $0
    }(UIImageView())

    private lazy var contentStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 10)
        return $0
    }(UIStackView(arrangedSubviews: [memberStateIcon, userInfoVStack, leaderButton, selectButton]))

    //tableview의 edit 상태에 따라 모든 셀은 edit 프로퍼티가 달라짐
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            activateMemberEditingState()
        } else {
            deActiveMemberEditingState()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.isSelectedState = false
        self.memberStateIcon.image = nil
        self.userNameLabel.text = nil
        self.userGenderLabel.text = nil
        self.userAgeLabel.text = nil
        self.instrumentListLabel.text = nil
    }

    private func attribute() {
        self.backgroundColor = .dark01
        self.indentationWidth = 0
        selectButton.isHidden = true
    }

    private func setupLayout() {
        contentView.addSubview(contentStackView)
        contentStackView.constraint(to: contentView)

        leaderButton.constraint(.widthAnchor, constant: 40)
        leaderButton.constraint(.heightAnchor, constant: 40)

        memberStateIcon.constraint(.widthAnchor, constant: 40)
        memberStateIcon.constraint(.heightAnchor, constant: 40)
    }

    func configure(data: SearchedUserInfo) {
        self.userNameLabel.text = data.name
        self.instrumentListLabel.text = data.instrumentList.first?.name ?? ""
        self.id = data.id

        switch data.memberState {
        case .admin:
            memberStateIcon.image = ImageLiteral.leaderIcon
            leaderButton.tintColor = .systemPurple
        case .none:
            memberStateIcon.image = ImageLiteral.memberIcon
        case .annonymous:
            memberStateIcon.image = ImageLiteral.unRegisteredMemberIcon
            leaderButton.removeFromSuperview()
        case .inviting:
            leaderButton.removeFromSuperview()
        default: return
        }
        
        self.userNameLabel.text = data.name
        self.userAgeLabel.text = data.age
        self.userGenderLabel.text = data.gender

        switch data.memberState {
        case .annonymous: userDetailInfoHstack.isHidden = true
        default:
            self.instrumentListLabel.text = data.instrumentList.map({ $0.name }).joined(separator: ", ")
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

    func activateMemberEditingState() {
        leaderButton.isHidden = true
        selectButton.isHidden = false
    }

    func deActiveMemberEditingState() {
        self.isSelectedState = false
        leaderButton.isHidden = false
        selectButton.isHidden = true
    }
}
