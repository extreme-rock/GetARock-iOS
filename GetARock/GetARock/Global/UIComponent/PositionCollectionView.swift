//
//  PositionCollectionView.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/21.
//

import UIKit

enum Section: Int {
    case main
}

enum entryPoint {
    case band
    case exceptBand
}

enum Item: Hashable {
    case bandMember(BandMember)
    case position(Position)
}

struct BandMember: Hashable {
    let id = UUID()
    let isUser: Bool
    let isLeader: Bool
    let userName: String
    let imageName: String
    let instrumentNames: [String]
}

struct Position: Hashable {
    let id = UUID()
    let instrumentName: String
    let imageName: String
    let isETC: Bool
}
//
//포지션 선택
//name: "기타",
//imageName: "guitar",
//isMain: true, // 가장 처음 선택한 것을 true
//isETC: true // name중 기본 name에 없는 것을 etc로 판단할지, isetc를 넣을지? etc는 x를 넣어줘야함
//

// selection이 있는 경우 : 모두 선택 / 최대2개 -> protocol로 조절
// selection이 없는 경우 : delegate를 쓰지 않음,
// 추가버튼 있는 것과, + 버튼은 어떻게?
protocol PositionCollectionViewDelegate: AnyObject {
    func canSelectPosition(_ collectionView: UICollectionView, indexPath: IndexPath, selectedItemsCount: Int) -> Bool
}

final class PositionCollectionView: UIView {
    
    // MARK: - properties
    
    private lazy var collectionView: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(174),
                                              heightDimension: .absolute(140))
        let item1 = NSCollectionLayoutItem(layoutSize: itemSize)
        let item2 = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(140))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item1, item2])
        
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        collectionView.register(PositionCollectionViewCell.self, forCellWithReuseIdentifier: PositionCollectionViewCell.className)
        return collectionView
    }()
    private var entryPoint: entryPoint
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = self.testConfigureBandMemberDataSource()
    weak var delegate: PositionCollectionViewDelegate?
    
    
    private var positions: [Item] = [.position(Position(instrumentName: "기타", imageName: "guitar", isETC: false)),
                                     .position(Position(instrumentName: "베이스", imageName: "bass", isETC: false)),
                                     .position(Position(instrumentName: "보컬", imageName: "vocal", isETC: false)),
                                     .position(Position(instrumentName: "콘트라베이스으으으", imageName: "drum", isETC: false)),]
    private var bandMemberDummy: [BandMember] = [BandMember(isUser: true, isLeader: true, userName: "콘르아잉이잉베", imageName: "guitar", instrumentNames: ["베이스", "보컬"]), BandMember(isUser: true, isLeader: true, userName: "콘르아잉이잉베", imageName: "guitar", instrumentNames: ["베이스", "보컬"]), BandMember(isUser: true, isLeader: true, userName: "콘르아잉이잉베", imageName: "guitar", instrumentNames: ["베이스", "보컬"]), ]
    
    // MARK: - init
    
    init(entryPoint: entryPoint) {
        self.entryPoint = entryPoint
        super.init(frame: .zero)
        setupLayout()
        configureSelectColorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        addSubview(collectionView)
        collectionView.constraint(to: self)
    }
}


// MARK: - diffable

extension PositionCollectionView {
    
    private func testConfigureBandMemberDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        return UICollectionViewDiffableDataSource<Section, Item>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .bandMember(let bandMember):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BandMemeberCollectionViewCell.className, for: indexPath) as? BandMemeberCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(data: bandMember)
                return cell
            case .position(let position):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PositionCollectionViewCell.className, for: indexPath) as? PositionCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(data: position)
                return cell
            }
        })
    }
    
    private func configureBandMemberDataSource() -> UICollectionViewDiffableDataSource<Section, BandMember> {
        return UICollectionViewDiffableDataSource<Section, BandMember>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, bandMember in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BandMemeberCollectionViewCell.className, for: indexPath) as? BandMemeberCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(data: bandMember)
            return cell
        })
    }
    
    private func configurePositionDataSource() -> UICollectionViewDiffableDataSource<Section, Position>{
        return UICollectionViewDiffableDataSource<Section, Position>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, position in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PositionCollectionViewCell.className, for: indexPath) as? PositionCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(data: position)
            return cell
        })
    }
    
    func applySnapshot(with snapshot: NSDiffableDataSourceSnapshot<Section, Item>) {
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureSelectColorView() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(positions, toSection: .main)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension PositionCollectionView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let selectedPositionCount = collectionView.indexPathsForSelectedItems?.count ?? 0
        guard let canSelect = delegate?.canSelectPosition(collectionView, indexPath: indexPath, selectedItemsCount: selectedPositionCount) else { return false }
        return canSelect
    }
}
