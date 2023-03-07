//
//  MypageTopInfoView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/03/07.
//

import UIKit

final class MypageTopInfoView: UIView {
    
    // MARK: - Property
    
    private var userName = ""
    private var userGender = ""
    private var userAge = ""
    
    // MARK: - View
    
    private lazy var userNameLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(
        contentText: userName,
        fontStyle: .headline04,
        textColorInfo: .white)
    )
    
    //TODO: 추후 밴드 데이터를 이용해 이름을 각 라벨 업데이트 필요
    private lazy var userInfoLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(
        contentText: "\(userGender) ⏐ \(userAge)",
        fontStyle: .content,
        textColorInfo: .white)
    )
    
    private lazy var infoStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [userNameLabel,userInfoLabel]))
    
    private let divider: UIView = {
        $0.backgroundColor = .dark02
        return $0
    }(UIView())
    
    // MARK: - Init
    
    init(userName: String, userGender: String, userAge: String) {
        self.userName = userName
        self.userGender = userGender
        self.userAge = userAge
        super.init(frame: .zero)
        setupLayout()
        attribute()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.backgroundColor = .dark01
    }
    
    private func setupLayout() {
        self.addSubview(infoStackView)
        infoStackView.constraint(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            trailing: self.trailingAnchor,
            padding: UIEdgeInsets(top: 30, left: 16, bottom: 0, right: 16)
        )
        
        self.addSubview(divider)
        divider.constraint(
            top: infoStackView.bottomAnchor,
            leading: self.leadingAnchor,
            bottom: self.bottomAnchor ,
            trailing: self.trailingAnchor,
            padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        )
        self.divider.constraint(.heightAnchor, constant: DividerSize.height)
    }
}
