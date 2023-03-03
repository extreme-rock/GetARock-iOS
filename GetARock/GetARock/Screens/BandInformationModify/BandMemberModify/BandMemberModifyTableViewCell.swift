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

    private let userNameLabel: BasicLabel = BasicLabel(
        contentText: "",
        fontStyle: .headline01,
        textColorInfo: .white)

    private let instrumentListLabel: BasicLabel = BasicLabel(
        contentText: "",
        fontStyle: .content,
        textColorInfo: .gray02)
    
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

    private lazy var leftView: UIImageView = {
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
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        attribute()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func attribute() {
        self.backgroundColor = .dark01
    }

    private func setupLayout() {

        contentView.addSubview(leftView)
        leftView.constraint(.widthAnchor, constant: 35)
        leftView.constraint(.heightAnchor, constant: 35)
        leftView.constraint(leading: contentView.leadingAnchor,
                            centerY: contentView.centerYAnchor,
                            padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))

        contentView.addSubview(userNameLabel)
        userNameLabel.constraint(top: leftView.topAnchor,
                                 leading: leftView.trailingAnchor,
                                 padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))

        contentView.addSubview(instrumentListLabel)
        instrumentListLabel.constraint(top: userNameLabel.bottomAnchor,
                                       leading: userNameLabel.leadingAnchor,
                                       padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 20))

        contentView.addSubview(leaderButton)
        leaderButton.constraint(.widthAnchor, constant: 25)
        leaderButton.constraint(.heightAnchor, constant: 25)
        leaderButton.constraint(trailing: contentView.trailingAnchor,
                                centerY: contentView.centerYAnchor,
                                padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10))

        contentView.addSubview(userDetailInfoHstack)
        userDetailInfoHstack.constraint(leading: userNameLabel.trailingAnchor,
                                        bottom: userNameLabel.bottomAnchor,
                                        padding: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0))

        
    }

    func configure(data: SearchedUserInfo) {
        self.userNameLabel.text = data.name
        self.instrumentListLabel.text = data.instrumentList.first?.name ?? ""
        self.id = data.id

        switch data.memberState {
        case .admin:
            leftView.image = ImageLiteral.leaderIcon
            leaderButton.tintColor = .systemPurple
        case .none:
            leftView.image = ImageLiteral.memberIcon
        case .annonymous:
            leftView.image = ImageLiteral.unRegisteredMemberIcon
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
    }
    
    func getLeaderPositionState() {
        self.leaderButton.tintColor = .systemPurple
    }

    func setLeaderButtonAction(action: @escaping ()->Void) {
        let action = UIAction { _ in action() }
        self.leaderButton.addAction(action, for: .touchUpInside)
    }
}
