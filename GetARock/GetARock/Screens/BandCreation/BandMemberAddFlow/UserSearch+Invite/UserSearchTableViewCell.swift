//
//  UserSearchTableViewCell.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/16.
//

import UIKit

final class UserSearchTableViewCell: UITableViewCell, Identifiable {

    var id: String = "default"

    var isChecked: Bool = false {
          didSet {
              selectButton.image = isChecked ? ImageLiteral.checkmarkCircleSymbol : ImageLiteral.circkeSymbol
              selectButton.tintColor = isChecked ? .systemPurple : .gray02
          }
      }

    let userNameLabel: BasicLabel = BasicLabel(contentText: "", fontStyle: .headline01, textColorInfo: .white)

    private let userGenderLabel: BasicLabel = BasicLabel(contentText: "남", fontStyle: .content, textColorInfo: .white.withAlphaComponent(0.5))

    private let horizontalSeperator: BasicLabel = BasicLabel(contentText: "|", fontStyle: .content, textColorInfo: .white.withAlphaComponent(0.5))

    private let userAgeLabel: BasicLabel = BasicLabel(contentText: "20대", fontStyle: .content, textColorInfo: .white.withAlphaComponent(0.5))

    private lazy var userDetailInfoHstack: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 2
        return $0
    }(UIStackView(arrangedSubviews: [userGenderLabel, horizontalSeperator, userAgeLabel]))

    let userInstrumentLabel: BasicLabel = BasicLabel(contentText: "", fontStyle: .content, textColorInfo: .white.withAlphaComponent(0.5))

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

    override func prepareForReuse() {
        self.userNameLabel.text = nil
        self.userInstrumentLabel.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //MARK: 셀이 select, deselect 될 때 마다 수행되는 함수
         super.setSelected(selected, animated: animated)
         isChecked.toggle()
     }

    private func attribute() {
        self.backgroundColor = .dark01
    }

    private func setupLayout() {
        backgroundColor = .clear

        contentView.addSubview(userNameLabel)
        userNameLabel.constraint(top: contentView.safeAreaLayoutGuide.topAnchor, leading: contentView.safeAreaLayoutGuide.leadingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 0))

        contentView.addSubview(userDetailInfoHstack)
        userDetailInfoHstack.constraint(leading: userNameLabel.trailingAnchor, bottom: userNameLabel.bottomAnchor, padding: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0))

        contentView.addSubview(userInstrumentLabel)
        userInstrumentLabel.constraint(top: userNameLabel.bottomAnchor, leading: userNameLabel.leadingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 20))

        contentView.addSubview(selectButton)
        selectButton.constraint(.widthAnchor, constant: 25)
        selectButton.constraint(.heightAnchor, constant: 25)
        selectButton.constraint(trailing: contentView.trailingAnchor, centerY: contentView.centerYAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        )

    }

    func configure(data: SearchedUserInfo) {
        self.userNameLabel.text = data.name
        //TODO: 리스트 형태로 받을 수 있도록 바꿔야하
        self.userInstrumentLabel.text = data.instrumentList.first!.name
        self.id = data.id
    }
}

