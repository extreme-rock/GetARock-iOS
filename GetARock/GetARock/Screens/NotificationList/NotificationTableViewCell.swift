//
//  NotificationTableViewCell.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/21.
//

import UIKit

final class NotificationTableViewCell: UITableViewCell {

    var isInvitation: Bool = false

    private let titleLabel = BasicLabel(contentText: "ㅎㅎㅎㅎㅎㅎ", fontStyle: .largeTitle02, textColorInfo: .white)

    private let subtitleLabel = BasicLabel(contentText: "ㅎㅎㅎㅎㅎㅎ", fontStyle: .subTitle, textColorInfo: .gray02)

    private let uploadTime = BasicLabel(contentText: "ㅎㅎㅎㅎㅎㅎ", fontStyle: .caption, textColorInfo: .gray02)

    private let acceptButton: DefaultButton = {
        $0.setTitle("수락", for: .normal)
        $0.constraint(.heightAnchor, constant: 50)
        return $0
    }(DefaultButton())

    private let rejectButton: DefaultButton = {
        $0.setTitle("거절", for: .normal)
        $0.constraint(.heightAnchor, constant: 50)
        return $0
    }(DefaultButton())

    private lazy var buttonHstack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [acceptButton, rejectButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, uploadTime, buttonHstack])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 3
        return stackView
    }()

    private let cellImage: UIImageView = {
        $0.image = UIImage(systemName: "circle.fill")!
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView(frame: .zero))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(cellImage)
        cellImage.constraint(.widthAnchor, constant: 40)
        cellImage.constraint(.heightAnchor, constant: 40)
        cellImage.constraint(top: contentView.topAnchor, leading: contentView.leadingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 0))

        contentView.addSubview(contentStackView)
        contentStackView.constraint(top: cellImage.topAnchor, leading: cellImage.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(titleLable: String, subtitleLabel: String, uploadTime:String, isInvitation: Bool) {
        self.titleLabel.text = titleLable
        self.subtitleLabel.text = subtitleLabel
        self.uploadTime.text = uploadTime
        self.isInvitation = isInvitation
        if isInvitation == false {
            buttonHstack.isHidden = true
        }
    }
}
// CI/CD Test Code

