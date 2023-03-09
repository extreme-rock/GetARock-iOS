//
//  SNSButtonView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/31.
//

import UIKit

final class SNSButtonView: UIView {
    
    // MARK: - Property
    
    private var snsType: SNSType
    private let snsURI: String?
    
    enum SNSType: String {
        case youtube = "Youtube"
        case instagram = "Instagram"
        case soundCloud = "SoundCloud"
        
        var snsIconImage: UIImage {
            switch self {
            case .youtube: return ImageLiteral.youtubeIcon
            case .instagram: return ImageLiteral.instagramIcon
            case .soundCloud: return ImageLiteral.soundCloudIcon
            }
        }
        
        var snsDefaultURL: String {
            switch self {
            case .youtube: return "https://www.youtube.com/"
            case .instagram: return "https://www.instagram.com/"
            case .soundCloud: return "https://soundcloud.com/"
            }
        }
    }
    
    // MARK: - VIew
    
    private let containerView: UIView = {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray02.cgColor
        $0.backgroundColor = .dark02
        return $0
    }(UIView())
    
    private let snsIcon: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let linkIcon: UIImageView = {
        $0.image = ImageLiteral.arrowUpRightSymbol
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        return $0
    }(UIImageView())
    
    private let snsLabel: BasicLabel = {
        return $0
    }(BasicLabel(contentText: "", fontStyle: .content, textColorInfo: .white))
    
    // MARK: - Init
    
    init(type: SNSType, data: String?) {
        self.snsURI = data
        self.snsType = type
        super.init(frame: .zero)
        setupLayout()
        attribute()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func attribute() {
        snsLabel.text = snsType.rawValue
        snsIcon.image = snsType.snsIconImage
        if self.snsURI != nil { activateSNSButton() }
    }
    
    private func setupLayout() {
        self.constraint(.heightAnchor, constant: 75)
        self.addSubview(containerView)
        containerView.alpha = 0.4
        self.containerView.constraint(to: self)
        
        self.containerView.addSubview(snsIcon)
        self.snsIcon.constraint(top: containerView.topAnchor,
                                leading: containerView.leadingAnchor,
                                padding: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 0))
        
        self.containerView.addSubview(snsLabel)
        self.snsLabel.constraint(leading: containerView.leadingAnchor,
                                 bottom: containerView.bottomAnchor,
                                 padding: UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 0))
    }
    
    private func activateSNSButton() {
        self.containerView.alpha = 1.0
        self.containerView.addSubview(linkIcon)
        self.linkIcon.constraint(top:containerView.topAnchor,
                                 trailing: containerView.trailingAnchor,
                                 padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 15)
        )
        addSNSButtonAction()
    }
    
    private func addSNSButtonAction() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(moveSnsLink(_:))
        )
        self.containerView.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
    
    @objc
    func moveSnsLink(_ gesture: UITapGestureRecognizer) {
        guard let snsURI else { return }
        let snsURL = self.snsType.snsDefaultURL + snsURI
        NotificationCenter.default.post(
            name: Notification.Name.presentSNSSafariViewController,
            object: nil,
            userInfo: ["snsURL": snsURL])
    }
}

