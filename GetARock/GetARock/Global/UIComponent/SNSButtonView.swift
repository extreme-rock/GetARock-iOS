//
//  SNSButtonView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/31.
//

import UIKit

class SNSButtonView: UIButton {
    
    // MARK: - Property
    
    enum SNSType{
        case youtube
        case instagram
        case soundCloud
    }
    
    var snsType: SNSType
    
    // MARK: - VIew
    
    private var snsLebel: BasicLabel = {
        return $0
    }(BasicLabel(contentText: "", fontStyle: .headline03, textColorInfo: .white))
    
    private var snsIcon: UIImageView = {
        $0.frame.size = CGSize(width: 100, height: 100)
        $0.backgroundColor = .purple
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let linkIcon: UIImageView = {
        $0.image = UIImage(
            systemName: "arrow.up.right",
            withConfiguration: SFIconSize.mediumIconSize
        )
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        return $0
    }(UIImageView())
    
    private let test = UIView()
    
    private lazy var iconStack: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 30
        return $0
    }(UIStackView(arrangedSubviews: [snsIcon, linkIcon]))
    
    private lazy var snsButtonStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .leading
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray02.cgColor
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
        return $0
    }(UIStackView(arrangedSubviews: [iconStack, snsLebel]))
    
    
    // MARK: - Init
    
    init(type: SNSType) {
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
           self.constraint(.widthAnchor, constant: 115)
           self.constraint(.heightAnchor, constant: 75)
       }

       private func setupLayout() {
           self.addSubview(snsButtonStack)
           self.snsButtonStack.constraint(to: self)
           setSNSConfigure()
           
//           self.snsButtonStack.addSubview(linkIcon)
//           self.linkIcon.constraint(top: snsButtonStack.topAnchor,
//                                    trailing: snsButtonStack.trailingAnchor,
//                                    padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
//
//           )
       }
    
    private func setSNSConfigure() {
        switch snsType {
        case .youtube:
            snsLebel.text = "Youtube"
            snsIcon.image = ImageLiteral.youtubeIcon
        case .instagram:
            snsLebel.text = "Instagram"
            snsIcon.image = ImageLiteral.instagramIcon
        case .soundCloud:
            snsLebel.text = "SoundCloud"
            snsIcon.image = ImageLiteral.soundCloudIcon
        }
    }
}


}
