//
//  PositionCollectionView.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/21.
//

import UIKit

enum PositionSection: Int {
    case main
}

enum entryPoint {
    case band
    case exceptBand
}
//
// 내 밴드
//isUser: true,
//isLeader: true,
//userName: "기타",
//imageName: "guitar",
//다루는악기: ["기타", "보컬"]

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
    
    private lazy var dataSource = makeDataSource()
    weak var delegate: PositionCollectionViewDelegate?
    private var entryPoint: entryPoint
    
    private var positions: [Position] = [Position(instrumentName: "기타", imageName: "guitar", isETC: false),
                                         Position(instrumentName: "드럼", imageName: "drum", isETC: false),
                                         Position(instrumentName: "보컬", imageName: "vocal", isETC: false),
                                         Position(instrumentName: "베이스콘트라베이", imageName: "bass", isETC: false)]
    
    
    // MARK: - init
    
    init(entryPoint: entryPoint) {
        self.entryPoint = entryPoint
        super.init(frame: .zero)
        configureDataSource()
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
    private func makeDataSource() -> UICollectionViewDiffableDataSource<PositionSection, Position> {
        return UICollectionViewDiffableDataSource<PositionSection, Position>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, position in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PositionCollectionViewCell.className, for: indexPath) as? PositionCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(data: position)
            return cell
        })
    }
    
    private func configureDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<PositionSection, Position>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, position in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PositionCollectionViewCell.className, for: indexPath) as? PositionCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(data: position)
            return cell
        })
    }
    
    func applySnapshot(with snapshot: NSDiffableDataSourceSnapshot<PositionSection, Position>) {
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureSelectColorView() {
        var snapshot = NSDiffableDataSourceSnapshot<PositionSection, Position>()
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
