//
//  BandMemberModifyTableViewHeader.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/01.
//

import UIKit

final class BandMemberModifyTableViewHeader: UITableViewHeaderFooterView {

    lazy var isEditing: Bool = false {
        didSet {
            if isEditing == true {
                let action = UIAction { [weak self]_ in
                    self?.finishEditingAction()
                    self?.editButton.setTitle("편집", for: .normal)
                    self?.isEditing = false
                }
                editButton.addAction(action, for: .touchUpInside)
            } else {
                let action = UIAction { [weak self]_ in self?.startEditingAction()
                    self?.editButton.setTitle("완료", for: .normal)
                    self?.isEditing = true
                }
                editButton.addAction(action, for: .touchUpInside)
            }
        }
    }

    //MARK: - Property

    var startEditingAction: () -> Void = { }

    var finishEditingAction: () -> Void = { }
    
    //MARK: - View

    private let titleLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "밴드 멤버를\n모두 알려주세요",
                 fontStyle: .largeTitle01,
                 textColorInfo: .white))

    private let subTitleLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "다른 밴드가 우리 밴드 멤버를 볼 수 있도록\n모든 멤버를 초대 및 등록해주세요",
                 fontStyle: .headline03,
                 textColorInfo: .gray02))

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

    private let sectionTitle: BasicLabel = BasicLabel(contentText: "밴드 멤버 1인",
                                                      fontStyle: .contentBold,
                                                      textColorInfo: .white)

    let editButton: UIButton = {
        $0.setTitle("편집", for: .normal)
        $0.setTitleColor(.blue01, for: .normal)
        $0.titleLabel?.font = UIFont.setFont(.headline04)
        return $0
    }(UIButton())

    private lazy var sectionTitleHstack: UIStackView = {
        $0.axis = .horizontal
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        return $0
    }(UIStackView(arrangedSubviews: [sectionTitle,
                                     editButton]))

    private lazy var buttonHstack: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [inviteMemberButton,
                                     inviteUnRegisteredMemberButton]))

    private lazy var titleVstack: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 20
        return $0
    }(UIStackView(arrangedSubviews: [titleLabel,
                                     subTitleLabel,
                                     buttonHstack,
                                     sectionTitleHstack]))
    
    //MARK: init

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        attribute()
        setupLayout()
    }
    
    //MARK: Method

    private func setupLayout() {
        contentView.addSubview(titleVstack)
        titleVstack.constraint(to: contentView)
    }

    private func attribute() {
        contentView.backgroundColor = .dark01
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureSectionTitle(with text: String) {
        self.sectionTitle.text = text
    }

    func setInviteMemberButtonAction(action: @escaping ()-> Void ) {
        let action = UIAction { _ in action() }
        self.inviteMemberButton.addAction(action, for: .touchUpInside)
    }
}
