//
//  BandMemberModifyViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/19.
//

import UIKit

final class BandMemberModifyViewController: UIViewController {
    
    //MARK: - View
    
    let inviteMemberButton: DefaultButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = ImageLiteral.magnifyingGlassSymbol
        configuration.title = "멤버 초대"
        configuration.attributedTitle?.font = UIFont.setFont(.contentBold)
        configuration.imagePadding = 5
        let button = DefaultButton(configuration: configuration)
        button.tintColor = .white
        button.constraint(.heightAnchor, constant: 55)
        return button
    }()

    let inviteUnRegisteredMemberButton: DefaultButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = ImageLiteral.plusSymbol
        configuration.title = "미가입 회원 추가"
        configuration.attributedTitle?.font = UIFont.setFont(.contentBold)
        configuration.imagePadding = 5
        let button = DefaultButton(configuration: configuration)
        button.tintColor = .white
        button.constraint(.heightAnchor, constant: 55)
        return button
    }()
    
    let editButton: UIButton = {
        $0.setTitle("편집", for: .normal)
        $0.setTitleColor(.blue01, for: .normal)
        $0.titleLabel?.font = UIFont.setFont(.headline04)
        return $0
    }(UIButton())
    
    private let sectionTitle: BasicLabel = BasicLabel(contentText: "밴드 멤버 1인",
                                                      fontStyle: .contentBold,
                                                      textColorInfo: .white)

    private lazy var sectionTitleHstack: UIStackView = {
        $0.axis = .horizontal
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 28)
        return $0
    }(UIStackView(arrangedSubviews: [sectionTitle,
                                     editButton]))

    private lazy var buttonHstack: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        return $0
    }(UIStackView(arrangedSubviews: [inviteMemberButton,
                                     inviteUnRegisteredMemberButton]))
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: 추후에 API를 통해 데이터 업데이트 과정이 필요함
    }
    
    private func attribute() {
        
    }
    
    private func setupLayout() {
        
    }
}
