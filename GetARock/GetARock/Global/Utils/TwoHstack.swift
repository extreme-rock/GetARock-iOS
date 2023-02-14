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

    // MARK: - Init
    init(guideText: String, type: InputType) {
        self.guideText = guideText
        self.type = type
        super.init()
    }

    private func attribute() {
        self.axis = .horizontal
        self.spacing = 3
        self.addArrangedSubview(firstLabel)
        self.addArrangedSubview(secondLabel)
    }

    private func setupLayout() {

    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// 2개의 컴포넌트가 수평으로 붙어있는 케이스를 모아놓는 구조체
//struct TwoHstackLabel {
//
//    // 합주곡(선택) 처럼 폰트가 다른 2개의 레이블이 붙어있는 경우
//    static func informationLabel(guideText: String, inputType: InputType) -> UIStackView {
//        let firstLabel = BasicLabel(contentText: guideText, fontStyle: .headline01, textColorInfo: .white)
//        let secondLabel = BasicLabel(contentText: inputType.rawValue, fontStyle: .content, textColorInfo: .gray02)
//        firstLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
//
//        let stackView = UIStackView(arrangedSubviews: [firstLabel, secondLabel])
//        stackView.axis = .horizontal
//        stackView.spacing = 3
//
//        return stackView
//    }
//}

enum InputType: String {
    case optional = "(선택)"
    case required = "(필수)"
}

