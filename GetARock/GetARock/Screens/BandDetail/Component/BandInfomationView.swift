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
    private var transformedMemberData: [BandMember] = []
    private var bandMemberCollectionViewItem: [Item] = [
        .bandMember(BandMember(isUser: true, isLeader: true, userName: "노엘", instrumentImageName: .guitar, instrumentNames: ["기타", "드럼"]))
    ]
    private var checkState: Bool = false
    
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
    
    private lazy var bandMemberInfoCollectView = PositionCollectionView(
        cellType: .band,
        items: [.bandMember(BandMember(isUser: true, isLeader: true, userName: "노엘", instrumentImageName: .guitar, instrumentNames: ["기타", "드럼"]))
        ],
        isNeedHeader: true
    )
    
    private lazy var bandMembeStackView: UIStackView = {
        $0.backgroundColor = .red
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [bandMemberTitleLable,bandMemberInfoLable]))
    
    
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
        print("밴드 멤버 : \(bandMember)")
        self.bandSong = song
        self.bandIntro = intro
        self.bandSNS = sns
        super.init(frame: .zero)
        bandMemberInfoCollectView.delegate = self
//        makebandMemberData()
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
        bandMembeStackView.addArrangedSubview(bandMemberInfoCollectView)
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
    
    private func makebandMemberData() {
        transformedMemberData = bandMember.map {
            BandMember(isUser: checkState,
                       isLeader: false,
                       userName: $0.name,
                       instrumentImageName: .guitar,
                       instrumentNames: $0.instrumentList.map{ $0.name })

        }
        checkMemberState()
        checkinstrumentImage()
        
        for i in 0..<transformedMemberData.count {
            bandMemberCollectionViewItem.append(.bandMember(transformedMemberData[i]))
        }
        
        print(bandMemberCollectionViewItem)
    }
    
    func checkMemberState() {
        let transformedMemberState = bandMember.map{ $0.memberState }
        for i in 0..<transformedMemberState.count {
            if transformedMemberState[i] == .admin {
                transformedMemberData[i].isUser = true
                transformedMemberData[i].isLeader = true
            } else if transformedMemberState[i] == .member {
                transformedMemberData[i].isUser = true
            }
        }
    }
    
    func checkinstrumentImage() {
        let transformedMemberInstrument = bandMember.map{ $0.instrumentList.map{ $0.name } }

        for i in 0..<transformedMemberInstrument.count {

            if let mainInstrument = transformedMemberInstrument[i].first{

            if mainInstrument == "guitar" {
                transformedMemberData[i].instrumentImageName = .guitar
            }
            else if mainInstrument == "bass" {
                transformedMemberData[i].instrumentImageName = .bass
            }
            else if mainInstrument == "keyboard" {
                transformedMemberData[i].instrumentImageName = .keyboard
            }
            else if mainInstrument == "drum" {
                transformedMemberData[i].instrumentImageName = .drum
            }
            else if mainInstrument == "vocal" {
                transformedMemberData[i].instrumentImageName = .vocal
            }
                else {
                    transformedMemberData[i].instrumentImageName = .etc
                }
            }
        }
    }
}

extension  BandInfomationView: PositionCollectionViewDelegate {
    func canSelectPosition(_ collectionView: UICollectionView, indexPath: IndexPath, selectedItemsCount: Int) -> Bool {
        return true
    }
}


