//
//  TwoHstack.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/14.
//

import UIKit

final class InformationGuideLabel: UIStackView {

    enum InputType: String {
        case optional = "(선택)"
        case required = "(필수)"
    }

    private let guideText: String

    private let type: InputType

    private lazy var firstLabel: BasicLabel = {
        $0.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        return $0
    }(BasicLabel(contentText: guideText, fontStyle: .headline01, textColorInfo: .white))

    private lazy var secondLabel = BasicLabel(contentText: type.rawValue, fontStyle: .content, textColorInfo: .gray02)

    init(guideText: String, type: InputType) {
        self.guideText = guideText
        self.type = type
        super.init(frame: .zero)
        attribute()
    }

    private func attribute() {
        self.axis = .horizontal
        self.spacing = 3
        self.addArrangedSubview(firstLabel)
        self.addArrangedSubview(secondLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
