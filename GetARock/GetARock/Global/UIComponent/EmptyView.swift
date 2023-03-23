//
//  emptyView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/30.
//

import UIKit

final class EmptyView: UIView {

    // MARK: - Property
    
    enum EmptyViewGuidance: String {
         case noSong = "합주곡이 없습니다."
         case noIntroduction = "작성한 소개가 없습니다."
         case noBand = "가입한 밴드가 없습니다."
     }
    
    private var emptyType : EmptyViewGuidance
    
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
    
    init(type: EmptyViewGuidance) {
        self.emptyType = type
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
        case .noSong:
            return self.emptyMessageLabel.text = EmptyViewGuidance.noSong.rawValue
        case .noIntroduction:
            return self.emptyMessageLabel.text = EmptyViewGuidance.noIntroduction.rawValue
        case .noBand:
            return self.emptyMessageLabel.text = EmptyViewGuidance.noBand.rawValue
        }
    }
}
