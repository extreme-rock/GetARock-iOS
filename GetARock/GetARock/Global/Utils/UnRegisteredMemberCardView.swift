//
//  UnRegisteredMemberCardView.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/16.
//

import UIKit

final class UnRegisteredMemberCardView: UIStackView, Identifiable {

    let id: String = ""

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
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        return button
    }()

    private let bandMemberName = TwoHstackLabel.informationLabel(guideText: "닉네임", inputType: .required)

    let bandMemberNameTextField = BasicTextField(placeholder: "닉네임을 입력해주세요")

    private lazy var bandMemberNameVstack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bandMemberName, bandMemberNameTextField])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    private let positionLabel = TwoHstackLabel.informationLabel(guideText: "포지션", inputType: .required)

    private var positionSelect: SelectCollectionView = {
        $0.constraint(.heightAnchor, constant: 110)
        return $0
    }(SelectCollectionView(widthState: .fixed, items: ["보컬", "기타", "베이스", "드럼", "키보드"], widthSize: 100, itemSpacing: 7))

    private lazy var positionSelectVstack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [positionLabel, positionSelect])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    private let otherPosition = TwoHstackLabel.informationLabel(guideText: "그 외 포지션", inputType: .optional)

    private let positionDescription = BasicLabel(contentText: "* 그 외 포지션은 공백 포함 10자 이하로 입력가능합니다.", fontStyle: .content, textColorInfo: .gray02)

    let otherPositionTextField = BasicTextField(placeholder: "그 외 포지션을 입력해주세요.")

    private lazy var otherPositionVstack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [otherPosition, positionDescription, otherPositionTextField])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    init() {
        super.init(frame: .zero)
        setupLayout()
        attribute()
    }

    private func setupLayout() {
        self.addArrangedSubview(bandMemberNameVstack)
        self.addArrangedSubview(positionSelectVstack)
        self.addArrangedSubview(otherPositionVstack)
        self.axis = .vertical
        self.spacing = 40
        self.layoutMargins = UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 10)
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
}
