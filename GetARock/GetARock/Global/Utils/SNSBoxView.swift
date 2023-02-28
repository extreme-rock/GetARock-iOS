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
        
        var snsType: SnsType {
            switch self {
            case .youTube:
                return .youtube
            case .instagram:
                return .instagram
            case .soundCloud:
                return .soundcloud
            }
        }
    }

    private let type: SNSType

    private let textFieldPlaceholder: String

    private lazy var basicLabel: BasicLabel = BasicLabel(contentText: type.rawValue, fontStyle: .content, textColorInfo: .white)

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
        $0.contentMode = .scaleAspectFit
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
        switch type {
        case .soundCloud:
            basicLeftView.constraint(.widthAnchor, constant: 23)
            basicLeftView.constraint(.heightAnchor, constant: 25)
            basicLeftView.constraint(
                leading: self.leadingAnchor,
                centerY: self.centerYAnchor,
                padding: UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 0))
        default:
            basicLeftView.constraint(.widthAnchor, constant: 20)
            basicLeftView.constraint(.heightAnchor, constant: 20)
            basicLeftView.constraint(
                leading: self.leadingAnchor,
                centerY: self.centerYAnchor,
                padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        }

        addSubview(basicLabel)
        basicLabel.constraint(
            leading: basicLeftView.trailingAnchor,
            centerY: basicLeftView.centerYAnchor,
            padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        )

        addSubview(textField)
        switch type {
        case .soundCloud:
            textField.constraint(
                leading: basicLabel.trailingAnchor,
                centerY: basicLabel.centerYAnchor,
                padding: UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0))

        default:
            textField.constraint(
                leading: basicLabel.trailingAnchor,
                centerY: basicLabel.centerYAnchor,
                padding: UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0))
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func inputText() -> SnsList {
        if let text = self.textField.text {
            let link = self.type.rawValue + text
            let snsList = SnsList(type: type.snsType, link: link)
            return snsList
        } else {
            return SnsList(type: self.type.snsType, link: nil)
        }
    }
    
    func writeText(with text: String?) {
        guard let text else { return }
        self.textField.text = text
    }
}
