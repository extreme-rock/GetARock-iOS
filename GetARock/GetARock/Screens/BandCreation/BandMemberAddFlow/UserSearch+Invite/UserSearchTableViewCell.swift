//
//  UserSearchTableViewCell.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/16.
//

import UIKit

final class UserSearchTableViewCell: UITableViewCell, Identifiable {

    var id: String = "default"

    var memberId: Int = 0

    var instrument: [SearchedUserInstrumentList] = []

    var memberState: MemberState = .none

    let userNameLabel: BasicLabel = BasicLabel(
        contentText: "",
        fontStyle: .headline01,
        textColorInfo: .white)

    private let userGenderLabel: BasicLabel = BasicLabel(
        contentText: "",
        fontStyle: .content,
        textColorInfo: .white.withAlphaComponent(0.5))

    private let horizontalSeperator: BasicLabel = BasicLabel(
        contentText: "|",
        fontStyle: .content,
        textColorInfo: .white.withAlphaComponent(0.5))

    private let userAgeLabel: BasicLabel = BasicLabel(
        contentText: "",
        fontStyle: .content,
        textColorInfo: .white.withAlphaComponent(0.5))

    private lazy var userDetailInfoHstack: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 2
        return $0
    }(UIStackView(arrangedSubviews: [userGenderLabel,
                                     horizontalSeperator,
                                     userAgeLabel]))

    let userInstrumentLabel: BasicLabel = BasicLabel(
        contentText: "",
        fontStyle: .content,
        textColorInfo: .white.withAlphaComponent(0.5))

    private lazy var selectButton: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        attribute()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: 셀이 select, deselect 될 때 마다 수행되는 함수
    override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)
        selectButton.image = selected ? ImageLiteral.checkmarkCircleFillSymbol : ImageLiteral.checkmarkCircleSymbol
        selectButton.tintColor = selected ? .systemPurple : .gray02
     }

    private func attribute() {
        self.backgroundColor = .dark01
    }

    private func setupLayout() {
        backgroundColor = .clear

        contentView.addSubview(userNameLabel)
        userNameLabel.constraint(top: contentView.safeAreaLayoutGuide.topAnchor,
                                 leading: contentView.safeAreaLayoutGuide.leadingAnchor,
                                 padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 0))

        contentView.addSubview(userDetailInfoHstack)
        userDetailInfoHstack.constraint(leading: userNameLabel.trailingAnchor,
                                        bottom: userNameLabel.bottomAnchor,
                                        padding: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0))

        contentView.addSubview(userInstrumentLabel)
        userInstrumentLabel.constraint(top: userNameLabel.bottomAnchor,
                                       leading: userNameLabel.leadingAnchor,
                                       padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 20))

        contentView.addSubview(selectButton)
        selectButton.constraint(.widthAnchor, constant: 25)
        selectButton.constraint(.heightAnchor, constant: 25)
        selectButton.constraint(trailing: contentView.trailingAnchor,
                                centerY: contentView.centerYAnchor,
                                padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        )

    }

    func configure(data: SearchedUserInfo) {
        self.userNameLabel.text = data.name
        self.userInstrumentLabel.text = data.instrumentList.map({ Instrument(rawValue: $0.name)?.inKorean ?? "" }).joined(separator: ", ")
        self.userAgeLabel.text = Age.CodingKeys(rawValue: data.age)?.inKorean
        self.userGenderLabel.text = Gender.CodingKeys(rawValue: data.gender)?.inKorean
        self.id = data.id
        self.memberId = data.memberId ?? -1
        self.instrument = data.instrumentList
    }
    
    func genderText() -> String {
        guard let text = userGenderLabel.text else { return "" }
        return text
    }
    
    func ageText() -> String {
        guard let text = userAgeLabel.text else { return "" }
        return text
    }
}

