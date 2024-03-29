//
//  MypageTopInfoView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/03/07.
//

import UIKit

protocol MypageTopInfoViewDelegate: AnyObject {
    func presentModifyMyPageViewController()
}

final class MypageTopInfoView: UIView {
    
    // MARK: - Property

    weak var delegate: MypageTopInfoViewDelegate?
    private var userName = ""
    private var userGender = ""
    private var userAge = ""
    
    // MARK: - View
    
    private lazy var userNameLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(
        contentText: userName,
        fontStyle: .nameTitle,
        textColorInfo: .white)
    )
    
    //TODO: - 추후 본인의 계정에만 노출 되어야함
    private lazy var modifyButton: UIButton = {
        let action = UIAction { [weak self] _ in
            self?.delegate?.presentModifyMyPageViewController()
        }
        $0.setTitle("수정", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.setTitleColor(.blue02, for: .normal)
        $0.addAction(action, for: .touchUpInside)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 760),
                                                   for: .horizontal)
        return $0
    }(UIButton())
    
    private lazy var userNameStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .top
        return $0
    }(UIStackView(arrangedSubviews: [userNameLabel, modifyButton]))
    
    private lazy var userInfoLabel = BasicLabel(
        contentText: "",
        fontStyle: .content,
        textColorInfo: .white)
    
    private lazy var infoStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [userNameStackView,userInfoLabel]))
    
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
        setUserInfoLabel()
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
    
    private func setUserInfoLabel() {
        guard let age = Age.CodingKeys(rawValue: userAge)?.inKorean,
              let gender = Gender.CodingKeys(rawValue: userGender)?.inKorean else { return }
        
        userInfoLabel.text = "\(gender) ⏐ \(age)"
    }

    func configureModifiedUserInfo(name: String, age: String, gender: String) {
        guard let age = Age.CodingKeys(rawValue: age)?.inKorean,
              let gender = Gender.CodingKeys(rawValue: gender)?.inKorean else { return }
        self.userNameLabel.text = name
        userInfoLabel.text = "\(gender) ⏐ \(age)"
    }
}
