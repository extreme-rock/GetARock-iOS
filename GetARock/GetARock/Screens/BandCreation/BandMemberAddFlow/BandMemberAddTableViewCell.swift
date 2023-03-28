//
//  BandMemberAddTableViewCell.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/16.
//

import UIKit

final class BandMemberAddTableViewCell: UITableViewCell, Identifiable {

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

    lazy var deleteButton: UIButton = {
        $0.setImage(UIImage(
            systemName: "xmark.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)),for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray02
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

        contentView.addSubview(deleteButton)
        deleteButton.constraint(.widthAnchor, constant: 25)
        deleteButton.constraint(.heightAnchor, constant: 25)
        deleteButton.constraint(trailing: contentView.trailingAnchor,
                                centerY: contentView.centerYAnchor,
                                padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 20))

        contentView.addSubview(userDetailInfoHstack)
        userDetailInfoHstack.constraint(leading: userNameLabel.trailingAnchor,
                                        bottom: userNameLabel.bottomAnchor,
                                        padding: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0))

        
    }

    func configure(data: SearchedUserInfo) {
        if data.name.count > 10 {
            userNameLabel.numberOfLines = 1
            userNameLabel.adjustsFontSizeToFitWidth = true
            userNameLabel.minimumScaleFactor = 0.9
            userNameLabel.lineBreakMode = .byTruncatingTail
            userNameLabel.constraint(.widthAnchor, constant: 160)
        }

        //Cell 왼쪽 아이콘 케이스 분류
        switch data.memberState {
        case .admin: leftView.image = ImageLiteral.leaderIcon
        case .none: leftView.image = ImageLiteral.memberIcon
        case .annonymous:
            leftView.image = ImageLiteral.unRegisteredMemberIcon
            userDetailInfoHstack.isHidden = true
        default: return
        }

        // Cell 데이터 주입
        self.userNameLabel.text = data.name
        self.userAgeLabel.text = data.age
        self.userGenderLabel.text = data.gender
        self.instrumentListLabel.text = data.instrumentList.map({ $0.name }).joined(separator: ", ")
        self.id = data.id
    }
}
