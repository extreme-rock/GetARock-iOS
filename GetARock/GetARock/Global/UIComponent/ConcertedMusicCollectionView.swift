//
//  ConcertedMusicCollectionView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/25.
//

import UIKit

class ConcertedMusicCollectionView: UIView {
    
    // MARK: - View
    private var songTitle: UILabel = {
        $0.text = "Don't Look Back in Anger"
        $0.font = UIFont.setFont(.content)
        $0.textColor = .white
        return $0
    }(UILabel())

    private var singerName: UILabel = {
        $0.text = "Oasis"
        $0.font = UIFont.setFont(.content)
        $0.textColor = .gray02
        return $0
    }(UILabel())
    
    private var musicIcon: UIImageView = {
        $0.image = UIImage(systemName: "music.quarternote.3")
        $0.tintColor = .white
        return $0
    }(UIImageView())
    
    private lazy var muiscTextStackView: UIStackView = {
        $0.axis = .vertical
        return $0
    }(UIStackView(arrangedSubviews: [songTitle,singerName]))
    
    private lazy var concertedMusicStakView: UIStackView = {
        $0.axis = .horizontal
        return $0
    }(UIStackView(arrangedSubviews: [musicIcon,muiscTextStackView]))
    
    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(concertedMusicStakView)
        self.concertedMusicStakView.constraint(.widthAnchor, constant: TextFieldSize.width)
        self.concertedMusicStakView.constraint(.heightAnchor, constant: 70)
    }
}
