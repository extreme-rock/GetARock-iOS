//
//  PracticeSongCardView.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/26.
//

import UIKit

final class PracticeSongCardView: UIStackView {

    lazy var deleteButton: UIButton = {
        let deleteAction: UIAction = UIAction { _ in
            self.removeFromSuperview()
        }
        $0.setImage(ImageLiteral.xmarkSymbol, for: .normal)
        $0.tintColor = .white
        $0.addAction(deleteAction, for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let practiceSongName: InformationGuideLabel = InformationGuideLabel(guideText: "합주곡 제목", type: .required)
    
    private let practiceSongTextField: BasicTextField = BasicTextField(placeholder: "합주곡 제목을 입력해주세요")
    
    private lazy var practiceSongNameVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [practiceSongName, practiceSongTextField]))
    
    private let artistName: InformationGuideLabel = InformationGuideLabel(guideText: "아티스트", type: .required)
    
    private let artistNameTextField: BasicTextField = BasicTextField(placeholder: "아티스트를 입력해주세요")
    
    private lazy var artistNameVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [artistName, artistNameTextField]))
    
    private let linkLabel: InformationGuideLabel = InformationGuideLabel(guideText: "링크", type: .optional)
    
    private let linkDescription: BasicLabel = BasicLabel(
        contentText: "* 우리밴드가 해당 곡을 합주한 작업물 링크를 입력해주세요",
        fontStyle: .content,
        textColorInfo: .gray02)
    
    private let linkTextField: BasicTextField = BasicTextField(placeholder: "합주 영상이나 녹음파일 링크를 입력해주세요")
    
    private lazy var linkVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [linkLabel, linkDescription, linkTextField]))
    
    init() {
        super.init(frame: .zero)
        setupLayout()
        attribute()
    }
    
    private func setupLayout() {
        self.addArrangedSubview(practiceSongNameVstack)
        self.addArrangedSubview(artistNameVstack)
        self.addArrangedSubview(linkVstack)

        self.addSubview(deleteButton)
        deleteButton.constraint(top: self.topAnchor,
                                trailing: self.trailingAnchor,
                                padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10))
    }
    
    private func attribute() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.white.cgColor
        self.backgroundColor = .dark02
        self.axis = .vertical
        self.spacing = 40
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 10)
        deleteButton.isHidden = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
