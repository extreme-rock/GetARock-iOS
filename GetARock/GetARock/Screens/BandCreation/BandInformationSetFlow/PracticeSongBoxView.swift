//
//  PracticeSongBoxView.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/28.
//

import UIKit

final class PracticeSongBoxView: UIView {
    
    // MARK: - View
    
    private let songTitleLabel: UILabel = {
        $0.font = UIFont.setFont(.content)
        $0.numberOfLines = 2
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private let artistLabel: UILabel = {
        $0.font = UIFont.setFont(.content)
        $0.numberOfLines = 2
        $0.textColor = .gray02
        return $0
    }(UILabel())
    
    private lazy var musicIconImage: UIImageView = {
        $0.image = UIImage(systemName: "music.quarternote.3")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        $0.setContentHuggingPriority(UILayoutPriority(rawValue: 500),
                                     for: .horizontal)
        $0.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 760),
                                                   for: .horizontal)
        return $0
    }(UIImageView())
    
    private lazy var deleteButton: UIButton = {
        $0.setImage(ImageLiteral.xmarkCircleSymbol, for: .normal)
        let action = UIAction { _ in self.removeFromSuperview() }
        $0.addAction(action, for: .touchUpInside)
        $0.contentMode = .scaleAspectFit
        $0.constraint(.widthAnchor, constant: 24)
        $0.constraint(.heightAnchor, constant: 24)
        return $0
    }(UIButton())
    
    private lazy var songLabelStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 3
        return $0
    }(UIStackView(arrangedSubviews: [songTitleLabel,artistLabel]))
    
    private lazy var songStackView: UIStackView = {
        $0.backgroundColor = .dark02
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 15
        $0.layer.cornerRadius = 10
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 15.0, left: 20.0, bottom: 15.0, right: 20.0)
        $0.layer.borderColor = UIColor.gray02.cgColor
        $0.layer.borderWidth = 1
        return $0
    }(UIStackView(arrangedSubviews: [musicIconImage,
                                     songLabelStackView]))
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Method
    
    private func setupLayout() {
        self.addSubview(songStackView)
        self.songStackView.constraint(to: self)
        self.addSubview(deleteButton)
        deleteButton.constraint(trailing: self.trailingAnchor, centerY: self.centerYAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20))
    }
    
    func configure(data: PracticeSongCardView) {
        self.songTitleLabel.text = data.getSongName()
        self.artistLabel.text = data.getArtistName()
    }
}
