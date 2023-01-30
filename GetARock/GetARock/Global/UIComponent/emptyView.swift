//
//  emptyView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/30.
//

import UIKit

final class emptyView: UIView {

    // MARK: - Property
    
    enum EmptyType {
        case notSong
        case notIntroduction
        case notBand
    }
    
    private var emptyType : EmptyType
    
    // MARK: - View
    
    private let backgroundImage: UIImageView = {
        $0.image = UIImage(named: "emptyView")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var emptyMessageLabel: BasicLabel = {
        return $0
    }(BasicLabel(contentText: "", fontStyle: .content, textColorInfo: .gray02))
    
    // MARK: - Init
    
    init(emptyType: EmptyType) {
        self.emptyType = emptyType
        super.init(frame: .zero)
        setupLayout()
        attribute()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Method
    
    private func attribute() {
        self.constraint(.widthAnchor, constant: UIScreen.main.bounds.width - 32)
        self.constraint(.heightAnchor, constant: 100)
    }

    private func setupLayout() {
        self.addSubview(backgroundImage)
        self.backgroundImage.constraint(to: self)
        
        self.backgroundImage.addSubview(emptyMessageLabel)
        self.emptyMessageLabel.constraint(centerX: backgroundImage.centerXAnchor)
        self.emptyMessageLabel.constraint(centerY: backgroundImage.centerYAnchor)
        setEmptyMessage()
    }
    
    private func setEmptyMessage() {
        switch emptyType {
        case .notSong:
            return self.emptyMessageLabel.text = "합주곡이 없습니다."
        case .notIntroduction:
            return self.emptyMessageLabel.text = "작성한 소개가 없습니다."
        case .notBand:
            return self.emptyMessageLabel.text = "아직 가입한 밴드가 없습니다."
        }
    }
}
