//
//  BandInfomationView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/03/01.
//

import UIKit

class BandInfomationView: UIView {
    
    // MARK: - Property
    
    private var bandMember: [MemberListVO]
    private var bandSong: [SongListVO]?
    private var bandIntro: String?
    private var bandSNS: [SnsListVO]?
    
    // MARK: - View
    
    lazy var scrollView: UIScrollView = {
        $0.backgroundColor = .yellow
        return $0
    }(UIScrollView(frame: self.bounds))
    
    let contentView: UIView = {
        $0.backgroundColor = .purple
        return $0
    }(UIView())
    
    //멤버
    private let bandMemberTitleLable = BasicLabel(
        contentText: "밴드 멤버 👩‍🎤👨‍🎤",
        fontStyle: .headline01,
        textColorInfo: .white
    )
    
    private let bandMemberInfoLable = BasicLabel(
        contentText: "멤버는 총 5명이고 20~30대로 구성되어있어요.",
        fontStyle: .content,
        textColorInfo: .white
    )
    
    //    private lazy var bandMemberInfoCollectView = PositionCollectionView(cellType: .band, items: [], isNeedHeader: true)
    
    private lazy var bandMembeStackView: UIStackView = {
        $0.backgroundColor = .red
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [bandMemberTitleLable,bandMemberInfoLable]))
    
    
    //합주곡
    private let bandSongTitleLable = BasicLabel(
        contentText: "합주곡 🎤",
        fontStyle: .headline01,
        textColorInfo: .white
    )
    
    private let bandSongListView: SongListView = {
        return $0
    }(SongListView(songListType: .detail))
    
    private lazy var bandSongStackView: UIStackView = {
        $0.backgroundColor = .orange
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [bandSongTitleLable,bandSongListView]))
    
    
    //밴드 소개
    private let bandIntroTitleLable = BasicLabel(
        contentText: "밴드 소개 📢",
        fontStyle: .headline01,
        textColorInfo: .white
    )
    
    private let bandIntroLable: BasicLabel = {
        $0.numberOfLines = 0
        return $0
    }(BasicLabel(
        contentText: "",
        fontStyle: .headline01,
        textColorInfo: .white
    ))
    
    private lazy var bandIntroStackView: UIStackView = {
        $0.backgroundColor = .green
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [bandIntroTitleLable, bandIntroLable]))
    
    
    //밴드 SNS
    private let bandSNSTitleLable = BasicLabel(
        contentText: "밴드 SNS 🙌",
        fontStyle: .headline01,
        textColorInfo: .white
    )
    
    //    private let bandSNSListView = SNSListStackView(data: )
    
    private lazy var bandSNSStackView: UIStackView = {
        $0.backgroundColor = .blue
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [bandSNSTitleLable]))
    
    private lazy var bandInfoStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 200
        return $0
    }(UIStackView(arrangedSubviews: [bandMembeStackView, bandSongStackView, bandIntroStackView, bandSNSStackView]))
    
    
    // MARK: - Init
    
    init(member: [MemberListVO], song: [SongListVO]?, intro: String?,sns: [SnsListVO]?) {
        self.bandMember = member
        self.bandSong = song
        self.bandIntro = intro
        self.bandSNS = sns
        super.init(frame: .zero)
        setupLayout()
        attribute()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.backgroundColor = .dark01
    }
    
    private func setupLayout() {
        
        self.addSubview(scrollView)
        scrollView.constraint(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            bottom: self.bottomAnchor,
            trailing: self.trailingAnchor
        )
        
        scrollView.addSubview(contentView)
        contentView.constraint(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            bottom: scrollView.bottomAnchor,
            trailing: scrollView.trailingAnchor
        )
        
        contentView.addSubview(bandInfoStackView)
        bandInfoStackView.constraint(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor)
        
        scrollView.contentSize = CGSize(width: self.bounds.width, height: contentView.bounds.height)
    }
    
    
}


