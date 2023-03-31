//
//  PracticeSongBoxView.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/09.
//

import UIKit

final class PracticeSongBoxView: UIView {
    
    // MARK: - View

    private var songLink: String = ""
    
    private let songTitleLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "", fontStyle: .content, textColorInfo: .white))
    
    private let artistLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "", fontStyle: .content, textColorInfo: .gray02))
    
    private lazy var musicIconImage: UIImageView = {
        $0.image = ImageLiteral.quarternoteSymbol
        $0.constraint(.widthAnchor, constant: 24)
        $0.constraint(.heightAnchor, constant: 24)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        $0.setContentHuggingPriority(UILayoutPriority(rawValue: 500),
                                     for: .horizontal)
        $0.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 760),
                                                   for: .horizontal)
        return $0
    }(UIImageView())
    
    private lazy var deleteButton: UIButton = {
        let imageConfiguation = UIImage.SymbolConfiguration(pointSize: 20)
        $0.setImage(UIImage(
            systemName: "xmark.circle.fill",
            withConfiguration: imageConfiguation),for: .normal
        )
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray02
        let action = UIAction { [weak self] _ in
            UIView.animate(withDuration: 0.3, animations: {
                self?.alpha = 0
            }, completion: { [weak self] _ in
                self?.removeFromSuperview()
            })
        }
        $0.addAction(action, for: .touchUpInside)
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
        songStackView.constraint(to: self)
        songStackView.constraint(.heightAnchor, constant: 70)
        self.addSubview(deleteButton)
        deleteButton.constraint(trailing: self.trailingAnchor,
                                centerY: self.centerYAnchor,
                                padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20))
    }
    
    func configure(data: PracticeSongCardView) {
        songTitleLabel.text = data.songName()
        artistLabel.text = data.artistName()
        songLink = data.linkText()
    }

    func artistName() -> String {
        return artistLabel.text ?? ""
    }

    func songName() -> String {
        return songTitleLabel.text ?? ""
    }

    func linkText() -> String {
        return songLink
    }
}

