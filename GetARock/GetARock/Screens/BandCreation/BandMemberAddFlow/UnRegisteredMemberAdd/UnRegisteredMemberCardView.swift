//
//  UnRegisteredMemberCardView.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/16.
//

import UIKit

//TODO: develop Pull 이후로 수정 사항 있음
final class UnRegisteredMemberCardView: UIStackView, Identifiable {

    let id: String = "defualt"

    lazy var cancelButton = {
        let button = UIButton()
        let removeAction = UIAction { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0.1
                self.superview?.layoutIfNeeded()
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
        button.addAction(removeAction, for: .touchUpInside)
        button.setImage(ImageLiteral.xmarkSymbol, for: .normal)
        button.tintColor = .white
        return button
    }()

    //TODO: develop Pull후에 Information Guide Label로 업데이트 필요
    private let nickNameGuideLabel = BasicLabel(contentText: "닉네임", fontStyle: .headline01, textColorInfo: .white)

    let nickNameTextField = TextLimitTextField(placeholer: "닉네임을 입력해주세요", maxCount: 10, duplicationCheckType: .none, textExpressionCheck: true)

    private lazy var nickNameVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [nickNameGuideLabel, nickNameTextField]))

    //TODO: develop Pull후에 Information Guide Label로 업데이트 필요
    private let mainPositionGuideLabel = BasicLabel(contentText: "포지션", fontStyle: .headline01, textColorInfo: .white)

    let positionSelectCollectionView: SelectCollectionView = {
        $0.constraint(.heightAnchor, constant: 110)
        return $0
    }(SelectCollectionView(widthState: .fixed, items: ["보컬", "기타", "베이스", "드럼", "키보드"], widthSize: 100, itemSpacing: 7))

    private lazy var positionSelectVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [mainPositionGuideLabel, positionSelectCollectionView]))

    private let otherPositionGuideLabel = BasicLabel(contentText: "그 외 포지션", fontStyle: .headline01, textColorInfo: .white)

    private let othrePositionSubGuideLabel = BasicLabel(contentText: "* 그 외 포지션은 공백 포함 10자 이하로 입력가능합니다.", fontStyle: .content, textColorInfo: .gray02)

    let otherPositionTextField = TextLimitTextField(placeholer: "그 외 포지션을 입력해주세요.", maxCount: 10, duplicationCheckType: .none, textExpressionCheck: true)

    private lazy var otherPositionVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [otherPositionGuideLabel, othrePositionSubGuideLabel, otherPositionTextField]))

    init() {
        super.init(frame: .zero)
        setupLayout()
        attribute()
    }

    private func setupLayout() {
        self.addArrangedSubview(nickNameVstack)
        self.addArrangedSubview(positionSelectVstack)
        self.addArrangedSubview(otherPositionVstack)
        self.axis = .vertical
        self.spacing = 40
        self.layoutMargins = UIEdgeInsets(top: 30, left: 16, bottom: 30, right: 16)
        self.isLayoutMarginsRelativeArrangement = true

        self.addSubview(cancelButton)
        cancelButton.constraint(top: self.topAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10))
    }

    private func attribute() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.white.cgColor
        self.backgroundColor = .dark02
        cancelButton.isHidden = true
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: 화면 터치시 키보드 숨김 기능
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
