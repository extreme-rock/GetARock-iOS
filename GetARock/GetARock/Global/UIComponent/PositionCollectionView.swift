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
    case plusPosition
    
    func name() -> String {
        switch self {
        case .bandMember(let bandMember):
            return bandMember.userName
        case .position(let position):
            return position.instrumentName
        case .plusPosition:
            return ""
        }
    }
}

enum CellSize {
    static let width = (UIScreen.main.bounds.width - 42) / 2
}

final class PositionCollectionView: UIView {
    
    // MARK: - Property
    
    enum CellType {
        case band
        case position
    }
    
    private var cellType: CellType
    weak var delegate: PositionCollectionViewDelegate?
    
    private var items: [Item] = []
    private let isNeedHeader: Bool
    private let headerView: UIView?
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = self.makeDataSource()
    private var selectedCellIndexPaths: [(indexPath: IndexPath, isMain: Bool)] = []
    
    // MARK: - View
    
    private lazy var collectionView: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(CellSize.width),
                                              heightDimension: .absolute(138))
        let item1 = NSCollectionLayoutItem(layoutSize: itemSize)
        let item2 = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(140))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item1, item2])
        
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        if self.isNeedHeader {
            let headerFooterSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(20)
            )
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        switch self.cellType {
        case .band:
            collectionView.isScrollEnabled = false
            collectionView.register(BandMemberCollectionViewCell.self,
                                    forCellWithReuseIdentifier: BandMemberCollectionViewCell.classIdentifier)
        case .position:
            collectionView.register(PositionCollectionViewCell.self,
                                    forCellWithReuseIdentifier: PositionCollectionViewCell.classIdentifier)
            collectionView.register(PlusPositionCollectionViewCell.self,
                                    forCellWithReuseIdentifier: PlusPositionCollectionViewCell.classIdentifier)
            
            collectionView.register(PositionCollectionReusableView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: PositionCollectionReusableView.classIdentifier)
        }
        return collectionView
    }()
    
    // MARK: - init
    
    init(cellType: CellType, items: [Item], isNeedHeader: Bool, headerView: UIView? = nil) {
        self.cellType = cellType
        self.items = items
        self.isNeedHeader = isNeedHeader
        self.headerView = headerView
        super.init(frame: .zero)
        self.setupLayout()
        self.applySnapshot(with: items)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func setupLayout() {
        addSubview(collectionView)
        self.collectionView.constraint(to: self)
    }
    
    func updateCellIndex(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PositionCollectionViewCell else { return }
        cell.cellIndex = indexPath.item
    }
    
    func deselectAllItem() {
        let selectedIndexPath = self.collectionView.indexPathsForSelectedItems
        selectedIndexPath?.forEach {
            self.collectionView.deselectItem(at: $0, animated: true)
        }
        self.postDeselectAllPositionButtonHiddenToggle()
        
        if let mainPositionTuple = selectedCellIndexPaths.first {
            self.removeMainLabel(indexPath: mainPositionTuple.indexPath)
            self.selectedCellIndexPaths = []
        }
    }
    
    private func postDeselectAllPositionButtonHiddenToggle() {
        NotificationCenter.default.post(
            name: Notification.Name.hideDeselectAllPositionButton,
            object: nil)
    }
    
    private func postDidTapPositionItem() {
        NotificationCenter.default.post(
            name: Notification.Name.didTapPositionItem,
            object: nil)
    }
    
    func selectItems(with instrumentList: [InstrumentList]) {
        for instrument in instrumentList {
            guard let index = self.items.firstIndex(where: { $0.name() == instrument.name }) else { return }
            let indexPath = IndexPath(row: index, section: 0)
            self.selectedCellIndexPaths.append((indexPath: indexPath, isMain: false))
            self.collectionView.selectItem(at: indexPath,
                                           animated: true,
                                           scrollPosition: .top)
        }
        self.selectedCellIndexPaths[0].isMain = true
        
        guard let mainInstrumentIndexPath = self.selectedCellIndexPaths.first?.indexPath else { return }
        
        // makrMainLabel 함수가 실행되는 시점을 늦추기 위해 main queue에서 async로 실행(?) 이렇게 사용하는게 맞나..
        
        DispatchQueue.main.async {
            self.markMainLabel(indexPath: mainInstrumentIndexPath)
            self.postDeselectAllPositionButtonHiddenToggle()
        }
    }
}

// MARK: - DiffableDataSource

extension PositionCollectionView {
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .bandMember(let bandMember):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BandMemberCollectionViewCell.classIdentifier, for: indexPath) as? BandMemberCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(data: bandMember)
                return cell
                
            case .position(let position):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PositionCollectionViewCell.classIdentifier, for: indexPath) as? PositionCollectionViewCell else { return UICollectionViewCell() }
                if position.isETC {
                    cell.setupDeleteButton()
                }
                cell.configure(data: position, indexPath: indexPath)
                return cell
                
            case .plusPosition:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlusPositionCollectionViewCell.classIdentifier, for: indexPath) as? PlusPositionCollectionViewCell else { return UICollectionViewCell() }
                return cell
            }
        })
        
        if isNeedHeader {
            dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
                guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
                let view = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: PositionCollectionReusableView.classIdentifier,
                    for: indexPath) as? PositionCollectionReusableView
                view?.setupLayout(view: self.headerView ?? UIView())
                return view
            }
        }
        return dataSource
    }
    
    func applySnapshot(with items: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate

extension PositionCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let selectedPositionCount = collectionView.indexPathsForSelectedItems?.count ?? 0
        guard let canSelect = delegate?.canSelectPosition(collectionView, indexPath: indexPath, selectedItemsCount: selectedPositionCount) else { return false }
        return canSelect
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCellIndexPaths.append((indexPath: indexPath,
                                            isMain: selectedCellIndexPaths.isEmpty ? true : false))
        
        let selectedCellCount = collectionView.indexPathsForSelectedItems?.count
        if selectedCellCount == 1 {
            postDeselectAllPositionButtonHiddenToggle()
            markMainLabel(indexPath: indexPath)
        }
        postDidTapPositionItem()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let indexOfSelectedCell = self.selectedCellIndexPaths.firstIndex(where: { element in
            element.indexPath == indexPath
        }) else { return }
        
        let deselectedCell = selectedCellIndexPaths.remove(at: indexOfSelectedCell)
        if deselectedCell.isMain {
            removeMainLabel(indexPath: indexPath)
            if let mainPosition = selectedCellIndexPaths.first {
                selectedCellIndexPaths[0].isMain = true
                markMainLabel(indexPath: mainPosition.indexPath)
            }
        }
        
        let selectedCellCount = collectionView.indexPathsForSelectedItems?.count
        if selectedCellCount == 0 {
            postDeselectAllPositionButtonHiddenToggle()
        }
        postDidTapPositionItem()
    }
    
    private func markMainLabel(indexPath: IndexPath) {
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? PositionCollectionViewCell else { return }
        cell.setupMainLabelLayout()
    }
    
    private func removeMainLabel(indexPath: IndexPath) {
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? PositionCollectionViewCell else { return }
        cell.removeMainLabel()
    }
}

//MARK: 선택된 포지션 데이터 추출

extension PositionCollectionView {
    func getSelectedInstruments() -> [InstrumentList] {
        let selectedIndexPaths = self.collectionView.indexPathsForSelectedItems ?? []
        let selectedInstruments: [InstrumentList] = selectedIndexPaths.map {
            let index = $0.item
            return InstrumentList(name: self.items[index].name())
        }
        return selectedInstruments
    }
}
