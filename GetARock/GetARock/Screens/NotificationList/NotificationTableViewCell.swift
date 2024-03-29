//
//  NotificationTableViewCell.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/21.
//

import UIKit

final class NotificationTableViewCell: UITableViewCell {

    //MARK: Property

    private var isInvitation: Bool = false

    var notificationInfo: NotificationInfo = NotificationInfo(alertID: 0,
                                                                      isInvitation: false,
                                                                      alertType: "",
                                                                      title: "",
                                                                      content: "",
                                                                      isChecked: false,
                                                                      updatedDate: "",
                                                                      bandID: 0,
                                                                      eventID: 0)

    //MARK: View

    private let titleLabel: BasicLabel = BasicLabel(contentText: "", fontStyle: .headline02, textColorInfo: .white)

    private let subtitleLabel: BasicLabel = {
        $0.numberOfLines = 3
        return $0
    }(BasicLabel(contentText: "", fontStyle: .content, textColorInfo: .gray02))

    private let uploadTime: BasicLabel = BasicLabel(contentText: "", fontStyle: .caption, textColorInfo: .gray02)

    let acceptButton: DefaultButton = {
        $0.setTitle("수락", for: .normal)
        $0.constraint(.heightAnchor, constant: 40)
        return $0
    }(DefaultButton())

    let rejectButton: UIButton = {
        $0.setTitle("거절", for: .normal)
        $0.titleLabel?.font = UIFont.setFont(.contentBold)
        $0.backgroundColor = .dark02
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray02.cgColor
        $0.constraint(.heightAnchor, constant: 40)
        return $0
    }(UIButton())

    lazy var buttonHstack: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [acceptButton, rejectButton]))

    private lazy var contentTextVstack: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 7
        return $0
    }(UIStackView(arrangedSubviews: [titleLabel,
                                     subtitleLabel,
                                     uploadTime]))
    
    private lazy var contentInformationVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [contentTextVstack]))

    private let cellImage: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.constraint(.widthAnchor, constant: 40)
        $0.constraint(.heightAnchor, constant: 40)
        return $0
    }(UIImageView(frame: .zero))
    
    private lazy var contentLayoutStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 15
        $0.alignment = .top
        $0.layoutMargins = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 16)
        $0.isLayoutMarginsRelativeArrangement = true
        return $0
    }(UIStackView(arrangedSubviews: [cellImage, contentInformationVstack]))

    //MARK: init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(contentLayoutStackView)
        contentLayoutStackView.constraint(to: self.contentView)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Extension

extension NotificationTableViewCell {
    func configure(with data: NotificationInfo) {
        self.titleLabel.text = data.title
        self.subtitleLabel.text = data.content
        self.uploadTime.text = data.updatedDate.toDateWithDateComponents().abbreviatedRelativeKRTime
        self.notificationInfo = data
        self.isInvitation = data.isInvitation ?? true
        if isInvitation {
            contentInformationVstack.addArrangedSubview(buttonHstack)
        }

        //TODO: 추후 밴드 알람인지 모여락 알람인지 어떻게 구분할지 논의 필요
        if data.bandID! > 0 {
            self.cellImage.image = ImageLiteral.bandIcon
        }
        if data.eventID ?? 0 > 0 {
            self.cellImage.image = ImageLiteral.eventIcon
        }
    }
    
    func updateTextAfterRejectInvitation(bandName: String) {
        self.subtitleLabel.text = "\(bandName)로부터 초대를 거절 했습니다."
    }
    
    func updateTextForInvitationRejectAlert(userName: String, bandName: String) {
        self.subtitleLabel.text = "\(userName)이 \(bandName) 가입 요청을 거절 했습니다."
    }
}
