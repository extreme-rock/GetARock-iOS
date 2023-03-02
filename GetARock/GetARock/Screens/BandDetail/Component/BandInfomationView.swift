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
    
    //현재 컬랙션뷰에서 받는 데이터 모델
    private var bandMemberDake: [Item] = [
        .bandMember(BandMember(isUser: <#T##Bool#>,
                               isLeader: <#T##Bool#>,
                               userName: <#T##String#>,
                               instrumentImageName: <#T##InstrumentImageName#>,
                               instrumentNames: <#T##[String]#>))
    ]
    
    // 밴드에서 GET해오는 데이터 모델
    private var bandMemberVO: [MemberListVO] = [
        MemberListVO(memberBandID: <#T##Int?#>,
                     memberID: <#T##Int?#>,
                     name: <#T##String#>,
                     memberState: <#T##MemberState#>,
                     instrumentList: [
                        InstrumentListVO(instrumentID: <#T##Int?#>, isMain: <#T##Bool?#>, name: <#T##String#>)
                     ])
    ]
    
    // MARK: - View
    
    let scrollView: UIScrollView = {
        $0.backgroundColor = .yellow
        return $0
    }(UIScrollView())
    
    let contentView: UIView = {
        $0.backgroundColor = .purple
        return $0
    }(UIView())
    
    // ① 멤버
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
    
    private lazy var bandMemberInfoCollectView = PositionCollectionView(cellType: .band, items: [], isNeedHeader: true)
    
    private lazy var bandMembeStackView: UIStackView = {
        $0.backgroundColor = .red
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [bandMemberTitleLable,bandMemberInfoLable, bandMemberInfoCollectView]))
    
    
    // ② 합주곡
    private let bandSongTitleLable = BasicLabel(
        contentText: "합주곡 🎤",
        fontStyle: .headline01,
        textColorInfo: .white
    )
    
    private lazy var bandSongListView: SongListView = {
        $0.backgroundColor = .blue
        return $0
    }(SongListView(songListType: .detail, data: bandSong))
    
    private lazy var bandSongStackView: UIStackView = {
        $0.backgroundColor = .orange
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [bandSongTitleLable,bandSongListView]))
    
    
    // ③ 밴드 소개
    private let bandIntroTitleLable = BasicLabel(
        contentText: "밴드 소개 📢",
        fontStyle: .headline01,
        textColorInfo: .white
    )
    
    private let bandIntroLable: PaddingLabel = {
        $0.text = "잘나오나?"
        $0.font = UIFont.setFont(.content)
        $0.numberOfLines = 0
        $0.textColor = .white
        $0.clipsToBounds = false
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .dark02
        $0.layer.borderColor = UIColor.gray02.cgColor
        $0.layer.borderWidth = 1
        $0.numberOfLines = 0
        return $0
    }(PaddingLabel())
    
    private lazy var bandIntroStackView: UIStackView = {
        $0.backgroundColor = .green
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [bandIntroTitleLable, bandIntroLable]))
    
    
    // ④ 밴드 SNS
    private let bandSNSTitleLable = BasicLabel(
        contentText: "밴드 SNS 🙌",
        fontStyle: .headline01,
        textColorInfo: .white
    )
    
//    private lazy var bandSNSListView = SNSListStackView(data: bandSNS)
    
    private lazy var bandSNSStackView: UIStackView = {
        $0.backgroundColor = .blue
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [bandSNSTitleLable]))
    
    private lazy var bandInfoStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 40
        $0.distribution = .fill
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 30, left: 16, bottom: 30, right: 16)
        
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
        setBandInfo()
    }
    
    private func setupLayout() {
//
//        self.addSubview(scrollView)
//        scrollView.constraint(
//            top: self.topAnchor,
//            leading: self.leadingAnchor,
//            bottom: self.bottomAnchor,
//            trailing: self.trailingAnchor
//        )
//
//        scrollView.addSubview(contentView)
//        contentView.constraint(
//            top: scrollView.topAnchor,
//            leading: scrollView.leadingAnchor,
//            bottom: scrollView.bottomAnchor,
//            trailing: scrollView.trailingAnchor
//        )
        
        self.addSubview(bandInfoStackView)
        bandInfoStackView.constraint(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            bottom: self.bottomAnchor,
            trailing: self.trailingAnchor)
        
//        contentView.addSubview(bandInfoStackView)
//        bandInfoStackView.constraint(
//            top: contentView.topAnchor,
//            leading: contentView.leadingAnchor,
//            bottom: contentView.bottomAnchor,
//            trailing: contentView.trailingAnchor)
//
//        scrollView.contentSize = CGSize(width: self.bounds.width, height: contentView.bounds.height)
    }
    
    private func setBandInfo() {
        if bandIntro == nil{
            let emptyView = EmptyView(type: .noBand)
            bandIntroStackView.removeArrangedSubview(bandIntroLable)
            bandIntroStackView.addArrangedSubview(emptyView)
            
        } else {
            bandIntroLable.text = bandIntro
        }
    }
    
    
}


