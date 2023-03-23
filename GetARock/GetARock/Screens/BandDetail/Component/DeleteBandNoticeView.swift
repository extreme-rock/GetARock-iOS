//
//  DeleteBandNoticeView.swift
//  GetARock
//
//  Created by 최동권 on 2023/03/23.
//

import UIKit

final class DeleteBandNoticeView: UIView {
    private let titleLabel = BasicLabel(contentText: "밴드 해체 알림",
                                        fontStyle: .headline01,
                                        textColorInfo: .white)
    
    private let subTitleLabel = BasicLabel(contentText: "'블랙로즈'가 해체됨",
                                        fontStyle: .largeTitle02,
                                           textColorInfo: .white)
    
    private let contentLabel: BasicLabel = {
        $0.numberOfLines = 3
        $0.textAlignment = .center
        return $0
    }(BasicLabel(
        contentText: "헤어짐은 새로운 만남이 있는 법!\n새로운 밴드를 만들거나\n밴드 초대를 받고 밴드에 가입해보세요!",
        fontStyle: .headline04,
        textColorInfo: .white))
    
    
    
    private let okButton: BottomButton = {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .setFont(.headline02)
        return $0
    }(BottomButton())
    
    init() {
        super.init(frame: .zero)
        self.setupLayout()
        self.attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        self.layer.cornerRadius = 20
        self.backgroundColor = .dark03
    }
    
    private func setupLayout() {
        self.addSubview(titleLabel)
        titleLabel.constraint(top: self.topAnchor,
                              centerX: self.centerXAnchor,
                              padding: UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0))
        
        self.addSubview(subTitleLabel)
        subTitleLabel.constraint(top: self.titleLabel.bottomAnchor,
                                 centerX: self.centerXAnchor,
                                 padding: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0))
        
        self.addSubview(contentLabel)
        contentLabel.constraint(top: self.subTitleLabel.bottomAnchor,
                                centerX: self.centerXAnchor,
                                padding: UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0))
        
        self.addSubview(okButton)
        okButton.constraint(top: self.contentLabel.bottomAnchor,
                            leading: self.leadingAnchor,
                            bottom: self.bottomAnchor,
                            trailing:  self.trailingAnchor,
                            padding: UIEdgeInsets(top: 32, left: 18, bottom: 20, right: 18))
//        okButton.constraint(.heightAnchor, constant: 55)
    }
}
