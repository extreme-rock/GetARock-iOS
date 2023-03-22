//
//  PracticeSongCardView.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/09.
//

import UIKit

final class PracticeSongCardView: UIStackView {
    
    // MARK: - View

    lazy var deleteButton: UIButton = {
        $0.setImage(ImageLiteral.xmarkSymbol, for: .normal)
        $0.tintColor = .white
        return $0
    }(UIButton())
    
    private let practiceSongNameGuideLabel: InformationGuideLabel = InformationGuideLabel(guideText: "합주곡 제목", type: .required)
    
    private lazy var practiceSongTextField: BasicTextField = {
        $0.delegate = self
        $0.constraint(.widthAnchor,
                      constant: BasicComponentSize.width - 40)
        return $0
    }(BasicTextField(placeholder: "합주곡 제목을 입력해주세요"))
    
    private lazy var practiceSongNameVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [practiceSongNameGuideLabel, practiceSongTextField]))
    
    private let artistNameGuideLabel: InformationGuideLabel = InformationGuideLabel(guideText: "아티스트", type: .required)
    
    private lazy var artistNameTextField: BasicTextField = {
        $0.delegate = self
        $0.constraint(.widthAnchor,
                      constant: BasicComponentSize.width - 20)
        return $0
    }(BasicTextField(placeholder: "아티스트를 입력해주세요"))
    
    private lazy var artistNameVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [artistNameGuideLabel, artistNameTextField]))
    
    private let linkLabel: InformationGuideLabel = InformationGuideLabel(guideText: "링크", type: .optional)
    
    private let linkDescription: BasicLabel = BasicLabel(
        contentText: "* 해당 곡을 합주한 작업물 링크를 입력해주세요",
        fontStyle: .content,
        textColorInfo: .gray02)
    
    private let linkTextField: BasicTextField = {
        $0.constraint(.widthAnchor,
                      constant: BasicComponentSize.width - 20)
        return $0
    }(BasicTextField(placeholder: "합주 영상이나 녹음파일 링크를 입력해주세요"))
    
    private lazy var linkVstack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [linkLabel, linkDescription, linkTextField]))
    
    // MARK: - init
    
    init() {
        super.init(frame: .zero)
        setupLayout()
        attribute()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
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
        self.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)
        deleteButton.isHidden = true
    }
    
    func artistName() -> String {
        return artistNameTextField.textField.text ?? ""
    }
    
    func songName() -> String {
        return practiceSongTextField.textField.text ?? ""
    }

    func linkText() -> String {
        return linkTextField.inputText()
    }

    func hideDeleteButton() {
        deleteButton.isHidden = true
    }

    func showDeleteButton() {
        deleteButton.isHidden = false
    }
    
    func setTextFieldDelegate(controller: UITextFieldDelegate) {
        artistNameTextField.textField.delegate = controller
        practiceSongTextField.textField.delegate = controller
        linkTextField.textField.delegate = controller
    }
}

extension PracticeSongCardView: BasicTextFieldDelegate {
    func textFieldTextDidChange() {
        NotificationCenter.default.post(name: Notification.Name.didPracticeCardViewTextFieldChange, object: nil)
    }
}
