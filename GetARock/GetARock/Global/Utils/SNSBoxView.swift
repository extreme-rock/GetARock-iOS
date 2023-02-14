//
//  SNSBoxView.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/14.
//

import UIKit

final class SNSBoxView: UIView {
    
    enum SNSType: String {
        case youTube = "youtube.com/channel/"
        case instagram = "instagram.com/"
        case soundCloud = "soundcloud.com/"
    }

    private let type: SNSType

    private let textFieldPlaceholder: String

    private lazy var basicLabel = BasicLabel(contentText: type.rawValue, fontStyle: .content, textColorInfo: .white)

    lazy var textField: UITextField = {
        $0.attributedPlaceholder = NSAttributedString(
            string: textFieldPlaceholder,
            attributes: [
                .foregroundColor: UIColor.gray02,
                .font: UIFont.setFont(.headline04)])
        $0.backgroundColor = .dark02
        $0.textColor = .white
        $0.font = UIFont.setFont(.content)
        return $0
    }(UITextField(frame: .zero))

    private lazy var basicLeftView: UIImageView = {
        switch type {
        case .instagram: $0.image = ImageLiteral.instagramIcon
        case .soundCloud: $0.image = ImageLiteral.soundCloudIcon
        case .youTube: $0.image = ImageLiteral.youtubeIcon
        }
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())

    init(type: SNSType, placeholder: String) {
        self.type = type
        self.textFieldPlaceholder = placeholder
        super.init(frame: .zero)
        attribute()
        setupLayout()
    }
    
    private func attribute() {
        self.constraint(.widthAnchor, constant: BasicComponentSize.width)
        self.constraint(.heightAnchor, constant: 55)

        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.backgroundColor = .dark02
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    private func setupLayout() {
        addSubview(basicLeftView)
        if type == .soundCloud {
            basicLeftView.constraint(.widthAnchor, constant: 15)
            basicLeftView.constraint(.heightAnchor, constant: 15)
        } else {
            basicLeftView.constraint(.widthAnchor, constant: 15)
            basicLeftView.constraint(.heightAnchor, constant: 15)
        }
        basicLeftView.constraint(leading: self.leadingAnchor, centerY: self.centerYAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        )

        addSubview(basicLabel)
        basicLabel.constraint(
            leading: basicLeftView.trailingAnchor,
            centerY: basicLeftView.centerYAnchor,
            padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        )

        addSubview(textField)
        textField.constraint(
            leading: basicLabel.trailingAnchor,
            centerY: basicLabel.centerYAnchor,
            padding: UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
            )
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
