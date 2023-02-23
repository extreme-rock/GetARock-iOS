//
//  SelectCollectionView.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/25.
//

import UIKit

protocol SelectCollectionViewDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

enum WidthOption {
    case fixed
    case flexable
}

final class SelectCollectionView: UIView {
    
    // MARK: - Property
    
    weak var delegate: SelectCollectionViewDelegate?
    private let items: [String]
    private let cellBackgroundColor: UIColor
    private var widthOption: WidthOption
    private var widthSize: CGFloat
    private var itemSpacing: CGFloat
    
    // MARK: - View
    
    private lazy var collectionView: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(150),
                                              heightDimension: .absolute(46))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(46))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = .fixed(itemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SelectCollectionViewCell.self, forCellWithReuseIdentifier: "SelectCollectionViewCell")
        return collectionView
    }()
    
    //MARK: - Init
    
    init(widthState: WidthOption,
         items: [String],
         widthSize: CGFloat,
         itemSpacing: CGFloat,
         cellBackgroundColor: UIColor) {
        self.widthOption = widthState
        self.items = items
        self.widthSize = widthSize
        self.itemSpacing = itemSpacing
        self.cellBackgroundColor = cellBackgroundColor
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func setupLayout() {
        self.addSubview(collectionView)
        collectionView.constraint(to: self)
    }
    
    func selectedItem() -> String? {
        let selectedIndex = collectionView.indexPathsForSelectedItems?.first
        return items[selectedIndex?.item ?? 0]
    }
    
    func isSelected() -> Bool {
        guard let selectedIndex = collectionView.indexPathsForSelectedItems else { return false }
        let isSelected = !(selectedIndex.isEmpty)
        return isSelected
    }
    
}

extension SelectCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectCollectionViewCell.classIdentifier, for: indexPath) as? SelectCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setupLayout(width: widthSize, widthState: widthOption)
        cell.configure(color: self.cellBackgroundColor, text: self.items[indexPath.item])
        
        return cell
    }
}

extension SelectCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.collectionView(
            collectionView,
            didSelectItemAt: indexPath
        )
    }
}
