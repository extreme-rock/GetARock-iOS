//
//  SongListCollectionViewCell.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/27.
//

import UIKit

final class SongListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    
    private let imageConfiguation = UIImage.SymbolConfiguration(pointSize: 20)
    
    // MARK: - View
    
    let songTitleLabel: UILabel = {
        $0.font = UIFont.setFont(.content)
        $0.numberOfLines = 2
        $0.textColor = .white
        return $0
    }(UILabel())
    
    let artistLabel: UILabel = {
        $0.font = UIFont.setFont(.content)
        $0.numberOfLines = 2
        $0.textColor = .gray02
        return $0
    }(UILabel())
    
    lazy var musicIconImage: UIImageView = {
        $0.image = UIImage(
            systemName: "music.quarternote.3"
        )
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        $0.setContentHuggingPriority(UILayoutPriority(rawValue: 500),
                                     for: .horizontal)
        $0.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 760),
                                                   for: .horizontal)
        return $0
    }(UIImageView())
    
    lazy var linkButton: UIButton = {
        $0.setImage(UIImage(
            systemName: "arrow.up.right",
            withConfiguration: imageConfiguation), for: .normal
        )
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        $0.setContentHuggingPriority(UILayoutPriority(rawValue: 500),
                                     for: .horizontal)
        $0.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 760),
                                                   for: .horizontal
        )
        return $0
    }(UIButton())
    
    lazy var deleteButton: UIButton = {
        $0.setImage(UIImage(
            systemName: "xmark.circle.fill",
            withConfiguration: imageConfiguation),for: .normal
        )
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray02
        $0.setContentHuggingPriority(UILayoutPriority(rawValue: 500),
                                     for: .horizontal)
        $0.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 760),
                                                   for: .horizontal
        )
        return $0
    }(UIButton())
    
    private lazy var songLabelStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 3
        return $0
    }(UIStackView(arrangedSubviews: [songTitleLabel,artistLabel]))
    
    private lazy var songStakView: UIStackView = {
        $0.backgroundColor = .dark02
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 15
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 15.0, left: 20.0, bottom: 15.0, right: 20.0)
        $0.layer.borderColor = UIColor.gray02.cgColor
        $0.layer.borderWidth = 1
        return $0
    }(UIStackView(arrangedSubviews: [musicIconImage,songLabelStackView]))
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
    }
    
    // MARK: - Method
    
    private func setupLayout() {
        self.contentView.addSubview(songStakView)
        self.songStakView.constraint(to: self)
    }
    
    func setupDeleteButtonLayout() {
        songStakView.addArrangedSubview(deleteButton)
    }
    
    func setupLinkButtonLayout() {
        songStakView.addArrangedSubview(linkButton)
    }
    
    func configure(data: Song?, songListType: SongListType) {
        
        guard let songlist = data else { return }
                
        self.songTitleLabel.text = songlist.title
        self.artistLabel.text = songlist.artist
        
        switch songListType {
        case .create:
            self.setupDeleteButtonLayout()
        case .detail:
            if songlist.link != nil {
                self.setupLinkButtonLayout()
            }
        }
    }

}

