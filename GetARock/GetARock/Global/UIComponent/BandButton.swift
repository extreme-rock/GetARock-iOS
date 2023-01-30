//
//  BandButton.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/30.
//

import UIKit

class BandButton: UIView {
    
    // MARK: - View
    
    private let backgroundImage: UIImageView = {
        $0.image = UIImage(named: "bandButton")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var bandNameLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "임시텍스트임시텍스트임시텍스트임시텍스트", fontStyle: .headline01, textColorInfo: .white))
    
    private let memberIconImage: UIImageView = {
        $0.image = UIImage(systemName: "person.3.fill",
                           withConfiguration: SFIconSize.smallIconSize)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        return $0
    }(UIImageView())
    
    private var memberinfoLabel: BasicLabel = {
        return $0
    }(BasicLabel(contentText: "임시텍스트", fontStyle: .content, textColorInfo: .white))
    
    private lazy var memberstackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 5
        return $0
    }(UIStackView(arrangedSubviews: [memberIconImage,memberinfoLabel]))
    
    private lazy var bandInfoStackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 8
        $0.isLayoutMarginsRelativeArrangement = true
        return $0
    }(UIStackView(arrangedSubviews: [bandNameLabel,memberstackView]))
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        self.backgroundImage.addSubview(bandInfoStackView)
        self.bandInfoStackView.constraint(
            leading: self.leadingAnchor,
            trailing: self.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 150)
        )
        self.bandInfoStackView.constraint(centerY: backgroundImage.centerYAnchor)
    }
}
