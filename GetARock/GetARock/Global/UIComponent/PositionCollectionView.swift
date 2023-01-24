//
//  PositionCollectionView.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/21.
//

import UIKit

protocol PositionCollectionViewDelegate: AnyObject {
    func canSelectPosition(_ collectionView: UICollectionView, indexPath: IndexPath, selectedItemsCount: Int) -> Bool
}

enum Section: Int {
    case main
}

enum Item: Hashable {
    case bandMember(BandMember)
    case position(Position)
}

final class PositionCollectionView: UIView {
    
    // MARK: - Property
    
    enum EntryPoint {
        case band
        case position
    }
    
    private var entryPoint: EntryPoint
    weak var delegate: PositionCollectionViewDelegate?
    
    private var items: [Item] = []
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = self.makeDataSource()
    
    // MARK: - View
    
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
        switch self.entryPoint {
        case .band:
            collectionView.register(BandMemberCollectionViewCell.self, forCellWithReuseIdentifier: BandMemberCollectionViewCell.className)
        case .position:
            collectionView.register(PositionCollectionViewCell.self, forCellWithReuseIdentifier: PositionCollectionViewCell.className)
        }
        return collectionView
    }()
    
    // MARK: - init
    
    init(entryPoint: EntryPoint, items: [Item]) {
        self.entryPoint = entryPoint
        self.items = items
        super.init(frame: .zero)
        self.setupLayout()
        self.applySnapshot(with: items)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        addSubview(collectionView)
        self.collectionView.constraint(to: self)
    }
}

// MARK: - diffable

extension PositionCollectionView {
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        return UICollectionViewDiffableDataSource<Section, Item>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .bandMember(let bandMember):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BandMemberCollectionViewCell.className, for: indexPath) as? BandMemberCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(data: bandMember)
                return cell
            case .position(let position):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PositionCollectionViewCell.className, for: indexPath) as? PositionCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(data: position)
                return cell
            }
        })
    }
    
    func applySnapshot(with items: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
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

// 머지 이전 삭제 예정
class TestViewController: UIViewController {
    
    //entrypOint position 테스트코드
    private let collectionView = PositionCollectionView(entryPoint: .position, items: [.position(Position(instrumentName: "기타", imageName: "guitar", isETC: false)),
                                                                                   .position(Position(instrumentName: "베이스", imageName: "bass", isETC: false)),
                                                                                   .position(Position(instrumentName: "보컬", imageName: "vocal", isETC: false)),
                                                                                   .position(Position(instrumentName: "drum", imageName: "drum", isETC: false)),
                                                                                       .position(Position(instrumentName: "콘트라베이스으으으", imageName: "etc", isETC: false)),
    ])
    
    //entrypOint band 테스트코드
//    private let collectionView = PositionCollectionView(entryPoint: .band, items: [.bandMember(BandMember(isUser: true, isLeader: true, userName: "콘르아잉이잉베", imageName: "guitar", instrumentNames: ["베이스", "보컬"])), .bandMember(BandMember(isUser: true, isLeader: false, userName: "콘르아잉이잉베", imageName: "guitar", instrumentNames: ["베이스", "보컬"])), .bandMember(BandMember(isUser: true, isLeader: false, userName: "콘르아잉이잉베", imageName: "guitar", instrumentNames: ["베이스", "보컬"])), .bandMember(BandMember(isUser: false, isLeader: false, userName: "콘르아잉이잉베", imageName: "guitar", instrumentNames: ["베이스", "보컬"]))
//    ])
//
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(collectionView)
        collectionView.constraint(top: view.topAnchor,
                                  leading: view.leadingAnchor, bottom: view.bottomAnchor,
                                  trailing: view.trailingAnchor,
        padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        collectionView.delegate = self
    }
}

extension TestViewController: PositionCollectionViewDelegate {
   func canSelectPosition(_ collectionView: UICollectionView, indexPath: IndexPath, selectedItemsCount: Int) -> Bool {
       return true
   }
}
