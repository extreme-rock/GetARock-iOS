//
//  BasicBoxView.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/14.
//

import UIKit

final class BasicBoxView: UIStackView {

    private var text: String = ""

    private lazy var basicLabel = {
        $0.numberOfLines = 3
        return $0
    }(BasicLabel(contentText: text, fontStyle: .content, textColorInfo: .gray02))

    private let basicRightView: UIImageView = {
        $0.image = ImageLiteral.chevronRightSymbol
        $0.constraint(.widthAnchor, constant: 16)
        $0.constraint(.heightAnchor, constant: 16)
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())

    init(text: String? = nil) {
        if let text = text { self.text = text }
        super.init(frame: .zero)
        attribute()
        setupLayout()
    }
    
    private func attribute() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.backgroundColor = .dark02
        self.layer.borderColor = UIColor.white.cgColor
        self.axis = .horizontal
        basicRightView.isHidden = true
    }
    
    private func setupLayout() {

        self.constraint(.widthAnchor, constant: BasicComponentSize.width)
        self.constraint(.heightAnchor, constant: 55)
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20)
        self.addArrangedSubview(basicLabel)
        self.addArrangedSubview(basicRightView)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showRightView() {
        basicRightView.isHidden = false
    }
    
    func hideRightView() {
        basicRightView.isHidden = true
    }
    
    func configureText(with text: String) {
        self.basicLabel.text = text
    }

    func setTextColor(with color: UIColor) {
        self.basicLabel.textColor = color
    }
}
