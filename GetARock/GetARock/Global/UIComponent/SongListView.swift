//
//  SongListView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/25.
//

import UIKit

class SongListView: UIView {
    
    // MARK: - Property
    
    enum SongListType {
        case create
        case detail
    }
    
    private var songListType: SongListType
    
    private let imageConfiguation = UIImage.SymbolConfiguration(pointSize: 20)
    
    // MARK: - View
    
    private var songTitleLabel: UILabel = {
        $0.text = "Don't Look Back in AngerDon't Look Back in AngerDon't Look Back in Anger"
        $0.font = UIFont.setFont(.content)
        $0.numberOfLines = 2
        $0.textColor = .white
        return $0
    }(UILabel())

    private var artistLabel: UILabel = {
        $0.text = "OasisDon't Look Back in AngerDon't Look Back in AngerDon't Look Back in Anger"
        $0.font = UIFont.setFont(.content)
        $0.numberOfLines = 2
        $0.textColor = .gray02
        return $0
    }(UILabel())
    
    private lazy var musicIconImage: UIImageView = {
        $0.image = UIImage(
            systemName: "music.quarternote.3"
        )
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        //muiscTextStackView 영역이 제일 길어져도뷰의 크기를 유지할 수 있게 ResistancePriority를 높임
        $0.setContentCompressionResistancePriority(
            UILayoutPriority(rawValue: 760),
            for: .horizontal
        )
        return $0
    }(UIImageView())
    
    private lazy var linkButton: UIButton = {
        $0.setImage(UIImage(
            systemName: "arrow.up.right",
            withConfiguration: imageConfiguation), for: .normal
        )
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        //muiscTextStackView 영역이 제일 길어져도뷰의 크기를 유지할 수 있게 ResistancePriority를 높임
        $0.setContentCompressionResistancePriority(
            UILayoutPriority(rawValue: 760),
            for: .horizontal
        )
        return $0
    }(UIButton())
    
    private lazy var deleteButton: UIButton = {
        $0.setImage(UIImage(
            systemName: "xmark.circle.fill",
            withConfiguration: imageConfiguation),for: .normal
        )
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray02
        //muiscTextStackView 영역이 제일 길어져도뷰의 크기를 유지할 수 있게 ResistancePriority를 높임
        $0.setContentCompressionResistancePriority(
            UILayoutPriority(rawValue: 760),
            for: .horizontal
        )
        return $0
    }(UIButton())
    
    private lazy var songLabelStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 3
        return $0
    }(UIStackView(arrangedSubviews: [songTitleLabel,artistLabel]))
    
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
    }(UIStackView(arrangedSubviews: [musicIconImage,songLabelStackView]))
    
    // MARK: - Init

    init(songListType: SongListType) {
        self.songListType = songListType
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func setupLayout() {
        addSubview(concertedMusicStakView)
        self.concertedMusicStakView.constraint(.widthAnchor, constant: TextFieldSize.width)
        setupSongListLayout()
    }

    private func setupSongListLayout() {
        switch songListType {
        case .create:
            concertedMusicStakView.addArrangedSubview(deleteButton)
        case .detail:
            setupdetailSongListLayout(data: Song(title: "하이", artist: "오아시스", link: nil))
        }
    }
    
    private func setupdetailSongListLayout(data: Song) {
        if data.link != nil {
            concertedMusicStakView.addArrangedSubview(linkButton)
        }
    }    
}
