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
              selectButton.image = UIImage(systemName: isChecked ? "checkmark.circle" : "circle")
              selectButton.tintColor = isChecked ? .systemPurple : .gray02
          }
      }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.setFont(.headline01)
        label.textColor = .white

        return label
    }()

    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.setFont(.content)
        label.textColor = .white.withAlphaComponent(0.5)

        return label
    }()

    lazy var leftView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "music.note.list")
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    lazy var selectButton: UIImageView = {
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
        self.titleLabel.text = nil
        self.subTitleLabel.text = nil
    }

    private func attribute() {
        self.backgroundColor = .dark01
    }

    private func setupLayout() {
        backgroundColor = .clear

        contentView.addSubview(leftView)
        leftView.constraint(.widthAnchor, constant: 35)
        leftView.constraint(.heightAnchor, constant: 35)
        leftView.constraint(leading: contentView.leadingAnchor, centerY: contentView.centerYAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        )

        contentView.addSubview(titleLabel)
        titleLabel.constraint(top: leftView.topAnchor, leading: leftView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))

        contentView.addSubview(subTitleLabel)
        subTitleLabel.constraint(top: titleLabel.bottomAnchor, leading: titleLabel.leadingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 20))

        contentView.addSubview(selectButton)
        selectButton.constraint(.widthAnchor, constant: 25)
        selectButton.constraint(.heightAnchor, constant: 25)
        selectButton.constraint(trailing: contentView.trailingAnchor, centerY: contentView.centerYAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        )

    }

    func configure(data: MemberList) {
        self.titleLabel.text = data.name
        //TODO: 리스트 형태로 받을 수 있도록 바꿔야하
        self.subTitleLabel.text = data.instrumentList.first!.name
        self.id = data.id
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //MARK: 셀이 select, deselect 될 때 마다 수행되는 함수
         super.setSelected(selected, animated: animated)
         isChecked.toggle()
     }
}

