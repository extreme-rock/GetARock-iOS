//
//  SNSButtonView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/31.
//

import UIKit

final class SNSButtonView: UIView {
    
    // MARK: - Property
    
    enum SNSType{
        case youtube
        case instagram
        case soundCloud
    }
    
    private var snsType: SNSType
    
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
    
    private let snsLebel: BasicLabel = {
        return $0
    }(BasicLabel(contentText: "", fontStyle: .content, textColorInfo: .white))
    
    // MARK: - Init
    
    init(type: SNSType) {
        self.snsType = type
        super.init(frame: .zero)
        attribute()
        setupLayout()
        setSNSConfigure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func attribute() {
        self.constraint(.heightAnchor, constant: 75)
    }
    
    private func setupLayout() {
        self.addSubview(containerView)
        containerView.alpha = 0.4
        self.containerView.constraint(to: self)
        
        self.containerView.addSubview(snsIcon)
        self.snsIcon.constraint(top: containerView.topAnchor,
                                leading: containerView.leadingAnchor,
                                padding: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 0))
        
        self.containerView.addSubview(snsLebel)
        self.snsLebel.constraint(leading: containerView.leadingAnchor,
                                 bottom: containerView.bottomAnchor,
                                 padding: UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 0))
    }
    
    private func setSNSConfigure() {
        
        let snsData = BandDummyData.testBands.first?.sns
        
        switch snsType {
        case .youtube:
            snsLebel.text = "Youtube"
            snsIcon.image = ImageLiteral.youtubeIcon
            if snsData?.youtube != nil { ActiveSnsButton() }
        case .instagram:
            snsLebel.text = "Instagram"
            snsIcon.image = ImageLiteral.instagramIcon
            if snsData?.instagram != nil { ActiveSnsButton() }
        case .soundCloud:
            snsLebel.text = "SoundCloud"
            snsIcon.image = ImageLiteral.soundCloudIcon
            if snsData?.soundCloud != nil { ActiveSnsButton() }
        }
    }
    
    private func ActiveSnsButton() {
        self.containerView.alpha = 1.0
        self.containerView.addSubview(linkIcon)
        self.linkIcon.constraint(top:containerView.topAnchor,
                                 trailing: containerView.trailingAnchor,
                                 padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 15)
        )
        addSnsButtonAction()
    }
    
    private func addSnsButtonAction() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(moveSnsLink(_:))
        )
        self.containerView.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
    
    @objc
    func moveSnsLink(_ gesture: UITapGestureRecognizer) {
        //TO-DO: 링크로 연결 액션 필요
        print("버튼 눌림")
    }
    
}

