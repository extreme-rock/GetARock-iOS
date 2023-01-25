//
//  SongListView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/25.
//

import UIKit

class SongListView: UIView {
    
    // MARK: - View
    private var songTitleLabel: UILabel = {
        $0.text = "Don't Look Back in Anger"
        $0.font = UIFont.setFont(.content)
        $0.textColor = .white
        return $0
    }(UILabel())

    private var singerNameLabel: UILabel = {
        $0.text = "Oasis"
        $0.font = UIFont.setFont(.content)
        $0.textColor = .gray02
        return $0
    }(UILabel())
    
    private var musicIconImage: UIImageView = {
        $0.image = UIImage(systemName: "music.quarternote.3")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        $0.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        return $0
    }(UIImageView())
    
    private let linkButton: UIButton = {
        $0.setImage(UIImage(systemName: "arrow.up.right"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        //muiscTextStackView 영역이 제일 길어지도록 좁게 유지하고 싶은 영역의 HuggingPriority를 높임
        $0.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        return $0
    }(UIButton())
    
    private let deleteButton: UIButton = {
        $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray02
        //muiscTextStackView 영역이 제일 길어지도록 좁게 유지하고 싶은 영역의 HuggingPriority를 높임
        $0.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .horizontal)
        return $0
    }(UIButton())
    
    private lazy var muiscTextStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 3
        return $0
    }(UIStackView(arrangedSubviews: [songTitleLabel,singerNameLabel]))
    
    private lazy var concertedMusicStakView: UIStackView = {
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
    }(UIStackView(arrangedSubviews: [musicIconImage,muiscTextStackView]))
    
    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupLayout()
        setupDeleteButtonLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func setupLayout() {
        addSubview(concertedMusicStakView)
//        self.concertedMusicStakView.constraint(to: concertedMusicStakView)
        self.concertedMusicStakView.constraint(.widthAnchor, constant: TextFieldSize.width)
    }
    
    private func setupLinkButtonLayout() {
        concertedMusicStakView.addArrangedSubview(linkButton)
    }
    
    private func setupDeleteButtonLayout() {
        concertedMusicStakView.addArrangedSubview(deleteButton)
    }
    
    private func configureLink() {
        
//        if 링크있으면 {
//                setupLinkButtonLayout()
//               }
//
//        if data.isLeader {
//            setupLinkButtonLayout()
//               }
    }
}
