//
//  NotificationTableViewCell.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/21.
//

import UIKit

final class NotificationTableViewCell: UITableViewCell {

    var isInvitation: Bool = false

    private let titleLabel = BasicLabel(contentText: "", fontStyle: .headline02, textColorInfo: .white)

    private let subtitleLabel = BasicLabel(contentText: "", fontStyle: .content, textColorInfo: .gray02)

    private let uploadTime = BasicLabel(contentText: "", fontStyle: .caption, textColorInfo: .gray02)

    let acceptButton: DefaultButton = {
        $0.setTitle("수락", for: .normal)
        $0.constraint(.heightAnchor, constant: 40)
        return $0
    }(DefaultButton())

    let rejectButton: DefaultButton = {
        $0.setTitle("거절", for: .normal)
        $0.constraint(.heightAnchor, constant: 40)
        return $0
    }(DefaultButton())

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
                                     uploadTime,]))
    
    private lazy var contentInformationVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [contentTextVstack, buttonHstack]))

    private let cellImage: UIImageView = {
        //TODO: 이미지 리터럴로 바꾸기
        $0.image = UIImage(systemName: "circle.fill")!
        $0.contentMode = .scaleAspectFit
        $0.constraint(.widthAnchor, constant: 40)
        $0.constraint(.widthAnchor, constant: 40)
        $0.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .vertical)
        return $0
    }(UIImageView(frame: .zero))
    
    
    private lazy var contentLayoutStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 15
        $0.alignment = .top
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.isLayoutMarginsRelativeArrangement = true
        return $0
    }(UIStackView(arrangedSubviews: [cellImage, contentInformationVstack]))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(contentLayoutStackView)
        contentLayoutStackView.constraint(to: self.contentView)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: NotificationInfo) {
        //TODO: 추후 titleLabel은 data.title로 바꾸기. 테스트 API를 사용하기 때문에 둘다 content를 사용함
        self.titleLabel.text = data.content
        self.subtitleLabel.text = data.content
        self.uploadTime.text = data.updatedDate
        self.isInvitation = data.isInvitation
        if isInvitation == false {
            buttonHstack.isHidden = true
        }
        
        if data.bandID > 0 {
            self.cellImage.image = ImageLiteral.bandIcon
        }
        if data.eventID > 0 {
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
// CI/CD Test Code

