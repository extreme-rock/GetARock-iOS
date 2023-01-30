//
//  emptyView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/30.
//

import UIKit

final class emptyView: UIView {

    // MARK: - Property
    
    private var emptyText: String = ""
    
    // MARK: - View
    
    private let backgroundImage: UIImageView = {
        $0.image = UIImage(named: "emptyView")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var emptyTextLabel: BasicLabel = {
        return $0
    }(BasicLabel(contentText: emptyText, fontStyle: .content, textColorInfo: .gray02))
    
    // MARK: - Init
    
    init(emptyText: String) {
        self.emptyText = emptyText
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
        
        self.backgroundImage.addSubview(emptyTextLabel)
        self.emptyTextLabel.constraint(centerX: backgroundImage.centerXAnchor)
        self.emptyTextLabel.constraint(centerY: backgroundImage.centerYAnchor)
    }
}
