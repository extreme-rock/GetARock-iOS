//
//  BandInfomationView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/03/01.
//

import UIKit

final class BandInformationView: UIView {
    
    // MARK: - Property
    
    private var bandMember: [MemberListVO]
    private var bandSong: [SongListVO]?
    private var bandIntro: String?
    private var bandAge: String
    private var bandSNS: [SnsListVO]?
    private var bandMemberCollectionViewItem: [Item] = []
    
    // MARK: - View
    
    private let scrollView: UIScrollView = {
        $0.backgroundColor = .dark01
        return $0
    }(UIScrollView())
    
    private let bandMemberTitleLabel = BasicLabel(
        contentText: "밴드 멤버 👩‍🎤👨‍🎤",
        fontStyle: .headline01,
        textColorInfo: .white
    )
    
    private lazy var bandMemberInfoCollectionView = PositionCollectionView(
        cellType: .band,
        items: bandMemberCollectionViewItem,
        isNeedHeader: false
    )
    
    private lazy var bandMemberInfoLabelStack: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.distribution = .fill
        let memberIntroStartLabel = BasicLabel(contentText: "멤버는 총 ",
                                              fontStyle: .contentLight,
                                              textColorInfo: .white)
        var memberCountAgeLabel = BasicLabel(contentText: "\(bandMember.count)명, \(bandAge)",
                                             fontStyle: .contentBold,
                                             textColorInfo: .white)
        let memberIntroLastLabel = BasicLabel(contentText: "로 구성되어 있어요.",
                                             fontStyle: .contentLight,
                                             textColorInfo: .white)
        let spacingView = UIView()
        $0.addArrangedSubview(memberIntroStartLabel)
        $0.addArrangedSubview(memberCountAgeLabel)
        $0.addArrangedSubview(memberIntroLastLabel)
        $0.addArrangedSubview(spacingView)
        return $0
    }(UIStackView())

    private lazy var bandMemberStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [bandMemberTitleLabel,bandMemberInfoLabelStack,bandMemberInfoCollectionView]))
    
    private let bandSongTitleLabel = BasicLabel(
        contentText: "합주곡 🎤",
        fontStyle: .headline01,
        textColorInfo: .white
    )
    
    private lazy var bandSongListView: SongListView = {
        $0.constraint(.heightAnchor, constant: CGFloat((bandSong?.count ?? 0) * 80))
        return $0
    }(SongListView(songListType: .detail, songList: bandSong))
    
    private lazy var bandSongStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [bandSongTitleLabel,bandSongListView]))
    
    private let bandIntroTitleLabel = BasicLabel(
        contentText: "밴드 소개 📢",
        fontStyle: .headline01,
        textColorInfo: .white
    )
    
    private let bandIntroLabel: PaddingLabel = {
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
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [bandIntroTitleLabel, bandIntroLabel]))
    
    private let bandSNSTitleLabel = BasicLabel(
        contentText: "밴드 SNS 🙌",
        fontStyle: .headline01,
        textColorInfo: .white
    )
    
    private lazy var bandSNSListView = SNSListStackView(data: bandSNS ?? [])
    
    private lazy var bandSNSStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [bandSNSTitleLabel, bandSNSListView]))
    
    private lazy var bandInfoStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 60
        $0.distribution = .fill
        return $0
    }(UIStackView(arrangedSubviews: [bandMemberStackView, bandSongStackView, bandIntroStackView, bandSNSStackView]))
    
    // MARK: - Init
    
    init(member: [MemberListVO], song: [SongListVO]?, intro: String?,sns: [SnsListVO]?, age:String) {
        self.bandMember = member
        self.bandSong = song
        self.bandIntro = intro
        self.bandSNS = sns
        self.bandAge = age
        super.init(frame: .zero)
        makeBandMemberData()
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
        
        setLayoutForBandMembeCollectionView()
        setBandInfo()
        scrollView.addSubview(bandInfoStackView)
        bandInfoStackView.constraint(
            top: scrollView.contentLayoutGuide.topAnchor,
            leading: scrollView.contentLayoutGuide.leadingAnchor,
            bottom: scrollView.contentLayoutGuide.bottomAnchor,
            trailing: scrollView.contentLayoutGuide.trailingAnchor,
            padding: UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        )
    }
    
    private func setBandInfo() {
        if bandIntro == nil {
            let emptyView = EmptyView(type: .noBand)
            bandIntroStackView.removeArrangedSubview(bandIntroLabel)
            bandIntroStackView.addArrangedSubview(emptyView)
            
        } else {
            bandIntroLabel.text = bandIntro
        }
    }
    
    private func setLayoutForBandMembeCollectionView() {
        bandMemberInfoCollectionView.constraint(
            .widthAnchor,
           constant: UIScreen.main.bounds.width - 32
        )
        bandMemberInfoCollectionView.constraint(
            .heightAnchor,
            constant: CGFloat((140 + 10) * (bandMemberCollectionViewItem.count-1)/2 + 140)
        )
    }
    
    private func makeBandMemberData() {
           let transformedMemberData = bandMember.map {
               BandMember(
                   isUser: checkMemberState(memberState: $0.memberState),
                   isLeader: checkIsLeaderState(memberState: $0.memberState),
                   userName: $0.name,
                   instrumentImageName: checkInstrumentImage(instrumentList: $0.instrumentList),
                   instrumentNames: $0.instrumentList.map{ $0.name }
               )
               
           }
           transformedMemberData.forEach {
               bandMemberCollectionViewItem.append(.bandMember($0))
           }
       }
       
    private func checkMemberState(memberState: MemberState) -> Bool {
            switch memberState {
            case .admin, .member:
                return true
            default:
                return false
            }
        }
       
       private func checkIsLeaderState(memberState: MemberState) -> Bool {
           switch memberState {
           case .admin:
               return true
           case .member:
               return false
           default:
               return false
           }
       }
       
    private func checkInstrumentImage(instrumentList: [InstrumentListVO]) -> Instrument {
        
           let transformedMemberInstrument = instrumentList.map{ $0.name }
        
           if let mainInstrument = transformedMemberInstrument.first {
               guard let koreaName = Instrument.CodingKeys(rawValue: mainInstrument)?.inKorean else { return .etc }
               return Instrument(rawValue: koreaName) ?? .etc
           }
           return .etc
       }
}

// MARK: - PositionCollectionViewDelegate

// TODO - : 추후 멤버 선택 시 헤당 멤버 상세 페이지로 보내기 구현 필요


